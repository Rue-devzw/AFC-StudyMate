import 'package:drift/drift.dart';

import '../../domain/bible/book_names.dart';
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
            name: bibleBookNameForId(agg.bookId),
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
  Future<List<BibleSearchResult>> searchVerses(
    String translationId,
    String query, {
    int? bookId,
    int limit = 50,
  }) async {
    await _ensureSeeded();
    if (query.trim().isEmpty) {
      return const [];
    }
    final rows = await _dao.search(
      translationId,
      query,
      limit: limit,
      bookId: bookId,
    );
    return rows
        .map(
          (row) => BibleSearchResult(
            verse: BibleVerse(
              translationId: row.translationId,
              bookId: row.bookId,
              chapter: row.chapter,
              verse: row.verse,
              text: row.text,
            ),
            snippet: row.snippet,
            rank: row.rank,
          ),
        )
        .toList();
  }

  @override
  Future<BibleTranslation?> findTranslationById(String id) async {
    await _ensureSeeded();
    final query = _db.select(_db.translations)
      ..where((tbl) => tbl.id.equals(id))
      ..limit(1);
    final row = await query.getSingleOrNull();
    if (row == null) {
      return null;
    }
    return BibleTranslation(
      id: row.id,
      name: row.name,
      language: row.language,
      languageName: row.languageName,
      version: row.version,
      source: row.source,
      copyright: row.copyright,
      installedAt: DateTime.fromMillisecondsSinceEpoch(row.installedAt),
    );
  }

  @override
  Future<void> saveImportedTranslation(
    BibleTranslation translation,
    List<BibleVerse> verses, {
    bool replaceExisting = false,
  }) async {
    await _ensureSeeded();

    await _db.transaction(() async {
      if (replaceExisting) {
        await (_db.delete(_db.verses)
              ..where((tbl) => tbl.translationId.equals(translation.id)))
            .go();
        await (_db.delete(_db.translations)
              ..where((tbl) => tbl.id.equals(translation.id)))
            .go();
        await _db.dropSearchIndex(translation.id);
      }

      await _db.into(_db.translations).insert(
            TranslationsCompanion.insert(
              id: translation.id,
              name: translation.name,
              language: translation.language,
              languageName: translation.languageName,
              version: translation.version,
              copyright: translation.copyright,
              source: Value(translation.source),
              installedAt:
                  translation.installedAt.millisecondsSinceEpoch,
            ),
            mode: InsertMode.insertOrReplace,
          );

      if (verses.isEmpty) {
        return;
      }

      const chunkSize = 500;
      for (var start = 0; start < verses.length; start += chunkSize) {
        final chunk = verses.skip(start).take(chunkSize).map(
              (verse) => VersesCompanion.insert(
                translationId: translation.id,
                bookId: verse.bookId,
                chapter: verse.chapter,
                verse: verse.verse,
                text: verse.text,
              ),
            );
        await _db.batch((batch) {
          batch.insertAll(
            _db.verses,
            chunk.toList(),
            mode: InsertMode.insertOrReplace,
          );
        });
      }
    });
  }

  @override
  Future<void> buildSearchIndex(String translationId) async {
    await _ensureSeeded();
    await _db.rebuildFtsFor(translationId);
  }
}
