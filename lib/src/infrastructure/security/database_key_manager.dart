import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:sqlite3/sqlite3.dart' as sqlite;

import 'secure_storage_service.dart';

class DatabaseKeyManager {
  DatabaseKeyManager(this._storage);

  final SecureStorageService _storage;
  final _random = Random.secure();

  static const _storageKey = 'afc_studymate.db_key.v1';

  Future<String> obtainKey() async {
    final existing = await _storage.read(_storageKey);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }
    final bytes = List<int>.generate(64, (_) => _random.nextInt(256));
    final key = base64UrlEncode(bytes);
    await _storage.write(_storageKey, key);
    return key;
  }

  Future<void> ensureEncrypted(File file, String key) async {
    if (!await file.exists()) {
      return;
    }
    final db = sqlite.sqlite3.open(file.path);
    try {
      try {
        db.select('PRAGMA schema_version;');
        final sanitizedKey = _escape(key);
        db.execute("PRAGMA key = '';");
        _applyCipherSettings(db, sanitizedKey);
        db.execute("PRAGMA rekey = '$sanitizedKey';");
      } on sqlite.SqliteException catch (error) {
        if (error.extendedResultCode == sqlite.SqlError.SQLITE_NOTADB ||
            error.extendedResultCode == 26) {
          final sanitizedKey = _escape(key);
          _applyCipherSettings(db, sanitizedKey);
          db.select('PRAGMA schema_version;');
        } else {
          rethrow;
        }
      }
    } finally {
      db.dispose();
    }
  }

  void _applyCipherSettings(sqlite.Database db, String sanitizedKey) {
    db.execute("PRAGMA key = '$sanitizedKey';");
    db.execute('PRAGMA cipher_memory_security = ON;');
    db.execute('PRAGMA cipher_page_size = 4096;');
    db.execute('PRAGMA kdf_iter = 256000;');
  }

  String _escape(String key) => key.replaceAll("'", "''");
}
