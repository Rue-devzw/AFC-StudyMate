import 'package:drift/drift.dart';

import '../app_database.dart';

class BibleDao {
  BibleDao(this._db);

  final AppDatabase _db;

  Future<List<TranslationsData>> getTranslations() {
    return _db.select(_db.translations).get();
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

  Future<List<Verse>> search(
    String translationId,
    String query, {
    int? limit,
  }) {
    final q = _db.select(_db.verses)
      ..where((tbl) => tbl.translationId.equals(translationId) &
          tbl.text.lower().like('%${query.toLowerCase()}%'))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.bookId), (tbl) => OrderingTerm.asc(tbl.chapter), (tbl) => OrderingTerm.asc(tbl.verse)]);
    if (limit != null) {
      q.limit(limit);
    }
    return q.get();
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

class BookAggregate {
  BookAggregate({required this.bookId, required this.chapters});

  final int bookId;
  final int chapters;
}

const List<String> _bookNames = [
  'Genesis',
  'Exodus',
  'Leviticus',
  'Numbers',
  'Deuteronomy',
  'Joshua',
  'Judges',
  'Ruth',
  '1 Samuel',
  '2 Samuel',
  '1 Kings',
  '2 Kings',
  '1 Chronicles',
  '2 Chronicles',
  'Ezra',
  'Nehemiah',
  'Esther',
  'Job',
  'Psalms',
  'Proverbs',
  'Ecclesiastes',
  'Song of Solomon',
  'Isaiah',
  'Jeremiah',
  'Lamentations',
  'Ezekiel',
  'Daniel',
  'Hosea',
  'Joel',
  'Amos',
  'Obadiah',
  'Jonah',
  'Micah',
  'Nahum',
  'Habakkuk',
  'Zephaniah',
  'Haggai',
  'Zechariah',
  'Malachi',
  'Matthew',
  'Mark',
  'Luke',
  'John',
  'Acts',
  'Romans',
  '1 Corinthians',
  '2 Corinthians',
  'Galatians',
  'Ephesians',
  'Philippians',
  'Colossians',
  '1 Thessalonians',
  '2 Thessalonians',
  '1 Timothy',
  '2 Timothy',
  'Titus',
  'Philemon',
  'Hebrews',
  'James',
  '1 Peter',
  '2 Peter',
  '1 John',
  '2 John',
  '3 John',
  'Jude',
  'Revelation',
];

String bookNameForId(int bookId) {
  if (bookId <= 0 || bookId > _bookNames.length) {
    return 'Book $bookId';
  }
  return _bookNames[bookId - 1];
}
