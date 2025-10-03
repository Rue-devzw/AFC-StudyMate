import 'package:drift/drift.dart';

import '../app_database.dart';

class BibleDao {
  BibleDao(this._db);

  final AppDatabase _db;

  Future<List<TranslationsData>> getTranslations() {
    final query = _db.select(_db.translations)
      ..orderBy([
        (tbl) => OrderingTerm.asc(tbl.languageName),
        (tbl) => OrderingTerm.asc(tbl.name),
      ]);
    return query.get();
  }

  Future<List<Verse>> getChapter(
    String translationId,
    int bookId,
    int chapter,
  ) {
    final query = _db.select(_db.verses)
      ..where((tbl) =>
          tbl.translationId.equals(translationId) &
          tbl.bookId.equals(bookId) &
          tbl.chapter.equals(chapter))
      ..orderBy([
        (tbl) => OrderingTerm.asc(tbl.verse),
      ]);
    return query.get();
  }

  Stream<List<Verse>> watchChapter(
    String translationId,
    int bookId,
    int chapter,
  ) {
    final query = _db.select(_db.verses)
      ..where((tbl) =>
          tbl.translationId.equals(translationId) &
          tbl.bookId.equals(bookId) &
          tbl.chapter.equals(chapter))
      ..orderBy([
        (tbl) => OrderingTerm.asc(tbl.verse),
      ]);
    return query.watch();
  }

  Future<List<VerseSearchRow>> search(
    String translationId,
    String query, {
    int? limit,
    int? bookId,
  }) {
    return _searchWithFts(
      translationId,
      query,
      limit: limit,
      bookId: bookId,
    );
  }

  Future<List<VerseSearchRow>> _searchWithFts(
    String translationId,
    String query, {
    int? limit,
    int? bookId,
  }) async {
    await _db.ensureSearchIndex(translationId);
    final tableName = _db.ftsTableNameFor(translationId);
    final matchQuery = _prepareFtsQuery(query);
    final buffer = StringBuffer()
      ..writeln('SELECT')
      ..writeln('  v.translation_id,')
      ..writeln('  v.book_id,')
      ..writeln('  v.chapter,')
      ..writeln('  v.verse,')
      ..writeln('  v.text,')
      ..writeln(
          "  snippet($tableName, 0, '<b>', '</b>', '…', 10) AS snippet,")
      ..writeln('  bm25($tableName) AS rank')
      ..writeln('FROM $tableName f')
      ..writeln('JOIN verses v ON v.rowid = f.rowid')
      ..writeln('WHERE v.translation_id = ? AND f MATCH ?');
    if (bookId != null) {
      buffer.writeln('AND v.book_id = ?');
    }
    buffer
      ..writeln('ORDER BY rank ASC, v.book_id ASC, v.chapter ASC, v.verse ASC')
      ..writeln('LIMIT ?');

    final variables = <Variable<dynamic>>[
      Variable<String>(translationId),
      Variable<String>(matchQuery),
      if (bookId != null) Variable<int>(bookId),
      Variable<int>(limit ?? 50),
    ];

    final rows = await _db.customSelect(
      buffer.toString(),
      variables: variables,
      readsFrom: {_db.verses},
    ).get();

    return rows
        .map(
          (row) => VerseSearchRow(
            translationId: row.read<String>('translation_id'),
            bookId: row.read<int>('book_id'),
            chapter: row.read<int>('chapter'),
            verse: row.read<int>('verse'),
            text: row.read<String>('text'),
            snippet: row.read<String>('snippet'),
            rank: row.read<double?>('rank') ?? double.maxFinite,
          ),
        )
        .toList();
  }

  String _prepareFtsQuery(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return trimmed;
    }
    final escaped = trimmed.replaceAll('"', '""');
    return '"$escaped"';
  }

  Future<List<BookAggregate>> getBooks(String translationId) async {
    final rows = await (_db.select(_db.verses)
          ..where((tbl) => tbl.translationId.equals(translationId)))
        .get();

    final Map<int, Set<int>> chaptersByBook = {};
    for (final verse in rows) {
      chaptersByBook.putIfAbsent(verse.bookId, () => <int>{}).add(verse.chapter);
    }

    return chaptersByBook.entries
        .map(
          (entry) => BookAggregate(
            bookId: entry.key,
            chapters: entry.value.length,
          ),
        )
        .toList()
      ..sort((a, b) => a.bookId.compareTo(b.bookId));
  }
}

class VerseSearchRow {
  VerseSearchRow({
    required this.translationId,
    required this.bookId,
    required this.chapter,
    required this.verse,
    required this.text,
    required this.snippet,
    required this.rank,
  });

  final String translationId;
  final int bookId;
  final int chapter;
  final int verse;
  final String text;
  final String snippet;
  final double rank;
}

class BookAggregate {
  BookAggregate({required this.bookId, required this.chapters});

  final int bookId;
  final int chapters;
}

