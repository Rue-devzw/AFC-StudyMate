import 'package:drift/drift.dart';

import '../app_database.dart';

class AnnotationDao {
  AnnotationDao(this._db);

  final AppDatabase _db;

  Stream<List<BookmarksData>> watchBookmarksForChapter(
    String translationId,
    int bookId,
    int chapter,
  ) {
    final query = _db.select(_db.bookmarks)
      ..where((tbl) =>
          tbl.translationId.equals(translationId) &
          tbl.bookId.equals(bookId) &
          tbl.chapter.equals(chapter))
      ..orderBy([
        (tbl) => OrderingTerm.asc(tbl.verse),
      ]);
    return query.watch();
  }

  Future<BookmarksData?> findBookmark(
    String translationId,
    int bookId,
    int chapter,
    int verse,
  ) {
    final query = _db.select(_db.bookmarks)
      ..where((tbl) =>
          tbl.translationId.equals(translationId) &
          tbl.bookId.equals(bookId) &
          tbl.chapter.equals(chapter) &
          tbl.verse.equals(verse))
      ..limit(1);
    return query.getSingleOrNull();
  }

  Future<void> insertBookmark(BookmarksCompanion companion) {
    return _db.into(_db.bookmarks).insertOnConflictUpdate(companion);
  }

  Future<void> deleteBookmark(String id) {
    return (_db.delete(_db.bookmarks)..where((tbl) => tbl.id.equals(id))).go();
  }

  Stream<List<HighlightsData>> watchHighlightsForChapter(
    String translationId,
    int bookId,
    int chapter,
  ) {
    final query = _db.select(_db.highlights)
      ..where((tbl) =>
          tbl.translationId.equals(translationId) &
          tbl.bookId.equals(bookId) &
          tbl.chapter.equals(chapter))
      ..orderBy([
        (tbl) => OrderingTerm.asc(tbl.verse),
      ]);
    return query.watch();
  }

  Future<HighlightsData?> findHighlight(
    String translationId,
    int bookId,
    int chapter,
    int verse,
  ) {
    final query = _db.select(_db.highlights)
      ..where((tbl) =>
          tbl.translationId.equals(translationId) &
          tbl.bookId.equals(bookId) &
          tbl.chapter.equals(chapter) &
          tbl.verse.equals(verse))
      ..limit(1);
    return query.getSingleOrNull();
  }

  Future<void> upsertHighlight(HighlightsCompanion companion) async {
    await (_db.delete(_db.highlights)
          ..where((tbl) =>
              tbl.translationId.equals(companion.translationId.value) &
              tbl.bookId.equals(companion.bookId.value) &
              tbl.chapter.equals(companion.chapter.value) &
              tbl.verse.equals(companion.verse.value)))
        .go();
    await _db.into(_db.highlights).insert(companion, mode: InsertMode.insertOrReplace);
  }

  Future<void> deleteHighlight(String id) {
    return (_db.delete(_db.highlights)..where((tbl) => tbl.id.equals(id))).go();
  }

  Stream<List<NotesData>> watchNotesForChapter(
    String translationId,
    int bookId,
    int chapter,
  ) {
    final query = _db.select(_db.notes)
      ..where((tbl) =>
          tbl.translationId.equals(translationId) &
          tbl.bookId.equals(bookId) &
          tbl.chapter.equals(chapter))
      ..orderBy([
        (tbl) => OrderingTerm.asc(tbl.verse),
      ]);
    return query.watch();
  }

  Stream<List<NotesData>> watchNotesForVerse(String noteId) {
    final query = _db.select(_db.notes)
      ..where((tbl) => tbl.id.equals(noteId))
      ..limit(1);
    return query.watch();
  }

  Future<NotesData?> findNote(
    String translationId,
    int bookId,
    int chapter,
    int verse,
  ) {
    final query = _db.select(_db.notes)
      ..where((tbl) =>
          tbl.translationId.equals(translationId) &
          tbl.bookId.equals(bookId) &
          tbl.chapter.equals(chapter) &
          tbl.verse.equals(verse))
      ..limit(1);
    return query.getSingleOrNull();
  }

  Future<NotesData?> findNoteById(String id) {
    final query = _db.select(_db.notes)
      ..where((tbl) => tbl.id.equals(id))
      ..limit(1);
    return query.getSingleOrNull();
  }

  Future<void> insertNote(NotesCompanion companion) {
    return _db.into(_db.notes).insert(companion, mode: InsertMode.insertOrReplace);
  }

  Future<void> updateNote(
    String id,
    String text,
    int version,
    int updatedAt,
  ) {
    return (_db.update(_db.notes)..where((tbl) => tbl.id.equals(id))).write(
      NotesCompanion(
        text: Value(text),
        version: Value(version),
        updatedAt: Value(updatedAt),
      ),
    );
  }

  Future<void> insertRevision(NoteRevisionsCompanion companion) {
    return _db
        .into(_db.noteRevisions)
        .insert(companion, mode: InsertMode.insertOrReplace);
  }

  Future<NoteRevisionsData?> findRevision(String noteId, int version) {
    final query = _db.select(_db.noteRevisions)
      ..where((tbl) =>
          tbl.noteId.equals(noteId) & tbl.version.equals(version))
      ..limit(1);
    return query.getSingleOrNull();
  }

  Future<List<NoteRevisionsData>> getRevisions(String noteId) {
    final query = _db.select(_db.noteRevisions)
      ..where((tbl) => tbl.noteId.equals(noteId))
      ..orderBy([
        (tbl) => OrderingTerm.desc(tbl.version),
      ]);
    return query.get();
  }
}
