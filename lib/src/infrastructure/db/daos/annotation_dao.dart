import 'package:drift/drift.dart';

import '../app_database.dart';

class AnnotationDao {
  AnnotationDao(this._db);

  final AppDatabase _db;

  Stream<List<BookmarksData>> watchBookmarksForChapter(
    String userId,
    String translationId,
    int bookId,
    int chapter,
  ) {
    final query = _db.select(_db.bookmarks)
      ..where((tbl) =>
          tbl.userId.equals(userId) &
          tbl.translationId.equals(translationId) &
          tbl.bookId.equals(bookId) &
          tbl.chapter.equals(chapter))
      ..orderBy([
        (tbl) => OrderingTerm.asc(tbl.verse),
      ]);
    return query.watch();
  }

  Future<BookmarksData?> findBookmark(
    String userId,
    String translationId,
    int bookId,
    int chapter,
    int verse,
  ) {
    final query = _db.select(_db.bookmarks)
      ..where((tbl) =>
          tbl.userId.equals(userId) &
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

  Future<void> deleteBookmark(String userId, String id) {
    return (_db.delete(_db.bookmarks)
          ..where((tbl) => tbl.id.equals(id) & tbl.userId.equals(userId)))
        .go();
  }

  Stream<List<HighlightsData>> watchHighlightsForChapter(
    String userId,
    String translationId,
    int bookId,
    int chapter,
  ) {
    final query = _db.select(_db.highlights)
      ..where((tbl) =>
          tbl.userId.equals(userId) &
          tbl.translationId.equals(translationId) &
          tbl.bookId.equals(bookId) &
          tbl.chapter.equals(chapter))
      ..orderBy([
        (tbl) => OrderingTerm.asc(tbl.verse),
      ]);
    return query.watch();
  }

  Future<HighlightsData?> findHighlight(
    String userId,
    String translationId,
    int bookId,
    int chapter,
    int verse,
  ) {
    final query = _db.select(_db.highlights)
      ..where((tbl) =>
          tbl.userId.equals(userId) &
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
              tbl.userId.equals(companion.userId.value) &
              tbl.translationId.equals(companion.translationId.value) &
              tbl.bookId.equals(companion.bookId.value) &
              tbl.chapter.equals(companion.chapter.value) &
              tbl.verse.equals(companion.verse.value)))
        .go();
    await _db.into(_db.highlights).insert(companion, mode: InsertMode.insertOrReplace);
  }

  Future<void> deleteHighlight(String userId, String id) {
    return (_db.delete(_db.highlights)
          ..where((tbl) => tbl.id.equals(id) & tbl.userId.equals(userId)))
        .go();
  }

  Stream<List<NotesData>> watchNotesForChapter(
    String userId,
    String translationId,
    int bookId,
    int chapter,
  ) {
    final query = _db.select(_db.notes)
      ..where((tbl) =>
          tbl.userId.equals(userId) &
          tbl.translationId.equals(translationId) &
          tbl.bookId.equals(bookId) &
          tbl.chapter.equals(chapter))
      ..orderBy([
        (tbl) => OrderingTerm.asc(tbl.verse),
      ]);
    return query.watch();
  }

  Stream<List<NotesData>> watchNotesForVerse(String userId, String noteId) {
    final query = _db.select(_db.notes)
      ..where((tbl) => tbl.id.equals(noteId) & tbl.userId.equals(userId))
      ..limit(1);
    return query.watch();
  }

  Future<NotesData?> findNote(
    String userId,
    String translationId,
    int bookId,
    int chapter,
    int verse,
  ) {
    final query = _db.select(_db.notes)
      ..where((tbl) =>
          tbl.userId.equals(userId) &
          tbl.translationId.equals(translationId) &
          tbl.bookId.equals(bookId) &
          tbl.chapter.equals(chapter) &
          tbl.verse.equals(verse))
      ..limit(1);
    return query.getSingleOrNull();
  }

  Future<NotesData?> findNoteById(String userId, String id) {
    final query = _db.select(_db.notes)
      ..where((tbl) =>
          (tbl as dynamic).id.equals(id) &
          (tbl as dynamic).userId.equals(userId))
      ..limit(1);
    return query.getSingleOrNull();
  }

  Future<void> insertNote(NotesCompanion companion) {
    return _db
        .into(_db.notes)
        .insert(companion as dynamic, mode: InsertMode.insertOrReplace);
  }

  Future<void> updateNote(
    String id,
    String userId,
    String text,
    int version,
    int updatedAt,
  ) {
    return (_db.update(_db.notes)
          ..where((tbl) =>
              (tbl as dynamic).id.equals(id) &
              (tbl as dynamic).userId.equals(userId)))
        .write(
      NotesCompanion(
        text: Value(text),
        version: Value(version),
        updatedAt: Value(updatedAt),
      ),
    );
  }

  Future<void> deleteNote(String userId, String id) {
    return (_db.delete(_db.notes)
          ..where((tbl) =>
              (tbl as dynamic).id.equals(id) &
              (tbl as dynamic).userId.equals(userId)))
        .go();
  }

  Future<void> insertRevision(NoteRevisionsCompanion companion) {
    return _db
        .into(_db.noteRevisions)
        .insert(companion as dynamic, mode: InsertMode.insertOrReplace);
  }

  Future<NoteRevisionsData?> findRevision(
    String userId,
    String noteId,
    int version,
  ) {
    final query = _db.select(_db.noteRevisions)
      ..where((tbl) => (tbl as dynamic).noteId.equals(noteId) &
          (tbl as dynamic).version.equals(version))
      ..limit(1);
    return query.getSingleOrNull();
  }

  Future<List<NoteRevisionsData>> getRevisions(String userId, String noteId) {
    final query = _db.select(_db.noteRevisions)
      ..where((tbl) => (tbl as dynamic).noteId.equals(noteId))
      ..orderBy([
        (tbl) => OrderingTerm.desc((tbl as dynamic).version),
      ]);
    return query.get();
  }
}
