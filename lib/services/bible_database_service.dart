import 'dart:async';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import '../models/bible.dart';
import 'dart:convert';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  final Map<String, Database> _databases = {};

  String _escapeLikePattern(String input) {
    return input.replaceAllMapped(
      RegExp(r'([%_\\])'),
      (match) => '\\${match[1]}',
    );
  }

  Future<Database> _getDatabase(String bibleId) async {
    if (_databases.containsKey(bibleId)) {
      return _databases[bibleId]!;
    }
    _databases[bibleId] = await _initDb(bibleId);
    return _databases[bibleId]!;
  }

  Future<Database> _initDb(String bibleId) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, '$bibleId.db');

    var exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join('assets/bibles', '$bibleId.db'));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path);
  }

  Future<List<Book>> getBooks(String bibleId) async {
    final db = await _getDatabase(bibleId);
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT book, book_name_text, COUNT(DISTINCT chapter) as chapterCount FROM bible_verses GROUP BY book, book_name_text ORDER BY book',
    );
    return List.generate(maps.length, (i) => Book.fromMap(maps[i]));
  }

  Future<List<Verse>> getVerses(String bibleId, int bookId, int chapter) async {
    final db = await _getDatabase(bibleId);
    final List<Map<String, dynamic>> maps = await db.query(
      'bible_verses',
      where: 'book = ? AND chapter = ?',
      whereArgs: [bookId, chapter],
    );
    return List.generate(maps.length, (i) => Verse.fromMap(maps[i]));
  }

  Future<Verse?> getVerse(
    String bibleId,
    int bookId,
    int chapter,
    int verseNumber,
  ) async {
    final db = await _getDatabase(bibleId);
    final maps = await db.query(
      'bible_verses',
      where: 'book = ? AND chapter = ? AND verse = ?',
      whereArgs: [bookId, chapter, verseNumber],
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }

    return Verse.fromMap(maps.first);
  }

  Future<List<Verse>> searchVerses(
    String bibleId,
    String query, {
    int? limit,
  }) async {
    if (query.trim().isEmpty) {
      return [];
    }

    final db = await _getDatabase(bibleId);
    final safeQuery = _escapeLikePattern(query.toLowerCase());
    final List<Map<String, dynamic>> maps = await db.query(
      'bible_verses',
      where: "LOWER(text) LIKE ? ESCAPE '\\\\'",
      whereArgs: ['%$safeQuery%'],
      orderBy: 'book, chapter, verse',
      limit: limit,
    );

    return List.generate(maps.length, (i) => Verse.fromMap(maps[i]));
  }

  Future<List<Bible>> getBibleVersions() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final biblePaths = manifestMap.keys
        .where((String key) => key.startsWith('assets/bibles/') && key.endsWith('.db'))
        .toList();

    List<Bible> bibles = [];
    for (String path in biblePaths) {
      String bibleId = basename(path).replaceAll('.db', '');
      // You can expand this to get more metadata from the database if needed
      bibles.add(Bible(id: bibleId, name: bibleId.toUpperCase()));
    }
    return bibles;
  }
}
