import 'entities.dart';

abstract class AnnotationRepository {
  Stream<List<Bookmark>> watchBookmarksForChapter(
    String translationId,
    int bookId,
    int chapter,
  );
  Future<Bookmark?> findBookmark(
    String translationId,
    int bookId,
    int chapter,
    int verse,
  );
  Future<Bookmark> createBookmark(VerseLocation location);
  Future<void> deleteBookmark(String id);

  Stream<List<Highlight>> watchHighlightsForChapter(
    String translationId,
    int bookId,
    int chapter,
  );
  Future<Highlight?> findHighlight(
    String translationId,
    int bookId,
    int chapter,
    int verse,
  );
  Future<Highlight> saveHighlight(Highlight highlight);
  Future<void> deleteHighlight(String id);

  Stream<List<Note>> watchNotesForChapter(
    String translationId,
    int bookId,
    int chapter,
  );
  Future<Note?> findNote(
    String translationId,
    int bookId,
    int chapter,
    int verse,
  );
  Future<Note> saveNote(
    VerseLocation location,
    String text,
  );
  Future<void> deleteNote(String id);
  Future<List<NoteHistoryEntry>> getHistory(String noteId);
  Future<Note?> revertToPreviousVersion(String noteId);
}
