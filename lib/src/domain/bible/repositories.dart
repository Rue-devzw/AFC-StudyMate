import 'entities.dart';

abstract class BibleRepository {
  Future<List<BibleTranslation>> getInstalledTranslations();
  Future<List<BibleBook>> getBooks(String translationId);
  Future<List<BibleVerse>> getChapter(
    String translationId,
    int bookId,
    int chapter,
  );
  Future<List<BibleVerse>> search(
    String translationId,
    String query, {
    int? limit,
  });
}
