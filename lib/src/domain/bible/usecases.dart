import 'entities.dart';
import 'repositories.dart';

class GetTranslationsUseCase {
  final BibleRepository _repository;

  const GetTranslationsUseCase(this._repository);

  Future<List<BibleTranslation>> call() {
    return _repository.getInstalledTranslations();
  }
}

class GetBooksUseCase {
  final BibleRepository _repository;

  const GetBooksUseCase(this._repository);

  Future<List<BibleBook>> call(String translationId) {
    return _repository.getBooks(translationId);
  }
}

class GetChapterUseCase {
  final BibleRepository _repository;

  const GetChapterUseCase(this._repository);

  Future<List<BibleVerse>> call(
    String translationId,
    int bookId,
    int chapter,
  ) {
    return _repository.getChapter(translationId, bookId, chapter);
  }
}

class WatchChapterUseCase {
  const WatchChapterUseCase(this._repository);

  final BibleRepository _repository;

  Stream<List<BibleVerse>> call(
    String translationId,
    int bookId,
    int chapter,
  ) {
    return _repository.watchChapter(translationId, bookId, chapter);
  }
}

class SearchVersesUseCase {
  final BibleRepository _repository;

  const SearchVersesUseCase(this._repository);

  Future<List<BibleSearchResult>> call({
    required String translationId,
    required String query,
    int? bookId,
    int limit = 50,
  }) {
    return _repository.searchVerses(
      translationId,
      query,
      bookId: bookId,
      limit: limit,
    );
  }
}
