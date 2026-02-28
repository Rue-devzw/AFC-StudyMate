import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart' show AssetBundle, rootBundle;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

import '../models/bible_book.dart';
import '../models/bible_ref.dart';
import '../models/enums.dart';
import '../models/verse.dart';

final bibleServiceProvider = Provider<BibleService>((ref) {
  final service = BibleService();
  ref.onDispose(service.dispose);
  return service;
});

class BibleService {
  BibleService({
    AssetBundle? bundle,
    Future<Directory> Function()? supportDirectoryBuilder,
  }) : _bundle = bundle ?? rootBundle,
       _supportDirectoryBuilder =
           supportDirectoryBuilder ?? getApplicationSupportDirectory;

  final AssetBundle _bundle;
  final Future<Directory> Function() _supportDirectoryBuilder;
  final Map<Translation, Future<Database>> _databaseCache =
      <Translation, Future<Database>>{};

  Future<List<BibleBook>> getBooks(Translation translation) async {
    final db = await _databaseFor(translation);
    final result = db.select(
      'SELECT DISTINCT book, book_name_text FROM bible_verses ORDER BY book ASC',
    );
    return result.map((row) {
      final rawNumber = row['book'];
      final number = rawNumber is int ? rawNumber : (rawNumber as num).toInt();
      return BibleBook(
        number: number,
        name: row['book_name_text'] as String,
      );
    }).toList();
  }

  Future<int> getChapterCount(String book, Translation translation) async {
    final db = await _databaseFor(translation);
    final result = db.select(
      'SELECT MAX(chapter) AS chapterCount FROM bible_verses WHERE book_name_text = ?',
      <Object?>[book],
    );
    if (result.isEmpty) {
      return 0;
    }
    final value = result.first['chapterCount'];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return 0;
  }

  Future<List<Verse>> getChapter(
    String book,
    int chapter,
    Translation translation,
  ) async {
    final db = await _databaseFor(translation);
    final result = db.select(
      'SELECT book_name_text, chapter, verse, text FROM bible_verses '
      'WHERE book_name_text = ? AND chapter = ? ORDER BY verse ASC',
      <Object?>[book, chapter],
    );
    return result
        .map(
          (row) => Verse(
            row['book_name_text'] as String,
            row['chapter'] as int,
            row['verse'] as int,
            row['text'] as String,
          ),
        )
        .toList();
  }

  Future<List<Verse>> getPassage(BibleRef ref, Translation translation) async {
    final db = await _databaseFor(translation);
    final start = ref.verseStart ?? 1;
    final end =
        ref.verseEnd ??
        await _maxVerseInChapter(db, ref.book, ref.chapter, start);
    final result = db.select(
      'SELECT book_name_text, chapter, verse, text FROM bible_verses '
      'WHERE book_name_text = ? AND chapter = ? AND verse BETWEEN ? AND ? '
      'ORDER BY verse ASC',
      <Object?>[ref.book, ref.chapter, start, end],
    );
    return result
        .map(
          (row) => Verse(
            row['book_name_text'] as String,
            row['chapter'] as int,
            row['verse'] as int,
            row['text'] as String,
          ),
        )
        .toList();
  }

  Future<List<VerseSearchHit>> search(
    String query,
    Translation translation,
  ) async {
    final db = await _databaseFor(translation);
    final likeQuery = '%${query.trim()}%';
    final result = db.select(
      'SELECT book_name_text, chapter, verse, text FROM bible_verses '
      'WHERE text LIKE ? ORDER BY book, chapter, verse LIMIT 25',
      <Object?>[likeQuery],
    );
    return result
        .map(
          (row) => VerseSearchHit(
            reference:
                '${row['book_name_text']} ${row['chapter']}:${row['verse']}',
            preview: row['text'] as String,
          ),
        )
        .toList();
  }

  Future<Database> _databaseFor(Translation translation) {
    return _databaseCache.putIfAbsent(translation, () async {
      final assetPath = _assetPathForTranslation(translation);
      final directory = await _supportDirectoryBuilder();
      final fileName = assetPath.split('/').last;
      final file = File('${directory.path}/$fileName');

      if (!await file.exists()) {
        final data = await _bundle.load(assetPath);
        final bytes = data.buffer.asUint8List(
          data.offsetInBytes,
          data.lengthInBytes,
        );
        await file.create(recursive: true);
        await file.writeAsBytes(bytes, flush: true);
      }

      return sqlite3.open(file.path, mode: OpenMode.readOnly);
    });
  }

  Future<int> _maxVerseInChapter(
    Database db,
    String book,
    int chapter,
    int fallback,
  ) async {
    final result = db.select(
      'SELECT MAX(verse) AS maxVerse FROM bible_verses WHERE book_name_text = ? AND chapter = ?',
      <Object?>[book, chapter],
    );
    if (result.isEmpty) {
      return fallback;
    }
    final value = result.first['maxVerse'];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return fallback;
  }

  String _assetPathForTranslation(Translation translation) {
    switch (translation) {
      case Translation.kjv:
        return 'assets/db/kjv.db';
      case Translation.shona:
        return 'assets/db/shona_bible.db';
    }
  }

  Future<void> dispose() async {
    for (final future in _databaseCache.values) {
      final db = await future;
      db.dispose();
    }
    _databaseCache.clear();
  }
}
