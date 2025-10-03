import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Translations extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get language => text()();
  TextColumn get version => text()();
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

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'afc_studymate.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }

  @override
  int get schemaVersion => 1;

  Future<void> ensureSeeded() async {
    final hasTranslations = await (select(translations).get()).then((rows) => rows.isNotEmpty);
    if (hasTranslations) return;

    await batch((batch) {
      batch.insert(translations, TranslationsCompanion.insert(
        id: 'kjv',
        name: 'King James Version',
        language: 'en',
        version: '1.0',
        source: const Value('bundled'),
        installedAt: DateTime.now().millisecondsSinceEpoch,
      ));
      batch.insertAll(verses, [
        VersesCompanion.insert(
          translationId: 'kjv',
          bookId: 1,
          chapter: 1,
          verse: 1,
          text: 'In the beginning God created the heaven and the earth.',
        ),
        VersesCompanion.insert(
          translationId: 'kjv',
          bookId: 1,
          chapter: 1,
          verse: 2,
          text:
              'And the earth was without form, and void; and darkness was upon the face of the deep.',
        ),
      ]);
      batch.insert(lessons, LessonsCompanion.insert(
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
      ));
      batch.insert(localUsers, LocalUsersCompanion.insert(
        id: 'local-user',
        displayName: const Value('You'),
        avatarUrl: const Value(null),
      ));
    });
  }
}
