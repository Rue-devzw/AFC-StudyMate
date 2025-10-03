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
    return rows
        .map(
          (row) => BibleTranslation(
            id: row.id,
            name: row.name,
            language: row.language,
            version: row.version,
            source: row.source,
            installedAt:
                DateTime.fromMillisecondsSinceEpoch(row.installedAt),
          ),
        )
        .toList();
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
