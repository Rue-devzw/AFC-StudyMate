import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/annotations/entities.dart';
import '../../domain/annotations/repositories.dart';
import '../../domain/sync/entities.dart';
import '../../domain/sync/repositories.dart';
import '../../infrastructure/db/app_database.dart';
import '../../infrastructure/db/daos/annotation_dao.dart';
import '../../infrastructure/db/daos/sync_dao.dart';

class AnnotationRepositoryImpl implements AnnotationRepository {
  AnnotationRepositoryImpl(
    this._db,
    this._dao,
    this._syncDao,
    this._syncRepository,
  );

  final AppDatabase _db;
  final AnnotationDao _dao;
  final SyncDao _syncDao;
  final SyncRepository _syncRepository;
  final Uuid _uuid = const Uuid();

  Future<void> _ensureSeeded() => _db.ensureSeeded();

  @override
  Stream<List<Bookmark>> watchBookmarksForChapter(
    String userId,
    String translationId,
    int bookId,
    int chapter,
  ) async* {
    await _ensureSeeded();
    yield* _dao
        .watchBookmarksForChapter(userId, translationId, bookId, chapter)
        .map((rows) => rows.map(_mapBookmark).toList());
  }

  @override
  Future<Bookmark?> findBookmark(
    String userId,
    String translationId,
    int bookId,
    int chapter,
    int verse,
  ) async {
    await _ensureSeeded();
    final row =
        await _dao.findBookmark(userId, translationId, bookId, chapter, verse);
    return row == null ? null : _mapBookmark(row);
  }

  @override
  Future<Bookmark> createBookmark(String userId, VerseLocation location) async {
    await _ensureSeeded();
    final id = _uuid.v4();
    final now = DateTime.now();
    await _dao.insertBookmark(
      BookmarksCompanion.insert(
        id: id,
        userId: Value(userId),
        translationId: location.translationId,
        bookId: location.bookId,
        chapter: location.chapter,
        verse: location.verse,
        createdAt: now.millisecondsSinceEpoch,
      ),
    );
    return Bookmark(id: id, location: location, createdAt: now);
  }

  @override
  Future<void> deleteBookmark(String userId, String id) {
    return _dao.deleteBookmark(userId, id);
  }

  @override
  Stream<List<Highlight>> watchHighlightsForChapter(
    String userId,
    String translationId,
    int bookId,
    int chapter,
  ) async* {
    await _ensureSeeded();
    yield* _dao
        .watchHighlightsForChapter(userId, translationId, bookId, chapter)
        .map((rows) => rows.map(_mapHighlight).toList());
  }

  @override
  Future<Highlight?> findHighlight(
    String userId,
    String translationId,
    int bookId,
    int chapter,
    int verse,
  ) async {
    await _ensureSeeded();
    final row = await _dao.findHighlight(
      userId,
      translationId,
      bookId,
      chapter,
      verse,
    );
    return row == null ? null : _mapHighlight(row);
  }

  @override
  Future<Highlight> saveHighlight(String userId, Highlight highlight) async {
    await _ensureSeeded();
    final id = highlight.id.isEmpty ? _uuid.v4() : highlight.id;
    final now = DateTime.now();
    await _dao.upsertHighlight(
      HighlightsCompanion.insert(
        id: id,
        userId: Value(userId),
        translationId: highlight.location.translationId,
        bookId: highlight.location.bookId,
        chapter: highlight.location.chapter,
        verse: highlight.location.verse,
        colour: highlight.colour,
        createdAt: now.millisecondsSinceEpoch,
      ),
    );
    return Highlight(
      id: id,
      location: highlight.location,
      colour: highlight.colour,
      createdAt: now,
    );
  }

  @override
  Future<void> deleteHighlight(String userId, String id) {
    return _dao.deleteHighlight(userId, id);
  }

  @override
  Stream<List<Note>> watchNotesForChapter(
    String userId,
    String translationId,
    int bookId,
    int chapter,
  ) async* {
    await _ensureSeeded();
    yield* _dao
        .watchNotesForChapter(userId, translationId, bookId, chapter)
        .asyncMap((rows) async {
      final notes = <Note>[];
      for (final row in rows) {
        final historyRows = await _dao.getRevisions(userId, row.id);
        notes.add(_mapNote(row, historyRows));
      }
      return notes;
    });
  }

  @override
  Future<Note?> findNote(
    String userId,
    String translationId,
    int bookId,
    int chapter,
    int verse,
  ) async {
    await _ensureSeeded();
    final row = await _dao.findNote(
      userId,
      translationId,
      bookId,
      chapter,
      verse,
    );
    if (row == null) {
      return null;
    }
    final historyRows = await _dao.getRevisions(userId, row.id);
    return _mapNote(row, historyRows);
  }

  @override
  Future<Note> saveNote(
    String userId,
    VerseLocation location,
    String text,
  ) async {
    await _ensureSeeded();
    final now = DateTime.now();
    final existing = await _dao.findNote(
      userId,
      location.translationId,
      location.bookId,
      location.chapter,
      location.verse,
    );
    if (existing == null) {
      final id = _uuid.v4();
      await _dao.insertNote(
        NotesCompanion.insert(
          id: id,
          userId: Value(userId),
          translationId: location.translationId,
          bookId: location.bookId,
          chapter: location.chapter,
          verse: location.verse,
          noteText: text,
          version: const Value(1),
          updatedAt: now.millisecondsSinceEpoch,
        ),
      );
      await _dao.insertRevision(
        NoteRevisionsCompanion.insert(
          noteId: id,
          version: 1,
          revisionText: text,
          updatedAt: now.millisecondsSinceEpoch,
        ),
      );
      final note = Note(
        id: id,
        location: location,
        text: text,
        version: 1,
        updatedAt: now,
        history: [
          NoteHistoryEntry(version: 1, text: text, updatedAt: now),
        ],
      );
      await _syncDao.recordNoteChange(
        noteId: id,
        userId: userId,
        localUpdatedAt: now.millisecondsSinceEpoch,
        operation: 'upsert',
      );
      await _syncRepository.enqueue(
        SyncOperation(
          id: 'note:$id',
          userId: userId,
          opType: 'note.upsert',
          payload: {
            'noteId': id,
            'translationId': location.translationId,
            'bookId': location.bookId,
            'chapter': location.chapter,
            'verse': location.verse,
          'text': text,
            'version': 1,
            'updatedAt': now.millisecondsSinceEpoch,
          },
          createdAt: now,
        ),
      );
      return note;
    }

    final newVersion = existing.version + 1;
    await _dao.updateNote(
      existing.id,
      userId,
      text,
      newVersion,
      now.millisecondsSinceEpoch,
    );
    await _dao.insertRevision(
      NoteRevisionsCompanion.insert(
        noteId: existing.id,
        version: newVersion,
        revisionText: text,
        updatedAt: now.millisecondsSinceEpoch,
      ),
    );
    final updated = await _dao.findNote(
      userId,
      location.translationId,
      location.bookId,
      location.chapter,
      location.verse,
    );
    final historyRows = await _dao.getRevisions(userId, existing.id);
    final mapped = _mapNote(updated!, historyRows);
    await _syncDao.recordNoteChange(
      noteId: mapped.id,
      userId: userId,
      localUpdatedAt: mapped.updatedAt.millisecondsSinceEpoch,
      operation: 'upsert',
    );
    await _syncRepository.enqueue(
      SyncOperation(
        id: 'note:${mapped.id}',
        userId: userId,
        opType: 'note.upsert',
        payload: {
          'noteId': mapped.id,
          'translationId': location.translationId,
          'bookId': location.bookId,
          'chapter': location.chapter,
          'verse': location.verse,
          'text': mapped.text,
          'version': mapped.version,
          'updatedAt': mapped.updatedAt.millisecondsSinceEpoch,
        },
        createdAt: mapped.updatedAt,
      ),
    );
    return mapped;
  }

  @override
  Future<void> deleteNote(String userId, String id) async {
    await _ensureSeeded();
    final existing = await _dao.findNoteById(userId, id);
    await _dao.deleteNote(userId, id);
    final now = DateTime.now();
    await _syncDao.recordNoteChange(
      noteId: id,
      userId: userId,
      localUpdatedAt: now.millisecondsSinceEpoch,
      operation: 'delete',
    );
    final payload = <String, dynamic>{
      'noteId': id,
      'updatedAt': now.millisecondsSinceEpoch,
      'deleted': true,
    };
    if (existing != null) {
      payload.addAll({
        'translationId': existing.translationId,
        'bookId': existing.bookId,
        'chapter': existing.chapter,
        'verse': existing.verse,
      });
    }
    await _syncRepository.enqueue(
      SyncOperation(
        id: 'note:$id',
        userId: userId,
        opType: 'note.delete',
        payload: payload,
        createdAt: now,
      ),
    );
  }

  @override
  Future<List<NoteHistoryEntry>> getHistory(
    String userId,
    String noteId,
  ) async {
    await _ensureSeeded();
    final rows = await _dao.getRevisions(userId, noteId);
    return rows
        .map(
          (row) => NoteHistoryEntry(
            version: row.version,
            text: row.revisionText,
            updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
          ),
        )
        .toList();
  }

  @override
  Future<Note?> revertToPreviousVersion(String userId, String noteId) async {
    await _ensureSeeded();
    final note = await _dao.findNoteById(userId, noteId);
    if (note == null) {
      return null;
    }
    final history = await _dao.getRevisions(userId, noteId);
    if (history.length < 2) {
      return null;
    }
    final previous = history[1];
    final now = DateTime.now();
    final newVersion = note.version + 1;
    await _dao.updateNote(
      noteId,
      userId,
      previous.revisionText,
      newVersion,
      now.millisecondsSinceEpoch,
    );
    await _dao.insertRevision(
      NoteRevisionsCompanion.insert(
        noteId: noteId,
        version: newVersion,
        revisionText: previous.revisionText,
        updatedAt: now.millisecondsSinceEpoch,
      ),
    );
    final updated = await _dao.findNoteById(userId, noteId);
    if (updated == null) {
      return null;
    }
    final updatedHistory = await _dao.getRevisions(userId, noteId);
    final mapped = _mapNote(updated, updatedHistory);
    await _syncDao.recordNoteChange(
      noteId: mapped.id,
      userId: userId,
      localUpdatedAt: mapped.updatedAt.millisecondsSinceEpoch,
      operation: 'upsert',
    );
    await _syncRepository.enqueue(
      SyncOperation(
        id: 'note:${mapped.id}',
        userId: userId,
        opType: 'note.upsert',
        payload: {
          'noteId': mapped.id,
          'translationId': mapped.location.translationId,
          'bookId': mapped.location.bookId,
          'chapter': mapped.location.chapter,
          'verse': mapped.location.verse,
          'text': mapped.text,
          'version': mapped.version,
          'updatedAt': mapped.updatedAt.millisecondsSinceEpoch,
        },
        createdAt: mapped.updatedAt,
      ),
    );
    return mapped;
  }

  Bookmark _mapBookmark(BookmarkRow row) {
    return Bookmark(
      id: row.id,
      location: VerseLocation(
        translationId: row.translationId,
        bookId: row.bookId,
        chapter: row.chapter,
        verse: row.verse,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
    );
  }

  Highlight _mapHighlight(HighlightRow row) {
    return Highlight(
      id: row.id,
      location: VerseLocation(
        translationId: row.translationId,
        bookId: row.bookId,
        chapter: row.chapter,
        verse: row.verse,
      ),
      colour: row.colour,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
    );
  }

  Note _mapNote(NoteRow row, List<NoteRevisionRow> historyRows) {
    final history = historyRows
        .map(
          (entry) => NoteHistoryEntry(
            version: entry.version,
            text: entry.revisionText,
            updatedAt: DateTime.fromMillisecondsSinceEpoch(entry.updatedAt),
          ),
        )
        .toList();
    return Note(
      id: row.id,
      location: VerseLocation(
        translationId: row.translationId,
        bookId: row.bookId,
        chapter: row.chapter,
        verse: row.verse,
      ),
      text: row.noteText,
      version: row.version,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
      history: history,
    );
  }
}
