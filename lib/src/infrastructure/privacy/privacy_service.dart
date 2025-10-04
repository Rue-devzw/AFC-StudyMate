import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../domain/bible/reading_progress/repositories.dart';
import '../../domain/settings/repositories.dart';
import '../../domain/sync/entities.dart';
import '../../domain/sync/repositories.dart';
import '../db/app_database.dart';
import '../db/daos/sync_dao.dart';
import '../privacy/privacy_remote_data_source.dart';

class PrivacyExportResult {
  const PrivacyExportResult({required this.file, required this.snapshot});

  final File file;
  final Map<String, dynamic> snapshot;
}

class PrivacyService {
  PrivacyService({
    required AppDatabase db,
    required SyncDao syncDao,
    required SyncRepository syncRepository,
    required ReadingProgressRepository readingProgressRepository,
    required SettingsRepository settingsRepository,
    PrivacyRemoteDataSource? remoteDataSource,
  })  : _db = db,
        _syncDao = syncDao,
        _syncRepository = syncRepository,
        _readingProgressRepository = readingProgressRepository,
        _settingsRepository = settingsRepository,
        _remote = remoteDataSource ?? const NoopPrivacyRemoteDataSource();

  final AppDatabase _db;
  final SyncDao _syncDao;
  final SyncRepository _syncRepository;
  final ReadingProgressRepository _readingProgressRepository;
  final SettingsRepository _settingsRepository;
  final PrivacyRemoteDataSource _remote;

  Future<PrivacyExportResult> exportUserData(
    String userId, {
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? additional,
  }) async {
    await _db.ensureSeeded();
    final snapshot = await _collectDatabaseSnapshot(userId);
    final export = <String, dynamic>{
      'userId': userId,
      'generatedAt': DateTime.now().toIso8601String(),
      'data': snapshot,
    };
    if (preferences != null && preferences.isNotEmpty) {
      export['preferences'] = preferences;
    }
    if (additional != null && additional.isNotEmpty) {
      export['additional'] = additional;
    }
    final directory = await getTemporaryDirectory();
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final file = File(p.join(directory.path, 'studymate-export-$timestamp.json'));
    final encoder = const JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(export));
    return PrivacyExportResult(file: file, snapshot: export);
  }

  Future<Map<String, dynamic>> _collectDatabaseSnapshot(String userId) async {
    final notes = await _rows(
      'SELECT id, translation_id, book_id, chapter, verse, text, version, updated_at '
      'FROM notes WHERE user_id = ?',
      [Variable<String>(userId)],
    );
    final noteHistory = await _rows(
      'SELECT note_id, version, text, updated_at FROM note_revisions '
      'WHERE note_id IN (SELECT id FROM notes WHERE user_id = ?)',
      [Variable<String>(userId)],
    );
    final bookmarks = await _rows(
      'SELECT id, translation_id, book_id, chapter, verse, created_at '
      'FROM bookmarks WHERE user_id = ?',
      [Variable<String>(userId)],
    );
    final highlights = await _rows(
      'SELECT id, translation_id, book_id, chapter, verse, colour, created_at '
      'FROM highlights WHERE user_id = ?',
      [Variable<String>(userId)],
    );
    final progress = await _rows(
      'SELECT id, lesson_id, status, quiz_score, time_spent_seconds, updated_at, '
      'started_at, completed_at FROM progress WHERE user_id = ?',
      [Variable<String>(userId)],
    );
    final messages = await _rows(
      'SELECT id, class_id, body, created_at, updated_at FROM messages '
      'WHERE user_id = ?',
      [Variable<String>(userId)],
    );
    final localUser = await _rows(
      'SELECT id, display_name, avatar_url, preferred_cohort_id, '
      'preferred_cohort_title, preferred_lesson_class '
      'FROM local_users WHERE id = ? LIMIT 1',
      [Variable<String>(userId)],
    );
    final queue = await _rows(
      'SELECT id, op_type, payload, created_at, attempts, last_tried_at '
      'FROM sync_queue WHERE user_id = ?',
      [Variable<String>(userId)],
    );

    return {
      'notes': notes,
      'noteRevisions': noteHistory,
      'bookmarks': bookmarks,
      'highlights': highlights,
      'lessonProgress': progress,
      'messages': messages,
      'syncQueue': queue,
      'profile': localUser.isEmpty ? null : localUser.first,
    };
  }

  Future<List<Map<String, dynamic>>> _rows(
    String query,
    List<Variable<String>> variables,
  ) async {
    final result = await _db
        .customSelect(query, variables: List<Variable>.from(variables))
        .get();
    return result.map((row) => Map<String, dynamic>.from(row.data)).toList();
  }

  Future<void> deleteUserData(String userId) async {
    await _db.ensureSeeded();
    final notes = await _rows(
      'SELECT id, translation_id, book_id, chapter, verse FROM notes WHERE user_id = ?',
      [Variable<String>(userId)],
    );
    final progressRows = await _rows(
      'SELECT id FROM progress WHERE user_id = ?',
      [Variable<String>(userId)],
    );
    final messageRows = await _rows(
      'SELECT id FROM messages WHERE user_id = ?',
      [Variable<String>(userId)],
    );

    await _db.transaction(() async {
      await _db.customStatement('DELETE FROM sync_queue WHERE user_id = ?', [userId]);
      await _db.customStatement('DELETE FROM bookmarks WHERE user_id = ?', [userId]);
      await _db.customStatement('DELETE FROM highlights WHERE user_id = ?', [userId]);
      await _db.customStatement('DELETE FROM notes WHERE user_id = ?', [userId]);
      await _db.customStatement('DELETE FROM progress WHERE user_id = ?', [userId]);
      await _db.customStatement('DELETE FROM messages WHERE user_id = ?', [userId]);
      await _db.customStatement(
        'UPDATE local_users SET display_name = NULL, avatar_url = NULL, '
        'preferred_cohort_id = NULL, preferred_cohort_title = NULL, '
        'preferred_lesson_class = NULL WHERE id = ?',
        [userId],
      );
    });

    final now = DateTime.now();
    for (final note in notes) {
      final noteId = note['id'] as String;
      final payload = <String, dynamic>{
        'noteId': noteId,
        'updatedAt': now.millisecondsSinceEpoch,
        'deleted': true,
      };
      if (note.containsKey('translation_id')) {
        payload['translationId'] = note['translation_id'];
        payload['bookId'] = note['book_id'];
        payload['chapter'] = note['chapter'];
        payload['verse'] = note['verse'];
      }
      await _syncDao.recordNoteChange(
        noteId: noteId,
        userId: userId,
        localUpdatedAt: now.millisecondsSinceEpoch,
        operation: 'delete',
      );
      await _syncRepository.enqueue(
        SyncOperation(
          id: 'note:$noteId',
          userId: userId,
          opType: 'note.delete',
          payload: payload,
          createdAt: now,
        ),
      );
    }

    for (final row in progressRows) {
      final progressId = row['id'] as String;
      await _syncDao.recordProgressChange(
        progressId: progressId,
        userId: userId,
        localUpdatedAt: now.millisecondsSinceEpoch,
        operation: 'delete',
      );
      await _syncRepository.enqueue(
        SyncOperation(
          id: 'progress:$progressId',
          userId: userId,
          opType: 'progress.delete',
          payload: {
            'progressId': progressId,
            'updatedAt': now.millisecondsSinceEpoch,
            'deleted': true,
          },
          createdAt: now,
        ),
      );
    }

    for (final row in messageRows) {
      final messageId = row['id'] as String;
      await _syncDao.recordMessageChange(
        messageId: messageId,
        userId: userId,
        localUpdatedAt: now.millisecondsSinceEpoch,
        operation: 'delete',
      );
      await _syncRepository.enqueue(
        SyncOperation(
          id: 'message:$messageId',
          userId: userId,
          opType: 'message.delete',
          payload: {
            'messageId': messageId,
            'updatedAt': now.millisecondsSinceEpoch,
            'deleted': true,
          },
          createdAt: now,
        ),
      );
    }

    await _readingProgressRepository.clear(userId);
    await _settingsRepository.clearThemeMode(userId);

    try {
      await _remote.deleteUserData(userId);
    } catch (error) {
      throw Exception(
        'Remote deletion request failed: $error. Local data was already removed.',
      );
    }
  }
}
