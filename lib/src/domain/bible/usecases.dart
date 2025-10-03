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

class SearchBibleUseCase {
  final BibleRepository _repository;

  const SearchBibleUseCase(this._repository);

  Future<List<BibleVerse>> call(
    String translationId,
    String query, {
    int? limit,
  }) {
    return _repository.search(translationId, query, limit: limit);
  }
}
