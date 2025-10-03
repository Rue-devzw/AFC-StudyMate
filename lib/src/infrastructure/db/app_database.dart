import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../bible/database_service.dart';

part 'app_database.g.dart';

class Translations extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get language => text()();
  TextColumn get languageName =>
      text().withDefault(const Constant(''))();
  TextColumn get version => text()();
  TextColumn get copyright =>
      text().withDefault(const Constant(''))();
  TextColumn get source => text().nullable()();
  IntColumn get installedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class Verses extends Table {
  TextColumn get translationId => text()
      .references(Translations, #id, onDelete: KeyAction.cascade)();
  IntColumn get bookId => integer()();
  IntColumn get chapter => integer()();
  IntColumn get verse => integer()();
  TextColumn get text => text()();

  @override
  Set<Column> get primaryKey => {translationId, bookId, chapter, verse};
}

class Bookmarks extends Table {
  TextColumn get id => text()();
  TextColumn get translationId => text()
      .references(Translations, #id, onDelete: KeyAction.cascade)();
  IntColumn get bookId => integer()();
  IntColumn get chapter => integer()();
  IntColumn get verse => integer()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class Highlights extends Table {
  TextColumn get id => text()();
  TextColumn get translationId => text()
      .references(Translations, #id, onDelete: KeyAction.cascade)();
  IntColumn get bookId => integer()();
  IntColumn get chapter => integer()();
  IntColumn get verse => integer()();
  TextColumn get colour => text()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class Notes extends Table {
  TextColumn get id => text()();
  TextColumn get translationId => text()
      .references(Translations, #id, onDelete: KeyAction.cascade)();
  IntColumn get bookId => integer()();
  IntColumn get chapter => integer()();
  IntColumn get verse => integer()();
  TextColumn get text => text()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class Lessons extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get lessonClass => text()();
  IntColumn get ageMin => integer().nullable()();
  IntColumn get ageMax => integer().nullable()();
  TextColumn get objectives => text().nullable()();
  TextColumn get scriptures => text().nullable()();
  TextColumn get contentHtml => text().nullable()();
  TextColumn get teacherNotes => text().nullable()();
  TextColumn get attachments => text().nullable()();
  TextColumn get quizzes => text().nullable()();
  TextColumn get sourceUrl => text().nullable()();
  IntColumn get lastFetchedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Progress extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get lessonId => text()
      .references(Lessons, #id, onDelete: KeyAction.cascade)();
  TextColumn get status => text()();
  RealColumn get quizScore => real().nullable()();
  IntColumn get timeSpentSeconds => integer().withDefault(const Constant(0))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalUsers extends Table {
  TextColumn get id => text()();
  TextColumn get displayName => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncQueue extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get opType => text()();
  TextColumn get payload => text()();
  IntColumn get createdAt => integer()();
  IntColumn get lastTriedAt => integer().nullable()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class Messages extends Table {
  TextColumn get id => text()();
  TextColumn get classId => text()();
  TextColumn get userId => text()();
  TextColumn get body => text()();
  IntColumn get createdAt => integer()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  BoolColumn get flagged => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Translations,
    Verses,
    Bookmarks,
    Highlights,
    Notes,
    Lessons,
    Progress,
    LocalUsers,
    SyncQueue,
    Messages,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _openConnection());

  Future<void>? _seedingFuture;

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'afc_studymate.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAllTables();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(translations, translations.languageName);
            await m.addColumn(translations, translations.copyright);
          }
        },
      );

  Future<void> ensureSeeded() {
    return _seedingFuture ??=
        _seedBundledContent().catchError((error, stackTrace) {
      _seedingFuture = null;
      Error.throwWithStackTrace(error, stackTrace);
    });
  }

  Future<void> _seedBundledContent() async {
    final service = DatabaseService(rootBundle);
    final bundledVersions = await service.getBibleVersions();
    if (bundledVersions.isEmpty) {
      return;
    }

    final existingTranslations = await select(translations).get();
    final existingById = {
      for (final row in existingTranslations) row.id: row,
    };

    for (final manifest in bundledVersions) {
      final existing = existingById[manifest.id];

      if (existing != null) {
        await (update(translations)..where((tbl) => tbl.id.equals(manifest.id))).write(
          TranslationsCompanion(
            name: Value(manifest.name),
            language: Value(manifest.languageCode),
            languageName: Value(manifest.languageName),
            version: Value(manifest.version),
            copyright: Value(manifest.copyright),
            source: const Value('bundled'),
          ),
        );
        final hasVerseData = await _hasVerses(manifest.id);
        if (hasVerseData) {
          continue;
        }
      }

      final verseRows = await service.loadVerses(manifest);
      if (verseRows.isEmpty) {
        continue;
      }

      await transaction(() async {
        await into(translations).insert(
          TranslationsCompanion.insert(
            id: manifest.id,
            name: manifest.name,
            language: manifest.languageCode,
            languageName: manifest.languageName,
            version: manifest.version,
            copyright: manifest.copyright,
            source: const Value('bundled'),
            installedAt: DateTime.now().millisecondsSinceEpoch,
          ),
          mode: InsertMode.insertOrReplace,
        );

        await batch((batch) {
          batch.insertAll(
            verses,
            verseRows
                .map(
                  (verse) => VersesCompanion.insert(
                    translationId: manifest.id,
                    bookId: verse.bookId,
                    chapter: verse.chapter,
                    verse: verse.verse,
                    text: verse.text,
                  ),
                )
                .toList(),
            mode: InsertMode.insertOrReplace,
          );
        });
      });
    }

    await batch((batch) {
      batch.insert(
        lessons,
        LessonsCompanion.insert(
          id: 'sample-lesson',
          title: 'Welcome to StudyMate',
          lessonClass: 'General',
          objectives: const Value('["Explore the sample lesson"]'),
          scriptures: const Value('[{"ref":"Genesis 1","tId":"kjv"}]'),
          contentHtml: const Value('<p>This is placeholder content for the pilot lesson.</p>'),
          teacherNotes: const Value('<p>Guide learners through the creation story.</p>'),
          attachments: const Value('[]'),
          quizzes: const Value('[]'),
          sourceUrl: const Value(null),
          lastFetchedAt: Value(DateTime.now().millisecondsSinceEpoch),
        ),
        mode: InsertMode.insertOrReplace,
      );
      batch.insert(
        localUsers,
        LocalUsersCompanion.insert(
          id: 'local-user',
          displayName: const Value('You'),
          avatarUrl: const Value(null),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    });
  }

  Future<bool> _hasVerses(String translationId) async {
    final count = await customSelect(
      'SELECT COUNT(*) as count FROM verses WHERE translation_id = ? LIMIT 1',
      variables: [Variable<String>(translationId)],
      readsFrom: {verses},
    ).map((row) => row.read<int>('count')).getSingleOrNull();
    return (count ?? 0) > 0;
  }

  String ftsTableNameFor(String translationId) {
    final sanitized = translationId.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
    return 'verses_${sanitized}_fts';
  }

  String _ftsTriggerName(String translationId, String suffix) {
    final tableName = ftsTableNameFor(translationId);
    return '${tableName}_$suffix';
  }

  String _escapeLiteral(String value) => value.replaceAll("'", "''");

  Future<void> _createFtsInfrastructure(String translationId) async {
    final tableName = ftsTableNameFor(translationId);
    final escapedId = _escapeLiteral(translationId);

    await customStatement(
      'CREATE VIRTUAL TABLE IF NOT EXISTS $tableName USING fts5(\n'
      '  text,\n'
      '  book_id UNINDEXED,\n'
      '  chapter UNINDEXED,\n'
      '  verse UNINDEXED,\n'
      '  tokenize="unicode61 remove_diacritics 2"\n'
      ')',
    );

    final insertTrigger = _ftsTriggerName(translationId, 'ai');
    final updateTrigger = _ftsTriggerName(translationId, 'au');
    final deleteTrigger = _ftsTriggerName(translationId, 'ad');

    await customStatement(
      'CREATE TRIGGER IF NOT EXISTS $insertTrigger\n'
      'AFTER INSERT ON verses\n'
      "WHEN NEW.translation_id = '$escapedId'\n"
      'BEGIN\n'
      '  INSERT INTO $tableName(rowid, text, book_id, chapter, verse)\n'
      '  VALUES(NEW.rowid, NEW.text, NEW.book_id, NEW.chapter, NEW.verse);\n'
      'END',
    );

    await customStatement(
      'CREATE TRIGGER IF NOT EXISTS $updateTrigger\n'
      'AFTER UPDATE ON verses\n'
      'WHEN OLD.translation_id = NEW.translation_id\n'
      "  AND NEW.translation_id = '$escapedId'\n"
      'BEGIN\n'
      "  INSERT INTO $tableName($tableName, rowid, text, book_id, chapter, verse)\n"
      '  VALUES(\'delete\', OLD.rowid, OLD.text, OLD.book_id, OLD.chapter, OLD.verse);\n'
      '  INSERT INTO $tableName(rowid, text, book_id, chapter, verse)\n'
      '  VALUES(NEW.rowid, NEW.text, NEW.book_id, NEW.chapter, NEW.verse);\n'
      'END',
    );

    await customStatement(
      'CREATE TRIGGER IF NOT EXISTS $deleteTrigger\n'
      'AFTER DELETE ON verses\n'
      "WHEN OLD.translation_id = '$escapedId'\n"
      'BEGIN\n'
      "  INSERT INTO $tableName($tableName, rowid, text, book_id, chapter, verse)\n"
      '  VALUES(\'delete\', OLD.rowid, OLD.text, OLD.book_id, OLD.chapter, OLD.verse);\n'
      'END',
    );
  }

  Future<void> dropSearchIndex(String translationId) async {
    final tableName = ftsTableNameFor(translationId);
    await customStatement(
        'DROP TRIGGER IF EXISTS ${_ftsTriggerName(translationId, 'ai')}');
    await customStatement(
        'DROP TRIGGER IF EXISTS ${_ftsTriggerName(translationId, 'au')}');
    await customStatement(
        'DROP TRIGGER IF EXISTS ${_ftsTriggerName(translationId, 'ad')}');
    await customStatement('DROP TABLE IF EXISTS $tableName');
  }

  Future<void> rebuildFtsFor(String translationId) async {
    final tableName = ftsTableNameFor(translationId);
    await dropSearchIndex(translationId);
    await _createFtsInfrastructure(translationId);
    await customStatement(
      'INSERT INTO $tableName(rowid, text, book_id, chapter, verse) SELECT rowid, text, book_id, chapter, verse FROM verses WHERE translation_id = ?',
      [translationId],
    );
  }

  Future<void> ensureSearchIndex(String translationId) async {
    final exists = await hasSearchIndex(translationId);
    if (!exists) {
      await rebuildFtsFor(translationId);
    } else {
      await _createFtsInfrastructure(translationId);
    }
  }

  Future<bool> hasSearchIndex(String translationId) async {
    final tableName = ftsTableNameFor(translationId);
    final rows = await customSelect(
      'SELECT name FROM sqlite_master WHERE type = ? AND name = ?',
      variables: [
        const Variable<String>('table'),
        Variable<String>(tableName),
      ],
    ).get();
    return rows.isNotEmpty;
  }
}
