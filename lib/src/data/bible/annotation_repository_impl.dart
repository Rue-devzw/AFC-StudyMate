import 'package:uuid/uuid.dart';

import '../../domain/annotations/entities.dart';
import '../../domain/annotations/repositories.dart';
import '../../infrastructure/db/app_database.dart';
import '../../infrastructure/db/daos/annotation_dao.dart';

class AnnotationRepositoryImpl implements AnnotationRepository {
  AnnotationRepositoryImpl(this._db, this._dao);

  final AppDatabase _db;
  final AnnotationDao _dao;
  final Uuid _uuid = const Uuid();

  Future<void> _ensureSeeded() => _db.ensureSeeded();

  @override
  Stream<List<Bookmark>> watchBookmarksForChapter(
    String translationId,
    int bookId,
    int chapter,
  ) async* {
    await _ensureSeeded();
    yield* _dao.watchBookmarksForChapter(translationId, bookId, chapter).map(
      (rows) => rows.map(_mapBookmark).toList(),
    );
  }

  @override
  Future<Bookmark?> findBookmark(
    String translationId,
    int bookId,
    int chapter,
    int verse,
  ) async {
    await _ensureSeeded();
    final row = await _dao.findBookmark(translationId, bookId, chapter, verse);
    return row == null ? null : _mapBookmark(row);
  }

  @override
  Future<Bookmark> createBookmark(VerseLocation location) async {
    await _ensureSeeded();
    final id = _uuid.v4();
    final now = DateTime.now();
    await _dao.insertBookmark(
      BookmarksCompanion.insert(
        id: id,
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
  Future<void> deleteBookmark(String id) {
    return _dao.deleteBookmark(id);
  }

  @override
  Stream<List<Highlight>> watchHighlightsForChapter(
    String translationId,
    int bookId,
    int chapter,
  ) async* {
    await _ensureSeeded();
    yield* _dao.watchHighlightsForChapter(translationId, bookId, chapter).map(
      (rows) => rows.map(_mapHighlight).toList(),
    );
  }

  @override
  Future<Highlight?> findHighlight(
    String translationId,
    int bookId,
    int chapter,
    int verse,
  ) async {
    await _ensureSeeded();
    final row = await _dao.findHighlight(translationId, bookId, chapter, verse);
    return row == null ? null : _mapHighlight(row);
  }

  @override
  Future<Highlight> saveHighlight(Highlight highlight) async {
    await _ensureSeeded();
    final id = highlight.id.isEmpty ? _uuid.v4() : highlight.id;
    final now = DateTime.now();
    await _dao.upsertHighlight(
      HighlightsCompanion.insert(
        id: id,
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
  Future<void> deleteHighlight(String id) {
    return _dao.deleteHighlight(id);
  }

  @override
  Stream<List<Note>> watchNotesForChapter(
    String translationId,
    int bookId,
    int chapter,
  ) async* {
    await _ensureSeeded();
    yield* _dao.watchNotesForChapter(translationId, bookId, chapter).asyncMap(
      (rows) async {
        final notes = <Note>[];
        for (final row in rows) {
          final historyRows = await _dao.getRevisions(row.id);
          notes.add(_mapNote(row, historyRows));
        }
        return notes;
      },
    );
  }

  @override
  Future<Note?> findNote(
    String translationId,
    int bookId,
    int chapter,
    int verse,
  ) async {
    await _ensureSeeded();
    final row = await _dao.findNote(translationId, bookId, chapter, verse);
    if (row == null) {
      return null;
    }
    final historyRows = await _dao.getRevisions(row.id);
    return _mapNote(row, historyRows);
  }

  @override
  Future<Note> saveNote(VerseLocation location, String text) async {
    await _ensureSeeded();
    final now = DateTime.now();
    final existing =
        await _dao.findNote(location.translationId, location.bookId, location.chapter, location.verse);
    if (existing == null) {
      final id = _uuid.v4();
      await _dao.insertNote(
        NotesCompanion.insert(
          id: id,
          translationId: location.translationId,
          bookId: location.bookId,
          chapter: location.chapter,
          verse: location.verse,
          text: text,
          version: 1,
          updatedAt: now.millisecondsSinceEpoch,
        ),
      );
      await _dao.insertRevision(
        NoteRevisionsCompanion.insert(
          noteId: id,
          version: 1,
          text: text,
          updatedAt: now.millisecondsSinceEpoch,
        ),
      );
      return Note(
        id: id,
        location: location,
        text: text,
        version: 1,
        updatedAt: now,
        history: [
          NoteHistoryEntry(version: 1, text: text, updatedAt: now),
        ],
      );
    }

    final newVersion = existing.version + 1;
    await _dao.updateNote(
      existing.id,
      text,
      newVersion,
      now.millisecondsSinceEpoch,
    );
    await _dao.insertRevision(
      NoteRevisionsCompanion.insert(
        noteId: existing.id,
        version: newVersion,
        text: text,
        updatedAt: now.millisecondsSinceEpoch,
      ),
    );
    final updated = await _dao.findNote(
      location.translationId,
      location.bookId,
      location.chapter,
      location.verse,
    );
    final historyRows = await _dao.getRevisions(existing.id);
    return _mapNote(updated!, historyRows);
  }

  @override
  Future<void> deleteNote(String id) {
    return (_db.delete(_db.notes)..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  Future<List<NoteHistoryEntry>> getHistory(String noteId) async {
    await _ensureSeeded();
    final rows = await _dao.getRevisions(noteId);
    return rows
        .map(
          (row) => NoteHistoryEntry(
            version: row.version,
            text: row.text,
            updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
          ),
        )
        .toList();
  }

  @override
  Future<Note?> revertToPreviousVersion(String noteId) async {
    await _ensureSeeded();
    final history = await _dao.getRevisions(noteId);
    if (history.length < 2) {
      return null;
    }
    final current = history.first;
    final target = history[1];
    final now = DateTime.now();
    final newVersion = current.version + 1;
    await _dao.updateNote(
      noteId,
      target.text,
      newVersion,
      now.millisecondsSinceEpoch,
    );
    await _dao.insertRevision(
      NoteRevisionsCompanion.insert(
        noteId: noteId,
        version: newVersion,
        text: target.text,
        updatedAt: now.millisecondsSinceEpoch,
      ),
    );
    final updated = await _dao.findNoteById(noteId);
    if (updated == null) {
      return null;
    }
    final updatedHistory = await _dao.getRevisions(noteId);
    return _mapNote(updated, updatedHistory);
  }

  Bookmark _mapBookmark(BookmarksData row) {
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

  Highlight _mapHighlight(HighlightsData row) {
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

  Note _mapNote(NotesData row, List<NoteRevisionsData> historyRows) {
    final history = historyRows
        .map(
          (entry) => NoteHistoryEntry(
            version: entry.version,
            text: entry.text,
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
      text: row.text,
      version: row.version,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
      history: history,
    );
  }
}
