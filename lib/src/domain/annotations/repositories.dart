import 'entities.dart';

abstract class AnnotationRepository {
  Stream<List<Bookmark>> watchBookmarksForChapter(
    String userId,
    String translationId,
    int bookId,
    int chapter,
  );
  Future<Bookmark?> findBookmark(
    String userId,
    String translationId,
    int bookId,
    int chapter,
    int verse,
  );
  Future<Bookmark> createBookmark(String userId, VerseLocation location);
  Future<void> deleteBookmark(String userId, String id);

  Stream<List<Highlight>> watchHighlightsForChapter(
    String userId,
    String translationId,
    int bookId,
    int chapter,
  );
  Future<Highlight?> findHighlight(
    String userId,
    String translationId,
    int bookId,
    int chapter,
    int verse,
  );
  Future<Highlight> saveHighlight(String userId, Highlight highlight);
  Future<void> deleteHighlight(String userId, String id);

  Stream<List<Note>> watchNotesForChapter(
    String userId,
    String translationId,
    int bookId,
    int chapter,
  );
  Future<Note?> findNote(
    String userId,
    String translationId,
    int bookId,
    int chapter,
    int verse,
  );
  Future<Note> saveNote(
    String userId,
    VerseLocation location,
    String text,
  );
  Future<void> deleteNote(String userId, String id);
  Future<List<NoteHistoryEntry>> getHistory(String userId, String noteId);
  Future<Note?> revertToPreviousVersion(String userId, String noteId);
}
