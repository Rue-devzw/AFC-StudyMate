import 'entities.dart';
import 'repositories.dart';

class WatchBookmarksForChapterUseCase {
  const WatchBookmarksForChapterUseCase(this._repository);

  final AnnotationRepository _repository;

  Stream<List<Bookmark>> call(
    String userId,
    String translationId,
    int bookId,
    int chapter,
  ) {
    return _repository.watchBookmarksForChapter(
      userId,
      translationId,
      bookId,
      chapter,
    );
  }
}

class ToggleBookmarkUseCase {
  const ToggleBookmarkUseCase(this._repository);

  final AnnotationRepository _repository;

  Future<Bookmark?> call(String userId, VerseLocation location) async {
    final existing = await _repository.findBookmark(
      userId,
      location.translationId,
      location.bookId,
      location.chapter,
      location.verse,
    );
    if (existing != null) {
      await _repository.deleteBookmark(userId, existing.id);
      return null;
    }
    return _repository.createBookmark(userId, location);
  }
}

class WatchHighlightsForChapterUseCase {
  const WatchHighlightsForChapterUseCase(this._repository);

  final AnnotationRepository _repository;

  Stream<List<Highlight>> call(
    String userId,
    String translationId,
    int bookId,
    int chapter,
  ) {
    return _repository.watchHighlightsForChapter(
      userId,
      translationId,
      bookId,
      chapter,
    );
  }
}

class SaveHighlightUseCase {
  const SaveHighlightUseCase(this._repository);

  final AnnotationRepository _repository;

  Future<Highlight> call(String userId, Highlight highlight) {
    return _repository.saveHighlight(userId, highlight);
  }
}

class RemoveHighlightUseCase {
  const RemoveHighlightUseCase(this._repository);

  final AnnotationRepository _repository;

  Future<void> call(String userId, String id) {
    return _repository.deleteHighlight(userId, id);
  }
}

class WatchNotesForChapterUseCase {
  const WatchNotesForChapterUseCase(this._repository);

  final AnnotationRepository _repository;

  Stream<List<Note>> call(
    String userId,
    String translationId,
    int bookId,
    int chapter,
  ) {
    return _repository.watchNotesForChapter(
      userId,
      translationId,
      bookId,
      chapter,
    );
  }
}

class SaveNoteUseCase {
  const SaveNoteUseCase(this._repository);

  final AnnotationRepository _repository;

  Future<Note> call(String userId, VerseLocation location, String text) {
    return _repository.saveNote(userId, location, text);
  }
}

class DeleteNoteUseCase {
  const DeleteNoteUseCase(this._repository);

  final AnnotationRepository _repository;

  Future<void> call(String userId, String id) {
    return _repository.deleteNote(userId, id);
  }
}

class UndoNoteUseCase {
  const UndoNoteUseCase(this._repository);

  final AnnotationRepository _repository;

  Future<Note?> call(String userId, String id) {
    return _repository.revertToPreviousVersion(userId, id);
  }
}

class GetNoteHistoryUseCase {
  const GetNoteHistoryUseCase(this._repository);

  final AnnotationRepository _repository;

  Future<List<NoteHistoryEntry>> call(String userId, String noteId) {
    return _repository.getHistory(userId, noteId);
  }
}
