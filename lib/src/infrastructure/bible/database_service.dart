import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart' as sqlite;

class BibleVersionManifest {
  BibleVersionManifest({
    required this.id,
    required this.name,
    required this.languageCode,
    required this.languageName,
    required this.version,
    required this.copyright,
    required this.bundle,
    this.abbreviation,
  });

  factory BibleVersionManifest.fromJson(Map<String, dynamic> json) {
    final language = json['language'] as Map<String, dynamic>? ?? const {};
    return BibleVersionManifest(
      id: json['id'] as String,
      name: json['name'] as String,
      abbreviation: json['abbreviation'] as String?,
      languageCode: language['code'] as String? ?? '',
      languageName: language['name'] as String? ?? '',
      version: json['version'] as String? ?? '',
      copyright: json['copyright'] as String? ?? '',
      bundle: json['bundle'] as String,
    );
  }

  final String id;
  final String name;
  final String? abbreviation;
  final String languageCode;
  final String languageName;
  final String version;
  final String copyright;
  final String bundle;
}

class BundledBibleVerse {
  const BundledBibleVerse({
    required this.bookId,
    required this.chapter,
    required this.verse,
    required this.text,
  });

  final int bookId;
  final int chapter;
  final int verse;
  final String text;
}

class DatabaseService {
  const DatabaseService(this._bundle);

  final AssetBundle _bundle;

  Future<List<BibleVersionManifest>> getBibleVersions() async {
    final manifestJson = await _safeLoadString('AssetManifest.json');
    if (manifestJson == null) {
      return const [];
    }

    final Map<String, dynamic> assetManifest =
        json.decode(manifestJson) as Map<String, dynamic>;
    final manifestPaths = assetManifest.keys
        .where(
          (path) => path.startsWith('assets/bibles/') && path.endsWith('.json'),
        )
        .toList()
      ..sort();

    final List<BibleVersionManifest> manifests = [];
    for (final path in manifestPaths) {
      final data = await _safeLoadString(path);
      if (data == null) {
        continue;
      }
      try {
        final Map<String, dynamic> jsonMap = json.decode(data) as Map<String, dynamic>;
        final manifest = BibleVersionManifest.fromJson(jsonMap);
        if (!assetManifest.containsKey(manifest.bundle)) {
          debugPrint(
            'Skipping Bible manifest at $path because bundle "${manifest.bundle}" is missing from the asset manifest.',
          );
          continue;
        }
        manifests.add(manifest);
      } on FormatException catch (error) {
        debugPrint('Invalid Bible manifest JSON at $path: $error');
      } on TypeError catch (error) {
        debugPrint('Malformed Bible manifest at $path: $error');
      }
    }

    manifests.sort((a, b) {
      final languageCompare =
          a.languageName.toLowerCase().compareTo(b.languageName.toLowerCase());
      if (languageCompare != 0) {
        return languageCompare;
      }
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return manifests;
  }

  Future<List<BundledBibleVerse>> loadVerses(
    BibleVersionManifest manifest,
  ) async {
    final byteData = await _bundle.load(manifest.bundle);
    final file = await _materializeDatabase(manifest.id, byteData);
    final db = sqlite.sqlite3.open(file.path, mode: sqlite.OpenMode.readOnly);
    try {
      final result = db.select(
        'SELECT book, chapter, verse, text FROM bible_verses ORDER BY book, chapter, verse',
      );
      return result
          .map(
            (row) => BundledBibleVerse(
              bookId: (row['book'] as num).toInt(),
              chapter: (row['chapter'] as num).toInt(),
              verse: (row['verse'] as num).toInt(),
              text: row['text'] as String,
            ),
          )
          .toList();
    } on sqlite.SqliteException {
      return const [];
    } finally {
      db.dispose();
      try {
        await file.parent.delete(recursive: true);
      } catch (_) {
        // Ignore cleanup errors.
      }
    }
  }

  Future<String?> _safeLoadString(String assetPath) async {
    try {
      return await _bundle.loadString(assetPath);
    } on FlutterError {
      return null;
    }
  }

  Future<File> _materializeDatabase(String id, ByteData data) async {
    final directory = await Directory.systemTemp.createTemp('afc_bible_$id');
    final file = File(p.join(directory.path, '$id.db'));
    final buffer = data.buffer;
    final bytes = buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}
