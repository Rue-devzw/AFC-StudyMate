import 'entities.dart';
import 'repositories.dart';

class WatchBookmarksForChapterUseCase {
  const WatchBookmarksForChapterUseCase(this._repository);

  final AnnotationRepository _repository;

  Stream<List<Bookmark>> call(String translationId, int bookId, int chapter) {
    return _repository.watchBookmarksForChapter(translationId, bookId, chapter);
  }
}

class ToggleBookmarkUseCase {
  const ToggleBookmarkUseCase(this._repository);

  final AnnotationRepository _repository;

  Future<Bookmark?> call(VerseLocation location) async {
    final existing = await _repository.findBookmark(
      location.translationId,
      location.bookId,
      location.chapter,
      location.verse,
    );
    if (existing != null) {
      await _repository.deleteBookmark(existing.id);
      return null;
    }
    return _repository.createBookmark(location);
  }
}

class WatchHighlightsForChapterUseCase {
  const WatchHighlightsForChapterUseCase(this._repository);

  final AnnotationRepository _repository;

  Stream<List<Highlight>> call(String translationId, int bookId, int chapter) {
    return _repository.watchHighlightsForChapter(translationId, bookId, chapter);
  }
}

class SaveHighlightUseCase {
  const SaveHighlightUseCase(this._repository);

  final AnnotationRepository _repository;

  Future<Highlight> call(Highlight highlight) {
    return _repository.saveHighlight(highlight);
  }
}

class RemoveHighlightUseCase {
  const RemoveHighlightUseCase(this._repository);

  final AnnotationRepository _repository;

  Future<void> call(String id) {
    return _repository.deleteHighlight(id);
  }
}

class WatchNotesForChapterUseCase {
  const WatchNotesForChapterUseCase(this._repository);

  final AnnotationRepository _repository;

  Stream<List<Note>> call(String translationId, int bookId, int chapter) {
    return _repository.watchNotesForChapter(translationId, bookId, chapter);
  }
}

class SaveNoteUseCase {
  const SaveNoteUseCase(this._repository);

  final AnnotationRepository _repository;

  Future<Note> call(VerseLocation location, String text) {
    return _repository.saveNote(location, text);
  }
}

class DeleteNoteUseCase {
  const DeleteNoteUseCase(this._repository);

  final AnnotationRepository _repository;

  Future<void> call(String id) {
    return _repository.deleteNote(id);
  }
}

class UndoNoteUseCase {
  const UndoNoteUseCase(this._repository);

  final AnnotationRepository _repository;

  Future<Note?> call(String id) {
    return _repository.revertToPreviousVersion(id);
  }
}

class GetNoteHistoryUseCase {
  const GetNoteHistoryUseCase(this._repository);

  final AnnotationRepository _repository;

  Future<List<NoteHistoryEntry>> call(String noteId) {
    return _repository.getHistory(noteId);
  }
}
