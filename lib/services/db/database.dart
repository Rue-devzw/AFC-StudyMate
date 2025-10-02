import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../models/bible.dart';

part 'database.g.dart';

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
  TextColumn get translationId =>
      text().references(Translations, #id, onDelete: KeyAction.cascade)();
  IntColumn get book => integer()();
  IntColumn get chapter => integer()();
  IntColumn get verse => integer()();
  TextColumn get text => text()();
  BoolColumn get isBofm => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {translationId, book, chapter, verse};
}

class Bookmarks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get book => integer()();
  IntColumn get chapter => integer()();
  IntColumn get verse => integer()();
  DateTimeColumn get createdAt => dateTime()();
}

class Highlights extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get translationId =>
      text().references(Translations, #id, onDelete: KeyAction.cascade)();
  IntColumn get book => integer()();
  IntColumn get chapter => integer()();
  IntColumn get verse => integer()();
  IntColumn get color => integer()();
  DateTimeColumn get createdAt => dateTime()();
}

class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get translationId =>
      text().references(Translations, #id, onDelete: KeyAction.cascade)();
  IntColumn get book => integer()();
  IntColumn get chapter => integer()();
  IntColumn get verse => integer()();
  TextColumn get note => text()();
  DateTimeColumn get createdAt => dateTime()();
}

class Lessons extends Table {
  TextColumn get id => text()();
  IntColumn get lessonId => integer()();
  TextColumn get lessonTitle => text()();
  TextColumn get week => text()();

  @override
  Set<Column> get primaryKey => {id, lessonId};
}

class Progress extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get lessonId =>
      integer().references(Lessons, #lessonId, onDelete: KeyAction.cascade)();
  IntColumn get verseId => integer()();
  DateTimeColumn get completedAt => dateTime()();
}

class LocalUsers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get photoUrl => text().nullable()();
  TextColumn get email => text().nullable()();
}

class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get model => text()();
  TextColumn get action => text()();
  TextColumn get data => text()();
  DateTimeColumn get createdAt => dateTime()();
}

class Messages extends Table {
  TextColumn get id => text()();
  TextColumn get conversationId => text()();
  TextColumn get senderId => text()();
  TextColumn get text => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
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
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  factory AppDatabase() {
    return AppDatabase(LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'db.sqlite'));
      return NativeDatabase(file);
    }));
  }

  @override
  int get schemaVersion => 1;

  Future<List<Verse>> getVerses(int book, int chapter) async {
    return await (select(verses)..where((v) => v.book.equals(book) & v.chapter.equals(chapter))).get();
  }

  Future<List<Verse>> searchVerses(String query) async {
    return await (select(verses)..where((v) => v.text.like('%$query%'))).get();
  }

  Future<void> insertVerses(List<Verse> versesToInsert) async {
    await batch((batch) {
      batch.insertAll(verses, versesToInsert);
    });
  }
}
