import 'dart:async';
import 'dart:math' as math;

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';

import '../../domain/accounts/repositories.dart';
import '../../domain/sync/entities.dart';
import '../../domain/sync/repositories.dart';
import '../db/app_database.dart' as app_db;
import '../db/daos/sync_dao.dart';
import '../db/daos/account_dao.dart';
import '../../data/accounts/account_repository_impl.dart';
import '../../data/sync/sync_repository_impl.dart';

const String kDataSyncBackgroundTask = 'afc_data_sync';

class SyncOrchestrator {
  SyncOrchestrator({
    required app_db.AppDatabase db,
    required SyncRepository syncRepository,
    required AccountRepository accountRepository,
    required SyncRemoteDataSource remoteDataSource,
    SyncDao? syncDao,
    bool observeQueue = true,
    Duration initialBackoff = const Duration(seconds: 5),
    Duration maxBackoff = const Duration(minutes: 5),
    int batchSize = 25,
  })  : _db = db,
        _syncRepository = syncRepository,
        _accountRepository = accountRepository,
        _remoteDataSource = remoteDataSource,
        _syncDao = syncDao ?? SyncDao(db),
        _initialBackoff = initialBackoff,
        _maxBackoff = maxBackoff,
        _batchSize = batchSize {
    if (observeQueue) {
      _queueSub = _syncRepository.watchQueue().listen((operations) {
        _updateStatus(
          _status.copyWith(pendingOperations: operations.length),
        );
      });
    }
  }

  final app_db.AppDatabase _db;
  final SyncRepository _syncRepository;
  final AccountRepository _accountRepository;
  final SyncRemoteDataSource _remoteDataSource;
  final SyncDao _syncDao;
  final Duration _initialBackoff;
  final Duration _maxBackoff;
  final int _batchSize;

  final _statusController = StreamController<SyncStatus>.broadcast();
  StreamSubscription<List<SyncOperation>>? _queueSub;

  SyncStatus _status = const SyncStatus();
  bool _disposed = false;
  bool _isSyncing = false;

  Stream<SyncStatus> get statusStream => _statusController.stream;
  SyncStatus get status => _status;

  Future<void> dispose() async {
    if (_disposed) {
      return;
    }
    _disposed = true;
    await _queueSub?.cancel();
    await _statusController.close();
  }

  Future<void> ensureBackgroundScheduled() async {
    try {
      await Workmanager().registerPeriodicTask(
        kDataSyncBackgroundTask,
        kDataSyncBackgroundTask,
        frequency: const Duration(hours: 1),
        initialDelay: const Duration(minutes: 10),
        existingWorkPolicy: ExistingWorkPolicy.keep,
        backoffPolicy: BackoffPolicy.exponential,
        backoffPolicyDelay: const Duration(minutes: 5),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
      );
    } catch (error) {
      if (kDebugMode) {
        debugPrint('Failed to schedule data sync: $error');
      }
    }
  }

  Future<void> syncNow({bool manual = false}) async {
    if (_disposed || _isSyncing) {
      return;
    }
    _isSyncing = true;
    _updateStatus(
      _status.copyWith(
        isSyncing: true,
        lastSyncWasManual: manual,
        clearLastError: true,
      ),
    );

    try {
      final pending = await _syncRepository.fetchPending(limit: _batchSize);
      await _processOperations(pending);
      await _pullRemoteChanges();
      _updateStatus(
        _status.copyWith(
          isSyncing: false,
          lastSyncedAt: DateTime.now(),
          lastSyncWasManual: manual,
        ),
      );
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('Data sync failed: $error\n$stackTrace');
      }
      _updateStatus(
        _status.copyWith(
          isSyncing: false,
          lastError: error.toString(),
          lastSyncWasManual: manual,
        ),
      );
      rethrow;
    } finally {
      _isSyncing = false;
    }
  }

  void _updateStatus(SyncStatus status) {
    _status = status;
    if (!_statusController.isClosed) {
      _statusController.add(status);
    }
  }

  Future<void> _processOperations(List<SyncOperation> operations) async {
    if (operations.isEmpty) {
      return;
    }
    final ready = operations.where(_isReadyForAttempt).toList();
    if (ready.isEmpty) {
      return;
    }

    final grouped = <String, List<SyncOperation>>{};
    for (final operation in ready) {
      grouped.putIfAbsent(operation.userId, () => <SyncOperation>[]).add(operation);
    }

    final errors = <Object>[];
    for (final entry in grouped.entries) {
      final batches = _chunk(entry.value, _batchSize);
      for (final batch in batches) {
        try {
          await _sendBatch(entry.key, batch);
        } catch (error) {
          errors.add(error);
        }
      }
    }

    if (errors.isNotEmpty) {
      throw Exception('Failed to push ${errors.length} operation batches');
    }
  }

  Future<void> _sendBatch(String userId, List<SyncOperation> operations) async {
    if (operations.isEmpty) {
      return;
    }
    try {
      final result = await _remoteDataSource.push(userId, operations);
      final successes = result.appliedOperationIds.toSet();
      if (successes.isNotEmpty) {
        await _syncRepository.removeMany(successes);
        for (final operation in operations) {
          if (successes.contains(operation.id)) {
            await _markTrackerSyncedFromPush(operation);
          }
        }
      }
      if (result.failedOperationIds.isNotEmpty) {
        await _syncRepository.markAttempts(result.failedOperationIds.keys);
      }
      for (final conflict in result.conflicts) {
        await _handlePushConflict(conflict);
      }
    } catch (error) {
      await _syncRepository.markAttempts(operations.map((op) => op.id));
      rethrow;
    }
  }

  bool _isReadyForAttempt(SyncOperation operation) {
    if (operation.attempts <= 0 || operation.lastTriedAt == null) {
      return true;
    }
    final delay = _computeBackoff(operation.attempts);
    final nextAttempt = operation.lastTriedAt!.add(delay);
    return DateTime.now().isAfter(nextAttempt);
  }

  Duration _computeBackoff(int attempts) {
    final exponent = math.max(0, attempts - 1);
    final raw = _initialBackoff.inMilliseconds * math.pow(2, exponent);
    final capped = math.min(raw, _maxBackoff.inMilliseconds.toDouble());
    return Duration(milliseconds: capped.toInt());
  }

  Future<void> _markTrackerSyncedFromPush(SyncOperation operation) async {
    final payload = operation.payload;
    final updatedAt = _intFromPayload(payload['updatedAt']);
    if (updatedAt == null) {
      return;
    }
    switch (operation.opType) {
      case 'note.upsert':
      case 'note.delete':
        final noteId = payload['noteId'] as String?;
        if (noteId != null) {
          await _syncDao.markNoteSynced(noteId, updatedAt, userId: operation.userId);
        }
        break;
      case 'progress.upsert':
      case 'progress.delete':
        final progressId = payload['progressId'] as String?;
        if (progressId != null) {
          await _syncDao.markProgressSynced(progressId, updatedAt, userId: operation.userId);
        }
        break;
      case 'message.upsert':
      case 'message.delete':
        final messageId = payload['messageId'] as String?;
        if (messageId != null) {
          await _syncDao.markMessageSynced(messageId, updatedAt, userId: operation.userId);
        }
        break;
      default:
        break;
    }
  }

  Future<void> _handlePushConflict(SyncPushConflict conflict) {
    switch (conflict.entityType) {
      case SyncEntityType.note:
        return _syncDao.markNoteConflict(
          conflict.entityId,
          reason: conflict.message,
          remoteSnapshot: conflict.remoteSnapshot,
        );
      case SyncEntityType.progress:
        return _syncDao.markProgressConflict(
          conflict.entityId,
          reason: conflict.message,
          remoteSnapshot: conflict.remoteSnapshot,
        );
      case SyncEntityType.message:
        return _syncDao.markMessageConflict(
          conflict.entityId,
          reason: conflict.message,
          remoteSnapshot: conflict.remoteSnapshot,
        );
    }
  }

  Future<void> _pullRemoteChanges() async {
    final accounts = await _accountRepository.getAccounts();
    if (accounts.isEmpty) {
      return;
    }
    for (final account in accounts) {
      final changes =
          await _remoteDataSource.pull(account.id, since: _status.lastSyncedAt);
      await _applyRemoteChanges(account.id, changes);
    }
  }

  Future<void> _applyRemoteChanges(String userId, RemoteChangeSet changes) async {
    for (final change in changes.notes) {
      await _applyRemoteNoteChange(change);
    }
    for (final change in changes.progress) {
      await _applyRemoteProgressChange(change);
    }
    for (final change in changes.messages) {
      await _applyRemoteMessageChange(change);
    }
  }

  Future<void> _applyRemoteNoteChange(RemoteNoteChange change) async {
    await _db.transaction(() async {
      final existing = await (_db.select(_db.notes)
            ..where((tbl) =>
                tbl.id.equals(change.noteId) &
                tbl.userId.equals(change.userId)))
          .getSingleOrNull();
      final localUpdatedAt = existing?.updatedAt ?? 0;
      if (change.deleted) {
        if (existing != null && change.updatedAt >= localUpdatedAt) {
          await (_db.delete(_db.notes)
                ..where((tbl) =>
                    tbl.id.equals(change.noteId) &
                    tbl.userId.equals(change.userId)))
            .go();
          await _syncDao.markNoteSynced(change.noteId, change.updatedAt,
              userId: change.userId);
        } else if (existing != null) {
          await _syncDao.markNoteConflict(
            change.noteId,
            reason: 'remote_deleted',
            remoteSnapshot: change.toJson(),
          );
        }
        return;
      }

      if (existing == null || change.updatedAt > localUpdatedAt) {
        if (existing != null) {
          await _db.into(_db.noteRevisions).insert(
                app_db.NoteRevisionsCompanion.insert(
                  noteId: existing.id,
                  version: existing.version,
                  revisionText: existing.noteText,
                  updatedAt: existing.updatedAt,
                ),
                mode: InsertMode.insertOrReplace,
              );
        }
        await _db.into(_db.notes).insertOnConflictUpdate(
              app_db.NotesCompanion(
                id: Value(change.noteId),
                userId: Value(change.userId),
                translationId: Value(change.translationId),
                bookId: Value(change.bookId),
                chapter: Value(change.chapter),
                verse: Value(change.verse),
                noteText: Value(change.text),
                version: Value(change.version),
                updatedAt: Value(change.updatedAt),
              ),
            );
        await _db.into(_db.noteRevisions).insert(
              app_db.NoteRevisionsCompanion.insert(
                noteId: change.noteId,
                version: change.version,
                revisionText: change.text,
                updatedAt: change.updatedAt,
              ),
              mode: InsertMode.insertOrReplace,
            );
        await _syncDao.markNoteSynced(change.noteId, change.updatedAt,
            userId: change.userId);
      } else if (change.updatedAt < localUpdatedAt) {
        await _syncDao.markNoteConflict(
          change.noteId,
          reason: 'local_newer',
          remoteSnapshot: change.toJson(),
        );
      } else if (existing != null && existing.noteText != change.text) {
        await _syncDao.markNoteConflict(
          change.noteId,
          reason: 'content_mismatch',
          remoteSnapshot: change.toJson(),
        );
      }
    });
  }

  Future<void> _applyRemoteProgressChange(RemoteProgressChange change) async {
    final existing = await (_db.select(_db.progress)
          ..where((tbl) => (tbl as dynamic).id.equals(change.progressId)))
        .getSingleOrNull();
    final localUpdatedAt = existing?.updatedAt ?? 0;
    if (change.deleted) {
      if (existing != null && change.updatedAt >= localUpdatedAt) {
        await (_db.delete(_db.progress)
              ..where((tbl) => (tbl as dynamic).id.equals(change.progressId)))
            .go();
        await _syncDao.markProgressSynced(change.progressId, change.updatedAt,
            userId: change.userId);
      } else if (existing != null) {
        await _syncDao.markProgressConflict(
          change.progressId,
          reason: 'remote_deleted',
          remoteSnapshot: change.toJson(),
        );
      }
      return;
    }

    if (existing == null || change.updatedAt > localUpdatedAt) {
      await _db.into(_db.progress).insertOnConflictUpdate(
            app_db.ProgressCompanion(
              id: Value(change.progressId),
              userId: Value(change.userId),
              lessonId: Value(change.lessonId),
              status: Value(change.status),
              quizScore: Value(change.quizScore),
              timeSpentSeconds: Value(change.timeSpentSeconds),
              updatedAt: Value(change.updatedAt),
              startedAt: change.startedAt == null
                  ? const Value.absent()
                  : Value(change.startedAt!),
              completedAt: change.completedAt == null
                  ? const Value.absent()
                  : Value(change.completedAt!),
            ) as dynamic,
          );
      await _syncDao.markProgressSynced(change.progressId, change.updatedAt,
          userId: change.userId);
    } else if (change.updatedAt < localUpdatedAt) {
      await _syncDao.markProgressConflict(
        change.progressId,
        reason: 'local_newer',
        remoteSnapshot: change.toJson(),
      );
    } else if (existing != null &&
        (existing.status != change.status ||
            (existing.quizScore ?? 0) != (change.quizScore ?? 0) ||
            existing.timeSpentSeconds != change.timeSpentSeconds)) {
      await _syncDao.markProgressConflict(
        change.progressId,
        reason: 'content_mismatch',
        remoteSnapshot: change.toJson(),
      );
    }
  }

  Future<void> _applyRemoteMessageChange(RemoteMessageChange change) async {
    final existing = await (_db.select(_db.messages)
          ..where((tbl) => (tbl as dynamic).id.equals(change.messageId)))
        .getSingleOrNull();
    final localUpdatedAt = existing?.updatedAt ?? existing?.createdAt ?? 0;
    if (change.deleted) {
      if (existing != null && change.updatedAt >= localUpdatedAt) {
        await (_db.update(_db.messages)
              ..where((tbl) => (tbl as dynamic).id.equals(change.messageId)))
            .write(
          app_db.MessagesCompanion(
            deleted: const Value(true),
            updatedAt: Value(change.updatedAt),
          ) as dynamic,
        );
        await _syncDao.markMessageSynced(change.messageId, change.updatedAt,
            userId: change.userId);
      } else if (existing != null) {
        await _syncDao.markMessageConflict(
          change.messageId,
          reason: 'remote_deleted',
          remoteSnapshot: change.toJson(),
        );
      }
      return;
    }

    if (existing == null || change.updatedAt > localUpdatedAt) {
      await _db.into(_db.messages).insertOnConflictUpdate(
            app_db.MessagesCompanion(
              id: Value(change.messageId),
              classId: Value(change.classId),
              userId: Value(change.userId),
              body: Value(change.body),
              createdAt: Value(change.createdAt),
              updatedAt: Value(change.updatedAt),
              deleted: Value(change.deleted),
              flagged: Value(change.flagged),
            ) as dynamic,
          );
      await _syncDao.markMessageSynced(change.messageId, change.updatedAt,
          userId: change.userId);
    } else if (change.updatedAt < localUpdatedAt) {
      await _syncDao.markMessageConflict(
        change.messageId,
        reason: 'local_newer',
        remoteSnapshot: change.toJson(),
      );
    } else if (existing != null &&
        (existing.body != change.body ||
            existing.flagged != change.flagged ||
            existing.deleted != change.deleted)) {
      await _syncDao.markMessageConflict(
        change.messageId,
        reason: 'content_mismatch',
        remoteSnapshot: change.toJson(),
      );
    }
  }

  List<List<T>> _chunk<T>(List<T> source, int size) {
    if (source.length <= size) {
      return [source];
    }
    final result = <List<T>>[];
    for (var i = 0; i < source.length; i += size) {
      final end = source.length < i + size ? source.length : i + size;
      result.add(source.sublist(i, end));
    }
    return result;
  }

  int? _intFromPayload(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is double) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }
}

abstract class SyncRemoteDataSource {
  Future<SyncPushResult> push(String userId, List<SyncOperation> operations);

  Future<RemoteChangeSet> pull(String userId, {DateTime? since});
}

class SyncPushResult {
  const SyncPushResult({
    required this.appliedOperationIds,
    this.failedOperationIds = const {},
    this.conflicts = const <SyncPushConflict>[],
  });

  final List<String> appliedOperationIds;
  final Map<String, String> failedOperationIds;
  final List<SyncPushConflict> conflicts;
}

class SyncPushConflict {
  const SyncPushConflict({
    required this.operationId,
    required this.entityType,
    required this.entityId,
    required this.userId,
    required this.message,
    this.remoteSnapshot,
  });

  final String operationId;
  final SyncEntityType entityType;
  final String entityId;
  final String userId;
  final String message;
  final Map<String, dynamic>? remoteSnapshot;
}

class RemoteChangeSet {
  const RemoteChangeSet({
    this.notes = const <RemoteNoteChange>[],
    this.progress = const <RemoteProgressChange>[],
    this.messages = const <RemoteMessageChange>[],
  });

  final List<RemoteNoteChange> notes;
  final List<RemoteProgressChange> progress;
  final List<RemoteMessageChange> messages;

  bool get hasChanges =>
      notes.isNotEmpty || progress.isNotEmpty || messages.isNotEmpty;
}

class RemoteNoteChange {
  const RemoteNoteChange({
    required this.noteId,
    required this.userId,
    required this.translationId,
    required this.bookId,
    required this.chapter,
    required this.verse,
    required this.text,
    required this.version,
    required this.updatedAt,
    this.deleted = false,
  });

  final String noteId;
  final String userId;
  final String translationId;
  final int bookId;
  final int chapter;
  final int verse;
  final String text;
  final int version;
  final int updatedAt;
  final bool deleted;

  Map<String, dynamic> toJson() => {
        'noteId': noteId,
        'userId': userId,
        'translationId': translationId,
        'bookId': bookId,
        'chapter': chapter,
        'verse': verse,
        'text': text,
        'version': version,
        'updatedAt': updatedAt,
        'deleted': deleted,
      };
}

class RemoteProgressChange {
  const RemoteProgressChange({
    required this.progressId,
    required this.userId,
    required this.lessonId,
    required this.status,
    required this.timeSpentSeconds,
    required this.updatedAt,
    this.quizScore,
    this.startedAt,
    this.completedAt,
    this.deleted = false,
  });

  final String progressId;
  final String userId;
  final String lessonId;
  final String status;
  final double? quizScore;
  final int timeSpentSeconds;
  final int updatedAt;
  final int? startedAt;
  final int? completedAt;
  final bool deleted;

  Map<String, dynamic> toJson() => {
        'progressId': progressId,
        'userId': userId,
        'lessonId': lessonId,
        'status': status,
        'quizScore': quizScore,
        'timeSpentSeconds': timeSpentSeconds,
        'updatedAt': updatedAt,
        'startedAt': startedAt,
        'completedAt': completedAt,
        'deleted': deleted,
      };
}

class RemoteMessageChange {
  const RemoteMessageChange({
    required this.messageId,
    required this.classId,
    required this.userId,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
    this.deleted = false,
    this.flagged = false,
  });

  final String messageId;
  final String classId;
  final String userId;
  final String body;
  final int createdAt;
  final int updatedAt;
  final bool deleted;
  final bool flagged;

  Map<String, dynamic> toJson() => {
        'messageId': messageId,
        'classId': classId,
        'userId': userId,
        'body': body,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deleted': deleted,
        'flagged': flagged,
      };
}

class NoopSyncRemoteDataSource implements SyncRemoteDataSource {
  const NoopSyncRemoteDataSource();

  @override
  Future<SyncPushResult> push(
    String userId,
    List<SyncOperation> operations,
  ) async {
    return SyncPushResult(
      appliedOperationIds: operations.map((op) => op.id).toList(),
    );
  }

  @override
  Future<RemoteChangeSet> pull(String userId, {DateTime? since}) async {
    return const RemoteChangeSet();
  }
}

@pragma('vm:entry-point')
Future<bool> runDataSyncTask() async {
  final db = app_db.AppDatabase();
  final syncDao = SyncDao(db);
  final accountDao = AccountDao(db);
  final accountRepository = AccountRepositoryImpl(db, accountDao);
  final syncRepository = SyncRepositoryImpl(db, syncDao);
  final orchestrator = SyncOrchestrator(
    db: db,
    syncRepository: syncRepository,
    accountRepository: accountRepository,
    remoteDataSource: const NoopSyncRemoteDataSource(),
    syncDao: syncDao,
    observeQueue: false,
  );
  try {
    await orchestrator.syncNow();
    await orchestrator.dispose();
    await db.close();
    return true;
  } catch (_) {
    await orchestrator.dispose();
    await db.close();
    return false;
  }
}
