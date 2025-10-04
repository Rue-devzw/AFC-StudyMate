import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../bible/database_service.dart';
import '../security/database_key_manager.dart';
import '../security/secure_storage_service.dart';

part 'app_database.g.dart';

class Translations extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get language => text()();
  TextColumn get languageName => text().withDefault(const Constant(''))();
  TextColumn get version => text()();
  TextColumn get copyright => text().withDefault(const Constant(''))();
  TextColumn get source => text().nullable()();
  IntColumn get installedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('VerseRow')
class Verses extends Table {
  TextColumn get translationId =>
      text().references(Translations, #id, onDelete: KeyAction.cascade)();
  IntColumn get bookId => integer()();
  IntColumn get chapter => integer()();
  IntColumn get verse => integer()();
  @DriftColumnName('text')
  TextColumn get verseText => text()();

  @override
  Set<Column> get primaryKey => {translationId, bookId, chapter, verse};
}

class LocalUsers extends Table {
  TextColumn get id => text()();
  TextColumn get displayName => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get preferredCohortId => text().nullable()();
  TextColumn get preferredCohortTitle => text().nullable()();
  TextColumn get preferredLessonClass => text().nullable()();
  TextColumn get roles => text().withDefault(const Constant('[]'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('BookmarkRow')
class Bookmarks extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()
      .references(LocalUsers, #id, onDelete: KeyAction.cascade)
      .withDefault(const Constant('local-user'))();
  TextColumn get translationId =>
      text().references(Translations, #id, onDelete: KeyAction.cascade)();
  IntColumn get bookId => integer()();
  IntColumn get chapter => integer()();
  IntColumn get verse => integer()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('HighlightRow')
class Highlights extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()
      .references(LocalUsers, #id, onDelete: KeyAction.cascade)
      .withDefault(const Constant('local-user'))();
  TextColumn get translationId =>
      text().references(Translations, #id, onDelete: KeyAction.cascade)();
  IntColumn get bookId => integer()();
  IntColumn get chapter => integer()();
  IntColumn get verse => integer()();
  TextColumn get colour => text()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('NoteRow')
class Notes extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()
      .references(LocalUsers, #id, onDelete: KeyAction.cascade)
      .withDefault(const Constant('local-user'))();
  TextColumn get translationId =>
      text().references(Translations, #id, onDelete: KeyAction.cascade)();
  IntColumn get bookId => integer()();
  IntColumn get chapter => integer()();
  IntColumn get verse => integer()();
  @DriftColumnName('text')
  TextColumn get noteText => text()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('NoteRevisionRow')
class NoteRevisions extends Table {
  TextColumn get noteId =>
      text().references(Notes, #id, onDelete: KeyAction.cascade)();
  IntColumn get version => integer()();
  @DriftColumnName('text')
  TextColumn get revisionText => text()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {noteId, version};
}

@DataClassName('LessonRow')
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
  TextColumn get feedId => text().nullable()();
  TextColumn get cohortId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LessonObjectiveRow')
class LessonObjectives extends Table {
  TextColumn get lessonId =>
      text().references(Lessons, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get objective => text()();

  @override
  Set<Column> get primaryKey => {lessonId, position};
}

@DataClassName('LessonScriptureRow')
class LessonScriptures extends Table {
  TextColumn get lessonId =>
      text().references(Lessons, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get reference => text()();
  TextColumn get translationId => text().nullable()();

  @override
  Set<Column> get primaryKey => {lessonId, position};
}

@DataClassName('LessonAttachmentRow')
class LessonAttachments extends Table {
  TextColumn get lessonId =>
      text().references(Lessons, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get type => text()();
  TextColumn get title => text().nullable()();
  TextColumn get url => text()();
  TextColumn get localPath => text().nullable()();
  IntColumn get sizeBytes => integer().nullable()();
  IntColumn get downloadedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {lessonId, position};
}

@DataClassName('LessonQuizRow')
class LessonQuizzes extends Table {
  TextColumn get id => text()();
  TextColumn get lessonId =>
      text().references(Lessons, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get type => text()();
  TextColumn get prompt => text()();
  TextColumn get answer => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LessonQuizOptionRow')
class LessonQuizOptions extends Table {
  TextColumn get quizId =>
      text().references(LessonQuizzes, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get label => text()();
  BoolColumn get isCorrect => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {quizId, position};
}

@DataClassName('LessonDraftRow')
class LessonDrafts extends Table {
  TextColumn get id => text()();
  TextColumn get lessonId => text().nullable()();
  TextColumn get authorId => text()();
  TextColumn get title => text()();
  TextColumn get deltaJson => text()();
  TextColumn get status => text().withDefault(const Constant('draft'))();
  TextColumn get approverId => text().nullable()();
  TextColumn get reviewerComment => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LessonFeedRow')
class LessonFeeds extends Table {
  TextColumn get id => text()();
  TextColumn get source => text()();
  TextColumn get cohort => text().nullable()();
  TextColumn get lessonClass => text().nullable()();
  TextColumn get checksum => text().nullable()();
  TextColumn get etag => text().nullable()();
  IntColumn get lastModified => integer().nullable()();
  IntColumn get lastFetchedAt => integer().nullable()();
  IntColumn get lastCheckedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LessonSourceRow')
class LessonSources extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get location => text()();
  TextColumn get label => text().nullable()();
  TextColumn get cohort => text().nullable()();
  TextColumn get lessonClass => text().nullable()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  BoolColumn get isBundled => boolean().withDefault(const Constant(false))();
  IntColumn get priority => integer().withDefault(const Constant(0))();
  TextColumn get checksum => text().nullable()();
  TextColumn get etag => text().nullable()();
  IntColumn get lastModified => integer().nullable()();
  IntColumn get lastSyncedAt => integer().nullable()();
  IntColumn get lastAttemptedAt => integer().nullable()();
  IntColumn get lastCheckedAt => integer().nullable()();
  TextColumn get lastError => text().nullable()();
  IntColumn get lessonCount => integer().withDefault(const Constant(0))();
  IntColumn get attachmentBytes => integer().withDefault(const Constant(0))();
  IntColumn get quotaBytes => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('RoundtableRow')
class RoundtableEvents extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get classId => text().nullable()();
  IntColumn get startTime => integer()();
  IntColumn get endTime => integer()();
  TextColumn get conferencingUrl => text().nullable()();
  TextColumn get hostConferencingUrl => text().nullable()();
  TextColumn get meetingRoom => text().nullable()();
  IntColumn get reminderMinutesBefore =>
      integer().withDefault(const Constant(30))();
  TextColumn get createdBy => text()();
  IntColumn get updatedAt => integer()();
  TextColumn get recordingStoragePath => text().nullable()();
  TextColumn get recordingUrl => text().nullable()();
  IntColumn get recordingIndexedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MeetingLinkRow')
class MeetingLinks extends Table {
  TextColumn get id => text()();
  TextColumn get contextType => text()();
  TextColumn get contextId => text()();
  TextColumn get roomName => text()();
  TextColumn get role => text()();
  TextColumn get url => text()();
  TextColumn get title => text()();
  IntColumn get createdAt => integer()();
  IntColumn get scheduledStart => integer().nullable()();
  IntColumn get reminderAt => integer().nullable()();
  BoolColumn get reminderScheduled =>
      boolean().withDefault(const Constant(false))();
  TextColumn get recordingStoragePath => text().nullable()();
  TextColumn get recordingUrl => text().nullable()();
  IntColumn get recordingIndexedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DiscussionThreadRow')
class DiscussionThreads extends Table {
  TextColumn get id => text()();
  TextColumn get classId => text()();
  TextColumn get title => text()();
  TextColumn get createdBy => text()();
  TextColumn get status => text().withDefault(const Constant('open'))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DiscussionPostRow')
class DiscussionPosts extends Table {
  TextColumn get id => text()();
  TextColumn get threadId =>
      text().references(DiscussionThreads, #id, onDelete: KeyAction.cascade)();
  TextColumn get authorId => text()();
  TextColumn get role => text().nullable()();
  TextColumn get body => text()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class Progress extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get lessonId =>
      text().references(Lessons, #id, onDelete: KeyAction.cascade)();
  TextColumn get status => text()();
  RealColumn get quizScore => real().nullable()();
  IntColumn get timeSpentSeconds => integer().withDefault(const Constant(0))();
  IntColumn get startedAt => integer().nullable()();
  IntColumn get completedAt => integer().nullable()();
  IntColumn get updatedAt => integer()();

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
  IntColumn get updatedAt => integer().withDefault(const Constant(0))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  BoolColumn get flagged => boolean().withDefault(const Constant(false))();
  TextColumn get attachments => text().withDefault(const Constant('[]'))();
  TextColumn get authorName => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TypingIndicatorRow')
class TypingIndicators extends Table {
  TextColumn get classId => text()();
  TextColumn get userId => text()();
  BoolColumn get isTyping => boolean().withDefault(const Constant(false))();
  IntColumn get updatedAt => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {classId, userId};
}

@DataClassName('ModerationActionRow')
class ModerationActionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get classId => text()();
  TextColumn get targetUserId => text()();
  TextColumn get moderatorId => text()();
  TextColumn get type => text()();
  TextColumn get status => text()();
  TextColumn get reason => text().nullable()();
  TextColumn get metadata => text().withDefault(const Constant('{}'))();
  IntColumn get createdAt => integer()();
  IntColumn get expiresAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ModerationAppealRow')
class ModerationAppealsTable extends Table {
  TextColumn get id => text()();
  TextColumn get actionId => text()
      .references(ModerationActionsTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get classId => text()();
  TextColumn get userId => text()();
  TextColumn get message => text()();
  TextColumn get status => text()();
  TextColumn get resolutionNotes => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get resolvedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class NoteChangeTrackers extends Table {
  TextColumn get noteId =>
      text().references(Notes, #id, onDelete: KeyAction.noAction)();
  TextColumn get userId => text()();
  IntColumn get localUpdatedAt => integer().withDefault(const Constant(0))();
  IntColumn get remoteUpdatedAt => integer().withDefault(const Constant(0))();
  IntColumn get lastSyncedAt => integer().nullable()();
  TextColumn get lastOperation =>
      text().withDefault(const Constant('upsert'))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get conflictReason => text().nullable()();
  TextColumn get conflictPayload => text().nullable()();
  IntColumn get conflictDetectedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {noteId};
}

class ProgressChangeTrackers extends Table {
  TextColumn get progressId =>
      text().references(Progress, #id, onDelete: KeyAction.noAction)();
  TextColumn get userId => text()();
  IntColumn get localUpdatedAt => integer().withDefault(const Constant(0))();
  IntColumn get remoteUpdatedAt => integer().withDefault(const Constant(0))();
  IntColumn get lastSyncedAt => integer().nullable()();
  TextColumn get lastOperation =>
      text().withDefault(const Constant('upsert'))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get conflictReason => text().nullable()();
  TextColumn get conflictPayload => text().nullable()();
  IntColumn get conflictDetectedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {progressId};
}

class MessageChangeTrackers extends Table {
  TextColumn get messageId =>
      text().references(Messages, #id, onDelete: KeyAction.cascade)();
  TextColumn get userId => text()();
  IntColumn get localUpdatedAt => integer().withDefault(const Constant(0))();
  IntColumn get remoteUpdatedAt => integer().withDefault(const Constant(0))();
  IntColumn get lastSyncedAt => integer().nullable()();
  TextColumn get lastOperation =>
      text().withDefault(const Constant('upsert'))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get conflictReason => text().nullable()();
  TextColumn get conflictPayload => text().nullable()();
  IntColumn get conflictDetectedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {messageId};
}

@DriftDatabase(
  tables: [
    Translations,
    Verses,
    Bookmarks,
    Highlights,
    Notes,
    NoteRevisions,
    Lessons,
    LessonObjectives,
    LessonScriptures,
    LessonAttachments,
    LessonQuizzes,
    LessonQuizOptions,
    LessonDrafts,
    LessonFeeds,
    LessonSources,
    RoundtableEvents,
    MeetingLinks,
    DiscussionThreads,
    DiscussionPosts,
    Progress,
    LocalUsers,
    SyncQueue,
    Messages,
    TypingIndicators,
    ModerationActionsTable,
    ModerationAppealsTable,
    NoteChangeTrackers,
    ProgressChangeTrackers,
    MessageChangeTrackers,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  Future<void>? _seedingFuture;

  static QueryExecutor _openConnection() {
    final secureStorage = SecureStorageService();
    final keyManager = DatabaseKeyManager(secureStorage);
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'afc_studymate.sqlite'));
      final key = await keyManager.obtainKey();
      await keyManager.ensureEncrypted(file, key);
      final escapedKey = key.replaceAll("'", "''");
      return NativeDatabase.createInBackground(
        file,
        setup: (rawDb) {
          rawDb.execute("PRAGMA key = '$escapedKey';");
          rawDb.execute('PRAGMA cipher_memory_security = ON;');
          rawDb.execute('PRAGMA cipher_page_size = 4096;');
          rawDb.execute('PRAGMA kdf_iter = 256000;');
        },
      );
    });
  }

  @override
  int get schemaVersion => 11;

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
          if (from < 3) {
            await m.createTable(noteRevisions);
          }
          if (from < 4) {
            await m.addColumn(lessons, lessons.feedId);
            await m.addColumn(lessons, lessons.cohortId);
            await m.createTable(lessonObjectives);
            await m.createTable(lessonScriptures);
            await m.createTable(lessonAttachments);
            await m.createTable(lessonQuizzes);
            await m.createTable(lessonQuizOptions);
            await m.createTable(lessonFeeds);
          }
          if (from < 5) {
            await m.addColumn(lessonAttachments, lessonAttachments.localPath);
            await m.addColumn(lessonAttachments, lessonAttachments.sizeBytes);
            await m.addColumn(
                lessonAttachments, lessonAttachments.downloadedAt);
            await m.createTable(lessonSources);
          }
          if (from < 6) {
            await m.addColumn(progress, progress.startedAt);
            await m.addColumn(progress, progress.completedAt);
          }
          if (from < 7) {
            await m.addColumn(bookmarks, bookmarks.userId);
            await m.addColumn(highlights, highlights.userId);
            await m.addColumn(notes, notes.userId);
            await m.addColumn(localUsers, localUsers.preferredCohortId);
            await m.addColumn(localUsers, localUsers.preferredCohortTitle);
            await m.addColumn(localUsers, localUsers.preferredLessonClass);
            await m.addColumn(localUsers, localUsers.isActive);
            await m.issueCustomStatement(
                "UPDATE local_users SET is_active = CASE WHEN id = 'local-user' THEN 1 ELSE 0 END");
            await m.issueCustomStatement(
                "INSERT INTO local_users (id, display_name, avatar_url, preferred_cohort_id, preferred_cohort_title, preferred_lesson_class, is_active) SELECT 'local-user', NULL, NULL, NULL, NULL, NULL, 1 WHERE NOT EXISTS (SELECT 1 FROM local_users WHERE id = 'local-user')");
            await m.issueCustomStatement(
                "UPDATE bookmarks SET user_id = 'local-user' WHERE user_id IS NULL");
            await m.issueCustomStatement(
                "UPDATE highlights SET user_id = 'local-user' WHERE user_id IS NULL");
            await m.issueCustomStatement(
                "UPDATE notes SET user_id = 'local-user' WHERE user_id IS NULL");
          }
          if (from < 8) {
            await m.addColumn(messages, messages.updatedAt);
            await m.createTable(noteChangeTrackers);
            await m.createTable(progressChangeTrackers);
            await m.createTable(messageChangeTrackers);
          }
          if (from < 9) {
            await m.addColumn(messages, messages.attachments);
            await m.addColumn(messages, messages.authorName);
            await m.createTable(typingIndicators);
            await m.createTable(moderationActionsTable);
            await m.createTable(moderationAppealsTable);
          }
          if (from < 10) {
            await m.addColumn(localUsers, localUsers.roles);
            await m.createTable(lessonDrafts);
            await m.createTable(roundtableEvents);
            await m.createTable(discussionThreads);
            await m.createTable(discussionPosts);
          }
          if (from < 11) {
            await m.createTable(meetingLinks);
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
        await (update(translations)..where((tbl) => tbl.id.equals(manifest.id)))
            .write(
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
                    verseText: verse.text,
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
        localUsers,
        LocalUsersCompanion.insert(
          id: 'local-user',
          displayName: const Value('You'),
          avatarUrl: const Value(null),
          roles: const Value('["teacher"]'),
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
      '  VALUES(NEW.rowid, NEW.verse_text, NEW.book_id, NEW.chapter, NEW.verse);\n'
      'END',
    );

    await customStatement(
      'CREATE TRIGGER IF NOT EXISTS $updateTrigger\n'
      'AFTER UPDATE ON verses\n'
      'WHEN OLD.translation_id = NEW.translation_id\n'
      "  AND NEW.translation_id = '$escapedId'\n"
      'BEGIN\n'
      "  INSERT INTO $tableName($tableName, rowid, text, book_id, chapter, verse)\n"
      '  VALUES(\'delete\', OLD.rowid, OLD.verse_text, OLD.book_id, OLD.chapter, OLD.verse);\n'
      '  INSERT INTO $tableName(rowid, text, book_id, chapter, verse)\n'
      '  VALUES(NEW.rowid, NEW.verse_text, NEW.book_id, NEW.chapter, NEW.verse);\n'
      'END',
    );

    await customStatement(
      'CREATE TRIGGER IF NOT EXISTS $deleteTrigger\n'
      'AFTER DELETE ON verses\n'
      "WHEN OLD.translation_id = '$escapedId'\n"
      'BEGIN\n'
      "  INSERT INTO $tableName($tableName, rowid, text, book_id, chapter, verse)\n"
      '  VALUES(\'delete\', OLD.rowid, OLD.verse_text, OLD.book_id, OLD.chapter, OLD.verse);\n'
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
      'INSERT INTO $tableName(rowid, text, book_id, chapter, verse) SELECT rowid, verse_text, book_id, chapter, verse FROM verses WHERE translation_id = ?',
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
