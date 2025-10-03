import 'entities.dart';

abstract class BibleRepository {
  Future<List<BibleTranslation>> getInstalledTranslations();
  Future<List<BibleBook>> getBooks(String translationId);
  Future<List<BibleVerse>> getChapter(
    String translationId,
    int bookId,
    int chapter,
  );
  Stream<List<BibleVerse>> watchChapter(
    String translationId,
    int bookId,
    int chapter,
  );
  Future<List<BibleSearchResult>> searchVerses(
    String translationId,
    String query, {
    int? bookId,
    int limit,
  });
  Future<BibleTranslation?> findTranslationById(String id);
  Future<void> saveImportedTranslation(
    BibleTranslation translation,
    List<BibleVerse> verses, {
    bool replaceExisting,
  });
  Future<void> buildSearchIndex(String translationId);
}
