import '../../domain/bible/entities.dart';
import '../../domain/bible/repositories.dart';
import '../../infrastructure/db/app_database.dart';
import '../../infrastructure/db/daos/bible_dao.dart';

class BibleRepositoryImpl implements BibleRepository {
  BibleRepositoryImpl(this._db, this._dao);

  final AppDatabase _db;
  final BibleDao _dao;

  Future<void> _ensureSeeded() => _db.ensureSeeded();

  @override
  Future<List<BibleTranslation>> getInstalledTranslations() async {
    await _ensureSeeded();
    final rows = await _dao.getTranslations();
    final translations = rows
        .map(
          (row) => BibleTranslation(
            id: row.id,
            name: row.name,
            language: row.language,
            languageName: row.languageName,
            version: row.version,
            source: row.source,
            copyright: row.copyright,
            installedAt:
                DateTime.fromMillisecondsSinceEpoch(row.installedAt),
          ),
        )
        .toList();

    translations.sort((a, b) {
      final languageCompare =
          a.languageName.toLowerCase().compareTo(b.languageName.toLowerCase());
      if (languageCompare != 0) {
        return languageCompare;
      }
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    return translations;
  }

  @override
  Future<List<BibleBook>> getBooks(String translationId) async {
    await _ensureSeeded();
    final aggregates = await _dao.getBooks(translationId);
    return aggregates
        .map(
          (agg) => BibleBook(
            id: agg.bookId,
            name: bookNameForId(agg.bookId),
            chapterCount: agg.chapters,
          ),
        )
        .toList();
  }

  @override
  Future<List<BibleVerse>> getChapter(
    String translationId,
    int bookId,
    int chapter,
  ) async {
    await _ensureSeeded();
    final rows = await _dao.getChapter(translationId, bookId, chapter);
    return rows
        .map(
          (row) => BibleVerse(
            translationId: row.translationId,
            bookId: row.bookId,
            chapter: row.chapter,
            verse: row.verse,
            text: row.text,
          ),
        )
        .toList();
  }

  @override
  Future<List<BibleVerse>> search(
    String translationId,
    String query, {
    int? limit,
  }) async {
    await _ensureSeeded();
    if (query.trim().isEmpty) {
      return const [];
    }
    final rows = await _dao.search(translationId, query, limit: limit);
    return rows
        .map(
          (row) => BibleVerse(
            translationId: row.translationId,
            bookId: row.bookId,
            chapter: row.chapter,
            verse: row.verse,
            text: row.text,
          ),
        )
        .toList();
  }
}
