// GENERATED CODE - DO NOT MODIFY BY HAND
// This placeholder exists because build_runner could not be executed in the
// automated environment. Run `flutter pub run build_runner build` to generate
// the full implementation.

part of 'app_database.dart';

class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);

  late final TableInfo<Translations, dynamic> translations =
      throw UnimplementedError(
      'Run build_runner to generate table bindings for `translations`.');
  late final TableInfo<Verses, dynamic> verses = throw UnimplementedError(
      'Run build_runner to generate table bindings for `verses`.');
  late final TableInfo<Bookmarks, dynamic> bookmarks = throw UnimplementedError(
      'Run build_runner to generate table bindings for `bookmarks`.');
  late final TableInfo<Highlights, dynamic> highlights =
      throw UnimplementedError(
      'Run build_runner to generate table bindings for `highlights`.');
  late final TableInfo<Notes, dynamic> notes = throw UnimplementedError(
      'Run build_runner to generate table bindings for `notes`.');
  late final TableInfo<NoteRevisions, dynamic> noteRevisions =
      throw UnimplementedError(
      'Run build_runner to generate table bindings for `note_revisions`.');
  late final TableInfo<Lessons, dynamic> lessons = throw UnimplementedError(
      'Run build_runner to generate table bindings for `lessons`.');
  late final TableInfo<LessonObjectives, dynamic> lessonObjectives =
      throw UnimplementedError(
          'Run build_runner to generate table bindings for `lesson_objectives`.');
  late final TableInfo<LessonScriptures, dynamic> lessonScriptures =
      throw UnimplementedError(
          'Run build_runner to generate table bindings for `lesson_scriptures`.');
  late final TableInfo<LessonAttachments, dynamic> lessonAttachments =
      throw UnimplementedError(
          'Run build_runner to generate table bindings for `lesson_attachments`.');
  late final TableInfo<LessonQuizzes, dynamic> lessonQuizzes =
      throw UnimplementedError(
      'Run build_runner to generate table bindings for `lesson_quizzes`.');
  late final TableInfo<LessonQuizOptions, dynamic> lessonQuizOptions =
      throw UnimplementedError(
      'Run build_runner to generate table bindings for `lesson_quiz_options`.');
  late final TableInfo<LessonFeeds, dynamic> lessonFeeds =
      throw UnimplementedError(
      'Run build_runner to generate table bindings for `lesson_feeds`.');
  late final TableInfo<LessonSources, dynamic> lessonSources =
      throw UnimplementedError(
      'Run build_runner to generate table bindings for `lesson_sources`.');
  late final TableInfo<LessonDrafts, dynamic> lessonDrafts =
      throw UnimplementedError(
      'Run build_runner to generate table bindings for `lesson_drafts`.');
  late final TableInfo<RoundtableEvents, dynamic> roundtableEvents =
      throw UnimplementedError(
          'Run build_runner to generate table bindings for `roundtable_events`.');
  late final TableInfo<MeetingLinks, dynamic> meetingLinks =
      throw UnimplementedError(
      'Run build_runner to generate table bindings for `meeting_links`.');
  late final TableInfo<DiscussionThreads, dynamic> discussionThreads =
      throw UnimplementedError(
          'Run build_runner to generate table bindings for `discussion_threads`.');
  late final TableInfo<DiscussionPosts, dynamic> discussionPosts =
      throw UnimplementedError(
          'Run build_runner to generate table bindings for `discussion_posts`.');
  late final TableInfo<Progress, dynamic> progress = throw UnimplementedError(
      'Run build_runner to generate table bindings for `progress`.');
  late final TableInfo<LocalUsers, dynamic> localUsers = throw UnimplementedError(
      'Run build_runner to generate table bindings for `local_users`.');
  late final TableInfo<SyncQueue, dynamic> syncQueue = throw UnimplementedError(
      'Run build_runner to generate table bindings for `sync_queue`.');
  late final TableInfo<Messages, dynamic> messages = throw UnimplementedError(
      'Run build_runner to generate table bindings for `messages`.');
  late final TableInfo<TypingIndicators, dynamic> typingIndicators =
      throw UnimplementedError(
          'Run build_runner to generate table bindings for `typing_indicators`.');
  late final TableInfo<ModerationActionsTable, dynamic> moderationActionsTable =
      throw UnimplementedError(
          'Run build_runner to generate table bindings for `moderation_actions_table`.');
  late final TableInfo<ModerationAppealsTable, dynamic> moderationAppealsTable =
      throw UnimplementedError(
          'Run build_runner to generate table bindings for `moderation_appeals_table`.');
  late final TableInfo<NoteChangeTrackers, dynamic> noteChangeTrackers =
      throw UnimplementedError(
          'Run build_runner to generate table bindings for `note_change_trackers`.');
  late final TableInfo<ProgressChangeTrackers, dynamic> progressChangeTrackers =
      throw UnimplementedError(
          'Run build_runner to generate table bindings for `progress_change_trackers`.');
  late final TableInfo<MessageChangeTrackers, dynamic> messageChangeTrackers =
      throw UnimplementedError(
          'Run build_runner to generate table bindings for `message_change_trackers`.');

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      throw UnimplementedError('Run build_runner to generate table bindings.');

  @override
  int get schemaVersion => 11;
}

mixin _StubInsertable implements Insertable<dynamic> {
  @override
  Map<String, Expression<Object?>> toColumns(bool nullToAbsent) =>
      const <String, Expression<Object?>>{};
}

/// A lightweight stand-in for the generated [LocalUser] data class.
///
/// The real implementation is generated by `drift` via build_runner. In the
/// automated environment we ship a very small subset that is just enough for
/// the rest of the application code to compile. Any runtime usage will still
/// throw through the [UnimplementedError]s above, matching the rest of this
/// placeholder file.
class LocalUser {
  const LocalUser({
    required this.id,
    this.displayName,
    this.avatarUrl,
    this.preferredCohortId,
    this.preferredCohortTitle,
    this.preferredLessonClass,
    this.roles = '[]',
    this.isActive = false,
  });

  final String id;
  final String? displayName;
  final String? avatarUrl;
  final String? preferredCohortId;
  final String? preferredCohortTitle;
  final String? preferredLessonClass;
  final String roles;
  final bool isActive;

  LocalUser copyWith({
    String? id,
    String? displayName,
    String? avatarUrl,
    String? preferredCohortId,
    String? preferredCohortTitle,
    String? preferredLessonClass,
    String? roles,
    bool? isActive,
  }) {
    return LocalUser(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      preferredCohortId: preferredCohortId ?? this.preferredCohortId,
      preferredCohortTitle: preferredCohortTitle ?? this.preferredCohortTitle,
      preferredLessonClass: preferredLessonClass ?? this.preferredLessonClass,
      roles: roles ?? this.roles,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// Minimal companion used in place of the generated `LocalUsersCompanion`.
class LocalUsersCompanion with _StubInsertable {
  const LocalUsersCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.preferredCohortId = const Value.absent(),
    this.preferredCohortTitle = const Value.absent(),
    this.preferredLessonClass = const Value.absent(),
    this.roles = const Value.absent(),
    this.isActive = const Value.absent(),
  });

  LocalUsersCompanion.insert({
    required String id,
    Value<String?> displayName = const Value.absent(),
    Value<String?> avatarUrl = const Value.absent(),
    Value<String?> preferredCohortId = const Value.absent(),
    Value<String?> preferredCohortTitle = const Value.absent(),
    Value<String?> preferredLessonClass = const Value.absent(),
    Value<String> roles = const Value.absent(),
    Value<bool> isActive = const Value.absent(),
  })  : id = Value(id),
        displayName = displayName,
        avatarUrl = avatarUrl,
        preferredCohortId = preferredCohortId,
        preferredCohortTitle = preferredCohortTitle,
        preferredLessonClass = preferredLessonClass,
        roles = roles,
        isActive = isActive;

  final Value<String> id;
  final Value<String?> displayName;
  final Value<String?> avatarUrl;
  final Value<String?> preferredCohortId;
  final Value<String?> preferredCohortTitle;
  final Value<String?> preferredLessonClass;
  final Value<String> roles;
  final Value<bool> isActive;

  LocalUsersCompanion copyWith({
    Value<String>? id,
    Value<String?>? displayName,
    Value<String?>? avatarUrl,
    Value<String?>? preferredCohortId,
    Value<String?>? preferredCohortTitle,
    Value<String?>? preferredLessonClass,
    Value<String>? roles,
    Value<bool>? isActive,
  }) {
    return LocalUsersCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      preferredCohortId: preferredCohortId ?? this.preferredCohortId,
      preferredCohortTitle: preferredCohortTitle ?? this.preferredCohortTitle,
      preferredLessonClass: preferredLessonClass ?? this.preferredLessonClass,
      roles: roles ?? this.roles,
      isActive: isActive ?? this.isActive,
    );
  }
}

class LessonRow {
  const LessonRow({
    required this.id,
    required this.title,
    required this.lessonClass,
    this.ageMin,
    this.ageMax,
    this.objectives,
    this.scriptures,
    this.contentHtml,
    this.teacherNotes,
    this.attachments,
    this.quizzes,
    this.sourceUrl,
    this.lastFetchedAt,
    this.feedId,
    this.cohortId,
  });

  final String id;
  final String title;
  final String lessonClass;
  final int? ageMin;
  final int? ageMax;
  final String? objectives;
  final String? scriptures;
  final String? contentHtml;
  final String? teacherNotes;
  final String? attachments;
  final String? quizzes;
  final String? sourceUrl;
  final int? lastFetchedAt;
  final String? feedId;
  final String? cohortId;

  LessonRow copyWith({
    String? id,
    String? title,
    String? lessonClass,
    int? ageMin,
    int? ageMax,
    String? objectives,
    String? scriptures,
    String? contentHtml,
    String? teacherNotes,
    String? attachments,
    String? quizzes,
    String? sourceUrl,
    int? lastFetchedAt,
    String? feedId,
    String? cohortId,
  }) {
    return LessonRow(
      id: id ?? this.id,
      title: title ?? this.title,
      lessonClass: lessonClass ?? this.lessonClass,
      ageMin: ageMin ?? this.ageMin,
      ageMax: ageMax ?? this.ageMax,
      objectives: objectives ?? this.objectives,
      scriptures: scriptures ?? this.scriptures,
      contentHtml: contentHtml ?? this.contentHtml,
      teacherNotes: teacherNotes ?? this.teacherNotes,
      attachments: attachments ?? this.attachments,
      quizzes: quizzes ?? this.quizzes,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      lastFetchedAt: lastFetchedAt ?? this.lastFetchedAt,
      feedId: feedId ?? this.feedId,
      cohortId: cohortId ?? this.cohortId,
    );
  }
}

class LessonObjectiveRow {
  const LessonObjectiveRow({
    required this.lessonId,
    required this.position,
    required this.objective,
  });

  final String lessonId;
  final int position;
  final String objective;

  LessonObjectiveRow copyWith({
    String? lessonId,
    int? position,
    String? objective,
  }) {
    return LessonObjectiveRow(
      lessonId: lessonId ?? this.lessonId,
      position: position ?? this.position,
      objective: objective ?? this.objective,
    );
  }
}

class LessonScriptureRow {
  const LessonScriptureRow({
    required this.lessonId,
    required this.position,
    required this.reference,
    this.translationId,
  });

  final String lessonId;
  final int position;
  final String reference;
  final String? translationId;

  LessonScriptureRow copyWith({
    String? lessonId,
    int? position,
    String? reference,
    String? translationId,
  }) {
    return LessonScriptureRow(
      lessonId: lessonId ?? this.lessonId,
      position: position ?? this.position,
      reference: reference ?? this.reference,
      translationId: translationId ?? this.translationId,
    );
  }
}

class LessonAttachmentRow {
  const LessonAttachmentRow({
    required this.lessonId,
    required this.position,
    required this.type,
    this.title,
    required this.url,
    this.localPath,
    this.sizeBytes,
    this.downloadedAt,
  });

  final String lessonId;
  final int position;
  final String type;
  final String? title;
  final String url;
  final String? localPath;
  final int? sizeBytes;
  final int? downloadedAt;

  LessonAttachmentRow copyWith({
    String? lessonId,
    int? position,
    String? type,
    String? title,
    String? url,
    String? localPath,
    int? sizeBytes,
    int? downloadedAt,
  }) {
    return LessonAttachmentRow(
      lessonId: lessonId ?? this.lessonId,
      position: position ?? this.position,
      type: type ?? this.type,
      title: title ?? this.title,
      url: url ?? this.url,
      localPath: localPath ?? this.localPath,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      downloadedAt: downloadedAt ?? this.downloadedAt,
    );
  }
}

class LessonQuizRow {
  const LessonQuizRow({
    required this.id,
    required this.lessonId,
    required this.position,
    required this.type,
    required this.prompt,
    this.answer,
  });

  final String id;
  final String lessonId;
  final int position;
  final String type;
  final String prompt;
  final String? answer;

  LessonQuizRow copyWith({
    String? id,
    String? lessonId,
    int? position,
    String? type,
    String? prompt,
    String? answer,
  }) {
    return LessonQuizRow(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      position: position ?? this.position,
      type: type ?? this.type,
      prompt: prompt ?? this.prompt,
      answer: answer ?? this.answer,
    );
  }
}

class LessonQuizOptionRow {
  const LessonQuizOptionRow({
    required this.quizId,
    required this.position,
    required this.label,
    this.isCorrect = false,
  });

  final String quizId;
  final int position;
  final String label;
  final bool isCorrect;

  LessonQuizOptionRow copyWith({
    String? quizId,
    int? position,
    String? label,
    bool? isCorrect,
  }) {
    return LessonQuizOptionRow(
      quizId: quizId ?? this.quizId,
      position: position ?? this.position,
      label: label ?? this.label,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }
}

class ProgressData {
  const ProgressData({
    required this.id,
    required this.userId,
    required this.lessonId,
    required this.status,
    this.quizScore,
    this.timeSpentSeconds = 0,
    this.startedAt,
    this.completedAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final String lessonId;
  final String status;
  final double? quizScore;
  final int timeSpentSeconds;
  final int? startedAt;
  final int? completedAt;
  final int updatedAt;

  ProgressData copyWith({
    String? id,
    String? userId,
    String? lessonId,
    String? status,
    double? quizScore,
    int? timeSpentSeconds,
    int? startedAt,
    int? completedAt,
    int? updatedAt,
  }) {
    return ProgressData(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      lessonId: lessonId ?? this.lessonId,
      status: status ?? this.status,
      quizScore: quizScore ?? this.quizScore,
      timeSpentSeconds: timeSpentSeconds ?? this.timeSpentSeconds,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ProgressCompanion {
  const ProgressCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.status = const Value.absent(),
    this.quizScore = const Value.absent(),
    this.timeSpentSeconds = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });

  ProgressCompanion.insert({
    required String id,
    required String userId,
    required String lessonId,
    required String status,
    Value<double?> quizScore = const Value.absent(),
    Value<int> timeSpentSeconds = const Value.absent(),
    Value<int?> startedAt = const Value.absent(),
    Value<int?> completedAt = const Value.absent(),
    required int updatedAt,
  })  : id = Value(id),
        userId = Value(userId),
        lessonId = Value(lessonId),
        status = Value(status),
        quizScore = quizScore,
        timeSpentSeconds = timeSpentSeconds,
        startedAt = startedAt,
        completedAt = completedAt,
        updatedAt = Value(updatedAt);

  final Value<String> id;
  final Value<String> userId;
  final Value<String> lessonId;
  final Value<String> status;
  final Value<double?> quizScore;
  final Value<int> timeSpentSeconds;
  final Value<int?> startedAt;
  final Value<int?> completedAt;
  final Value<int> updatedAt;

  ProgressCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? lessonId,
    Value<String>? status,
    Value<double?>? quizScore,
    Value<int>? timeSpentSeconds,
    Value<int?>? startedAt,
    Value<int?>? completedAt,
    Value<int>? updatedAt,
  }) {
    return ProgressCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      lessonId: lessonId ?? this.lessonId,
      status: status ?? this.status,
      quizScore: quizScore ?? this.quizScore,
      timeSpentSeconds: timeSpentSeconds ?? this.timeSpentSeconds,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class BookmarksData {
  const BookmarksData({
    required this.id,
    required this.userId,
    required this.translationId,
    required this.bookId,
    required this.chapter,
    required this.verse,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String translationId;
  final int bookId;
  final int chapter;
  final int verse;
  final int createdAt;

  BookmarksData copyWith({
    String? id,
    String? userId,
    String? translationId,
    int? bookId,
    int? chapter,
    int? verse,
    int? createdAt,
  }) {
    return BookmarksData(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      translationId: translationId ?? this.translationId,
      bookId: bookId ?? this.bookId,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class BookmarksCompanion {
  const BookmarksCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.translationId = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapter = const Value.absent(),
    this.verse = const Value.absent(),
    this.createdAt = const Value.absent(),
  });

  BookmarksCompanion.insert({
    required String id,
    required String userId,
    required String translationId,
    required int bookId,
    required int chapter,
    required int verse,
    required int createdAt,
  })  : id = Value(id),
        userId = Value(userId),
        translationId = Value(translationId),
        bookId = Value(bookId),
        chapter = Value(chapter),
        verse = Value(verse),
        createdAt = Value(createdAt);

  final Value<String> id;
  final Value<String> userId;
  final Value<String> translationId;
  final Value<int> bookId;
  final Value<int> chapter;
  final Value<int> verse;
  final Value<int> createdAt;

  BookmarksCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? translationId,
    Value<int>? bookId,
    Value<int>? chapter,
    Value<int>? verse,
    Value<int>? createdAt,
  }) {
    return BookmarksCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      translationId: translationId ?? this.translationId,
      bookId: bookId ?? this.bookId,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class HighlightsData {
  const HighlightsData({
    required this.id,
    required this.userId,
    required this.translationId,
    required this.bookId,
    required this.chapter,
    required this.verse,
    required this.colour,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String translationId;
  final int bookId;
  final int chapter;
  final int verse;
  final String colour;
  final int createdAt;

  HighlightsData copyWith({
    String? id,
    String? userId,
    String? translationId,
    int? bookId,
    int? chapter,
    int? verse,
    String? colour,
    int? createdAt,
  }) {
    return HighlightsData(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      translationId: translationId ?? this.translationId,
      bookId: bookId ?? this.bookId,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      colour: colour ?? this.colour,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class HighlightsCompanion {
  const HighlightsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.translationId = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapter = const Value.absent(),
    this.verse = const Value.absent(),
    this.colour = const Value.absent(),
    this.createdAt = const Value.absent(),
  });

  HighlightsCompanion.insert({
    required String id,
    required String userId,
    required String translationId,
    required int bookId,
    required int chapter,
    required int verse,
    required String colour,
    required int createdAt,
  })  : id = Value(id),
        userId = Value(userId),
        translationId = Value(translationId),
        bookId = Value(bookId),
        chapter = Value(chapter),
        verse = Value(verse),
        colour = Value(colour),
        createdAt = Value(createdAt);

  final Value<String> id;
  final Value<String> userId;
  final Value<String> translationId;
  final Value<int> bookId;
  final Value<int> chapter;
  final Value<int> verse;
  final Value<String> colour;
  final Value<int> createdAt;

  HighlightsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? translationId,
    Value<int>? bookId,
    Value<int>? chapter,
    Value<int>? verse,
    Value<String>? colour,
    Value<int>? createdAt,
  }) {
    return HighlightsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      translationId: translationId ?? this.translationId,
      bookId: bookId ?? this.bookId,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      colour: colour ?? this.colour,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class LessonSourceRow {
  const LessonSourceRow({
    required this.id,
    required this.type,
    required this.location,
    this.label,
    this.cohort,
    this.lessonClass,
    this.enabled = true,
    this.isBundled = false,
    this.priority = 0,
    this.checksum,
    this.etag,
    this.lastModified,
    this.lastSyncedAt,
    this.lastAttemptedAt,
    this.lastCheckedAt,
    this.lastError,
    this.lessonCount = 0,
    this.attachmentBytes = 0,
    this.quotaBytes,
  });

  final String id;
  final String type;
  final String location;
  final String? label;
  final String? cohort;
  final String? lessonClass;
  final bool enabled;
  final bool isBundled;
  final int priority;
  final String? checksum;
  final String? etag;
  final int? lastModified;
  final int? lastSyncedAt;
  final int? lastAttemptedAt;
  final int? lastCheckedAt;
  final String? lastError;
  final int lessonCount;
  final int attachmentBytes;
  final int? quotaBytes;

  LessonSourceRow copyWith({
    String? id,
    String? type,
    String? location,
    String? label,
    String? cohort,
    String? lessonClass,
    bool? enabled,
    bool? isBundled,
    int? priority,
    String? checksum,
    String? etag,
    int? lastModified,
    int? lastSyncedAt,
    int? lastAttemptedAt,
    int? lastCheckedAt,
    String? lastError,
    int? lessonCount,
    int? attachmentBytes,
    int? quotaBytes,
  }) {
    return LessonSourceRow(
      id: id ?? this.id,
      type: type ?? this.type,
      location: location ?? this.location,
      label: label ?? this.label,
      cohort: cohort ?? this.cohort,
      lessonClass: lessonClass ?? this.lessonClass,
      enabled: enabled ?? this.enabled,
      isBundled: isBundled ?? this.isBundled,
      priority: priority ?? this.priority,
      checksum: checksum ?? this.checksum,
      etag: etag ?? this.etag,
      lastModified: lastModified ?? this.lastModified,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      lastAttemptedAt: lastAttemptedAt ?? this.lastAttemptedAt,
      lastCheckedAt: lastCheckedAt ?? this.lastCheckedAt,
      lastError: lastError ?? this.lastError,
      lessonCount: lessonCount ?? this.lessonCount,
      attachmentBytes: attachmentBytes ?? this.attachmentBytes,
      quotaBytes: quotaBytes ?? this.quotaBytes,
    );
  }
}

class LessonSourcesCompanion with _StubInsertable {
  const LessonSourcesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.location = const Value.absent(),
    this.label = const Value.absent(),
    this.cohort = const Value.absent(),
    this.lessonClass = const Value.absent(),
    this.enabled = const Value.absent(),
    this.isBundled = const Value.absent(),
    this.priority = const Value.absent(),
    this.checksum = const Value.absent(),
    this.etag = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.lastAttemptedAt = const Value.absent(),
    this.lastCheckedAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.lessonCount = const Value.absent(),
    this.attachmentBytes = const Value.absent(),
    this.quotaBytes = const Value.absent(),
  });

  LessonSourcesCompanion.insert({
    required String id,
    required String type,
    required String location,
    Value<String?> label = const Value.absent(),
    Value<String?> cohort = const Value.absent(),
    Value<String?> lessonClass = const Value.absent(),
    Value<bool> enabled = const Value.absent(),
    Value<bool> isBundled = const Value.absent(),
    Value<int> priority = const Value.absent(),
    Value<String?> checksum = const Value.absent(),
    Value<String?> etag = const Value.absent(),
    Value<int?> lastModified = const Value.absent(),
    Value<int?> lastSyncedAt = const Value.absent(),
    Value<int?> lastAttemptedAt = const Value.absent(),
    Value<int?> lastCheckedAt = const Value.absent(),
    Value<String?> lastError = const Value.absent(),
    Value<int> lessonCount = const Value.absent(),
    Value<int> attachmentBytes = const Value.absent(),
    Value<int?> quotaBytes = const Value.absent(),
  })  : id = Value(id),
        type = Value(type),
        location = Value(location),
        label = label,
        cohort = cohort,
        lessonClass = lessonClass,
        enabled = enabled,
        isBundled = isBundled,
        priority = priority,
        checksum = checksum,
        etag = etag,
        lastModified = lastModified,
        lastSyncedAt = lastSyncedAt,
        lastAttemptedAt = lastAttemptedAt,
        lastCheckedAt = lastCheckedAt,
        lastError = lastError,
        lessonCount = lessonCount,
        attachmentBytes = attachmentBytes,
        quotaBytes = quotaBytes;

  final Value<String> id;
  final Value<String> type;
  final Value<String> location;
  final Value<String?> label;
  final Value<String?> cohort;
  final Value<String?> lessonClass;
  final Value<bool> enabled;
  final Value<bool> isBundled;
  final Value<int> priority;
  final Value<String?> checksum;
  final Value<String?> etag;
  final Value<int?> lastModified;
  final Value<int?> lastSyncedAt;
  final Value<int?> lastAttemptedAt;
  final Value<int?> lastCheckedAt;
  final Value<String?> lastError;
  final Value<int> lessonCount;
  final Value<int> attachmentBytes;
  final Value<int?> quotaBytes;

  LessonSourcesCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<String>? location,
    Value<String?>? label,
    Value<String?>? cohort,
    Value<String?>? lessonClass,
    Value<bool>? enabled,
    Value<bool>? isBundled,
    Value<int>? priority,
    Value<String?>? checksum,
    Value<String?>? etag,
    Value<int?>? lastModified,
    Value<int?>? lastSyncedAt,
    Value<int?>? lastAttemptedAt,
    Value<int?>? lastCheckedAt,
    Value<String?>? lastError,
    Value<int>? lessonCount,
    Value<int>? attachmentBytes,
    Value<int?>? quotaBytes,
  }) {
    return LessonSourcesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      location: location ?? this.location,
      label: label ?? this.label,
      cohort: cohort ?? this.cohort,
      lessonClass: lessonClass ?? this.lessonClass,
      enabled: enabled ?? this.enabled,
      isBundled: isBundled ?? this.isBundled,
      priority: priority ?? this.priority,
      checksum: checksum ?? this.checksum,
      etag: etag ?? this.etag,
      lastModified: lastModified ?? this.lastModified,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      lastAttemptedAt: lastAttemptedAt ?? this.lastAttemptedAt,
      lastCheckedAt: lastCheckedAt ?? this.lastCheckedAt,
      lastError: lastError ?? this.lastError,
      lessonCount: lessonCount ?? this.lessonCount,
      attachmentBytes: attachmentBytes ?? this.attachmentBytes,
      quotaBytes: quotaBytes ?? this.quotaBytes,
    );
  }
}

class LessonsCompanion with _StubInsertable {
  const LessonsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.lessonClass = const Value.absent(),
    this.ageMin = const Value.absent(),
    this.ageMax = const Value.absent(),
    this.objectives = const Value.absent(),
    this.scriptures = const Value.absent(),
    this.contentHtml = const Value.absent(),
    this.teacherNotes = const Value.absent(),
    this.attachments = const Value.absent(),
    this.quizzes = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.lastFetchedAt = const Value.absent(),
    this.feedId = const Value.absent(),
    this.cohortId = const Value.absent(),
  });

  LessonsCompanion.insert({
    required String id,
    required String title,
    required String lessonClass,
    Value<int?> ageMin = const Value.absent(),
    Value<int?> ageMax = const Value.absent(),
    Value<String?> objectives = const Value.absent(),
    Value<String?> scriptures = const Value.absent(),
    Value<String?> contentHtml = const Value.absent(),
    Value<String?> teacherNotes = const Value.absent(),
    Value<String?> attachments = const Value.absent(),
    Value<String?> quizzes = const Value.absent(),
    Value<String?> sourceUrl = const Value.absent(),
    Value<int?> lastFetchedAt = const Value.absent(),
    Value<String?> feedId = const Value.absent(),
    Value<String?> cohortId = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        lessonClass = Value(lessonClass),
        ageMin = ageMin,
        ageMax = ageMax,
        objectives = objectives,
        scriptures = scriptures,
        contentHtml = contentHtml,
        teacherNotes = teacherNotes,
        attachments = attachments,
        quizzes = quizzes,
        sourceUrl = sourceUrl,
        lastFetchedAt = lastFetchedAt,
        feedId = feedId,
        cohortId = cohortId;

  final Value<String> id;
  final Value<String> title;
  final Value<String> lessonClass;
  final Value<int?> ageMin;
  final Value<int?> ageMax;
  final Value<String?> objectives;
  final Value<String?> scriptures;
  final Value<String?> contentHtml;
  final Value<String?> teacherNotes;
  final Value<String?> attachments;
  final Value<String?> quizzes;
  final Value<String?> sourceUrl;
  final Value<int?> lastFetchedAt;
  final Value<String?> feedId;
  final Value<String?> cohortId;

  LessonsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? lessonClass,
    Value<int?>? ageMin,
    Value<int?>? ageMax,
    Value<String?>? objectives,
    Value<String?>? scriptures,
    Value<String?>? contentHtml,
    Value<String?>? teacherNotes,
    Value<String?>? attachments,
    Value<String?>? quizzes,
    Value<String?>? sourceUrl,
    Value<int?>? lastFetchedAt,
    Value<String?>? feedId,
    Value<String?>? cohortId,
  }) {
    return LessonsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      lessonClass: lessonClass ?? this.lessonClass,
      ageMin: ageMin ?? this.ageMin,
      ageMax: ageMax ?? this.ageMax,
      objectives: objectives ?? this.objectives,
      scriptures: scriptures ?? this.scriptures,
      contentHtml: contentHtml ?? this.contentHtml,
      teacherNotes: teacherNotes ?? this.teacherNotes,
      attachments: attachments ?? this.attachments,
      quizzes: quizzes ?? this.quizzes,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      lastFetchedAt: lastFetchedAt ?? this.lastFetchedAt,
      feedId: feedId ?? this.feedId,
      cohortId: cohortId ?? this.cohortId,
    );
  }
}

class LessonObjectivesCompanion with _StubInsertable {
  const LessonObjectivesCompanion({
    this.lessonId = const Value.absent(),
    this.position = const Value.absent(),
    this.objective = const Value.absent(),
  });

  LessonObjectivesCompanion.insert({
    required String lessonId,
    required int position,
    required String objective,
  })  : lessonId = Value(lessonId),
        position = Value(position),
        objective = Value(objective);

  final Value<String> lessonId;
  final Value<int> position;
  final Value<String> objective;

  LessonObjectivesCompanion copyWith({
    Value<String>? lessonId,
    Value<int>? position,
    Value<String>? objective,
  }) {
    return LessonObjectivesCompanion(
      lessonId: lessonId ?? this.lessonId,
      position: position ?? this.position,
      objective: objective ?? this.objective,
    );
  }
}

class LessonScripturesCompanion with _StubInsertable {
  const LessonScripturesCompanion({
    this.lessonId = const Value.absent(),
    this.position = const Value.absent(),
    this.reference = const Value.absent(),
    this.translationId = const Value.absent(),
  });

  LessonScripturesCompanion.insert({
    required String lessonId,
    required int position,
    required String reference,
    Value<String?> translationId = const Value.absent(),
  })  : lessonId = Value(lessonId),
        position = Value(position),
        reference = Value(reference),
        translationId = translationId;

  final Value<String> lessonId;
  final Value<int> position;
  final Value<String> reference;
  final Value<String?> translationId;

  LessonScripturesCompanion copyWith({
    Value<String>? lessonId,
    Value<int>? position,
    Value<String>? reference,
    Value<String?>? translationId,
  }) {
    return LessonScripturesCompanion(
      lessonId: lessonId ?? this.lessonId,
      position: position ?? this.position,
      reference: reference ?? this.reference,
      translationId: translationId ?? this.translationId,
    );
  }
}

class LessonAttachmentsCompanion with _StubInsertable {
  const LessonAttachmentsCompanion({
    this.lessonId = const Value.absent(),
    this.position = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.url = const Value.absent(),
    this.localPath = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.downloadedAt = const Value.absent(),
  });

  LessonAttachmentsCompanion.insert({
    required String lessonId,
    required int position,
    required String type,
    Value<String?> title = const Value.absent(),
    required String url,
    Value<String?> localPath = const Value.absent(),
    Value<int?> sizeBytes = const Value.absent(),
    Value<int?> downloadedAt = const Value.absent(),
  })  : lessonId = Value(lessonId),
        position = Value(position),
        type = Value(type),
        title = title,
        url = Value(url),
        localPath = localPath,
        sizeBytes = sizeBytes,
        downloadedAt = downloadedAt;

  final Value<String> lessonId;
  final Value<int> position;
  final Value<String> type;
  final Value<String?> title;
  final Value<String> url;
  final Value<String?> localPath;
  final Value<int?> sizeBytes;
  final Value<int?> downloadedAt;

  LessonAttachmentsCompanion copyWith({
    Value<String>? lessonId,
    Value<int>? position,
    Value<String>? type,
    Value<String?>? title,
    Value<String>? url,
    Value<String?>? localPath,
    Value<int?>? sizeBytes,
    Value<int?>? downloadedAt,
  }) {
    return LessonAttachmentsCompanion(
      lessonId: lessonId ?? this.lessonId,
      position: position ?? this.position,
      type: type ?? this.type,
      title: title ?? this.title,
      url: url ?? this.url,
      localPath: localPath ?? this.localPath,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      downloadedAt: downloadedAt ?? this.downloadedAt,
    );
  }
}

class LessonQuizzesCompanion with _StubInsertable {
  const LessonQuizzesCompanion({
    this.id = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.position = const Value.absent(),
    this.type = const Value.absent(),
    this.prompt = const Value.absent(),
    this.answer = const Value.absent(),
  });

  LessonQuizzesCompanion.insert({
    required String id,
    required String lessonId,
    required int position,
    required String type,
    required String prompt,
    Value<String?> answer = const Value.absent(),
  })  : id = Value(id),
        lessonId = Value(lessonId),
        position = Value(position),
        type = Value(type),
        prompt = Value(prompt),
        answer = answer;

  final Value<String> id;
  final Value<String> lessonId;
  final Value<int> position;
  final Value<String> type;
  final Value<String> prompt;
  final Value<String?> answer;

  LessonQuizzesCompanion copyWith({
    Value<String>? id,
    Value<String>? lessonId,
    Value<int>? position,
    Value<String>? type,
    Value<String>? prompt,
    Value<String?>? answer,
  }) {
    return LessonQuizzesCompanion(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      position: position ?? this.position,
      type: type ?? this.type,
      prompt: prompt ?? this.prompt,
      answer: answer ?? this.answer,
    );
  }
}

class LessonQuizOptionsCompanion with _StubInsertable {
  const LessonQuizOptionsCompanion({
    this.quizId = const Value.absent(),
    this.position = const Value.absent(),
    this.label = const Value.absent(),
    this.isCorrect = const Value.absent(),
  });

  LessonQuizOptionsCompanion.insert({
    required String quizId,
    required int position,
    required String label,
    Value<bool> isCorrect = const Value.absent(),
  })  : quizId = Value(quizId),
        position = Value(position),
        label = Value(label),
        isCorrect = isCorrect;

  final Value<String> quizId;
  final Value<int> position;
  final Value<String> label;
  final Value<bool> isCorrect;

  LessonQuizOptionsCompanion copyWith({
    Value<String>? quizId,
    Value<int>? position,
    Value<String>? label,
    Value<bool>? isCorrect,
  }) {
    return LessonQuizOptionsCompanion(
      quizId: quizId ?? this.quizId,
      position: position ?? this.position,
      label: label ?? this.label,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }
}

class LessonFeedsCompanion with _StubInsertable {
  const LessonFeedsCompanion({
    this.id = const Value.absent(),
    this.source = const Value.absent(),
    this.cohort = const Value.absent(),
    this.lessonClass = const Value.absent(),
    this.checksum = const Value.absent(),
    this.etag = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.lastFetchedAt = const Value.absent(),
    this.lastCheckedAt = const Value.absent(),
  });

  LessonFeedsCompanion.insert({
    required String id,
    required String source,
    Value<String?> cohort = const Value.absent(),
    Value<String?> lessonClass = const Value.absent(),
    Value<String?> checksum = const Value.absent(),
    Value<String?> etag = const Value.absent(),
    Value<int?> lastModified = const Value.absent(),
    Value<int?> lastFetchedAt = const Value.absent(),
    Value<int?> lastCheckedAt = const Value.absent(),
  })  : id = Value(id),
        source = Value(source),
        cohort = cohort,
        lessonClass = lessonClass,
        checksum = checksum,
        etag = etag,
        lastModified = lastModified,
        lastFetchedAt = lastFetchedAt,
        lastCheckedAt = lastCheckedAt;

  final Value<String> id;
  final Value<String> source;
  final Value<String?> cohort;
  final Value<String?> lessonClass;
  final Value<String?> checksum;
  final Value<String?> etag;
  final Value<int?> lastModified;
  final Value<int?> lastFetchedAt;
  final Value<int?> lastCheckedAt;

  LessonFeedsCompanion copyWith({
    Value<String>? id,
    Value<String>? source,
    Value<String?>? cohort,
    Value<String?>? lessonClass,
    Value<String?>? checksum,
    Value<String?>? etag,
    Value<int?>? lastModified,
    Value<int?>? lastFetchedAt,
    Value<int?>? lastCheckedAt,
  }) {
    return LessonFeedsCompanion(
      id: id ?? this.id,
      source: source ?? this.source,
      cohort: cohort ?? this.cohort,
      lessonClass: lessonClass ?? this.lessonClass,
      checksum: checksum ?? this.checksum,
      etag: etag ?? this.etag,
      lastModified: lastModified ?? this.lastModified,
      lastFetchedAt: lastFetchedAt ?? this.lastFetchedAt,
      lastCheckedAt: lastCheckedAt ?? this.lastCheckedAt,
    );
  }
}

class NotesData {
  const NotesData({
    required this.id,
    required this.userId,
    required this.translationId,
    required this.bookId,
    required this.chapter,
    required this.verse,
    required this.text,
    required this.version,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final String translationId;
  final int bookId;
  final int chapter;
  final int verse;
  final String text;
  final int version;
  final int updatedAt;

  NotesData copyWith({
    String? id,
    String? userId,
    String? translationId,
    int? bookId,
    int? chapter,
    int? verse,
    String? text,
    int? version,
    int? updatedAt,
  }) {
    return NotesData(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      translationId: translationId ?? this.translationId,
      bookId: bookId ?? this.bookId,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      text: text ?? this.text,
      version: version ?? this.version,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class NotesCompanion {
  const NotesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.translationId = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapter = const Value.absent(),
    this.verse = const Value.absent(),
    this.text = const Value.absent(),
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });

  NotesCompanion.insert({
    required String id,
    required String userId,
    required String translationId,
    required int bookId,
    required int chapter,
    required int verse,
    required String text,
    required int version,
    required int updatedAt,
  })  : id = Value(id),
        userId = Value(userId),
        translationId = Value(translationId),
        bookId = Value(bookId),
        chapter = Value(chapter),
        verse = Value(verse),
        text = Value(text),
        version = Value(version),
        updatedAt = Value(updatedAt);

  final Value<String> id;
  final Value<String> userId;
  final Value<String> translationId;
  final Value<int> bookId;
  final Value<int> chapter;
  final Value<int> verse;
  final Value<String> text;
  final Value<int> version;
  final Value<int> updatedAt;

  NotesCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? translationId,
    Value<int>? bookId,
    Value<int>? chapter,
    Value<int>? verse,
    Value<String>? text,
    Value<int>? version,
    Value<int>? updatedAt,
  }) {
    return NotesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      translationId: translationId ?? this.translationId,
      bookId: bookId ?? this.bookId,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      text: text ?? this.text,
      version: version ?? this.version,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class NoteRevisionsData {
  const NoteRevisionsData({
    required this.noteId,
    required this.version,
    required this.text,
    required this.updatedAt,
  });

  final String noteId;
  final int version;
  final String text;
  final int updatedAt;

  NoteRevisionsData copyWith({
    String? noteId,
    int? version,
    String? text,
    int? updatedAt,
  }) {
    return NoteRevisionsData(
      noteId: noteId ?? this.noteId,
      version: version ?? this.version,
      text: text ?? this.text,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class NoteRevisionsCompanion {
  const NoteRevisionsCompanion({
    this.noteId = const Value.absent(),
    this.version = const Value.absent(),
    this.text = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });

  NoteRevisionsCompanion.insert({
    required String noteId,
    required int version,
    required String text,
    required int updatedAt,
  })  : noteId = Value(noteId),
        version = Value(version),
        text = Value(text),
        updatedAt = Value(updatedAt);

  final Value<String> noteId;
  final Value<int> version;
  final Value<String> text;
  final Value<int> updatedAt;

  NoteRevisionsCompanion copyWith({
    Value<String>? noteId,
    Value<int>? version,
    Value<String>? text,
    Value<int>? updatedAt,
  }) {
    return NoteRevisionsCompanion(
      noteId: noteId ?? this.noteId,
      version: version ?? this.version,
      text: text ?? this.text,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class Message {
  const Message({
    required this.id,
    required this.classId,
    required this.userId,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
    this.deleted = false,
    this.flagged = false,
    this.attachments = '[]',
    this.authorName,
  });

  final String id;
  final String classId;
  final String userId;
  final String body;
  final int createdAt;
  final int updatedAt;
  final bool deleted;
  final bool flagged;
  final String attachments;
  final String? authorName;
}

class MessagesCompanion {
  const MessagesCompanion({
    this.id = const Value.absent(),
    this.classId = const Value.absent(),
    this.userId = const Value.absent(),
    this.body = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.flagged = const Value.absent(),
    this.attachments = const Value.absent(),
    this.authorName = const Value.absent(),
  });

  const MessagesCompanion.insert({
    required String id,
    required String classId,
    required String userId,
    required String body,
    required int createdAt,
    required int updatedAt,
    Value<bool> deleted = const Value(false),
    Value<bool> flagged = const Value(false),
    Value<String> attachments = const Value('[]'),
    Value<String?> authorName = const Value.absent(),
  })  : id = Value(id),
        classId = Value(classId),
        userId = Value(userId),
        body = Value(body),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        deleted = deleted,
        flagged = flagged,
        attachments = attachments,
        authorName = authorName;

  final Value<String> id;
  final Value<String> classId;
  final Value<String> userId;
  final Value<String> body;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<bool> flagged;
  final Value<String> attachments;
  final Value<String?> authorName;

  MessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? classId,
    Value<String>? userId,
    Value<String>? body,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<bool>? deleted,
    Value<bool>? flagged,
    Value<String>? attachments,
    Value<String?>? authorName,
  }) {
    return MessagesCompanion(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      userId: userId ?? this.userId,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      flagged: flagged ?? this.flagged,
      attachments: attachments ?? this.attachments,
      authorName: authorName ?? this.authorName,
    );
  }
}

class TypingIndicatorRow {
  const TypingIndicatorRow({
    required this.classId,
    required this.userId,
    required this.isTyping,
    required this.updatedAt,
  });

  final String classId;
  final String userId;
  final bool isTyping;
  final int updatedAt;
}

class TypingIndicatorsCompanion {
  const TypingIndicatorsCompanion({
    this.classId = const Value.absent(),
    this.userId = const Value.absent(),
    this.isTyping = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });

  final Value<String> classId;
  final Value<String> userId;
  final Value<bool> isTyping;
  final Value<int> updatedAt;
}

class ModerationActionRow {
  const ModerationActionRow({
    required this.id,
    required this.classId,
    required this.targetUserId,
    required this.moderatorId,
    required this.type,
    required this.status,
    this.reason,
    required this.metadata,
    required this.createdAt,
    this.expiresAt,
  });

  final String id;
  final String classId;
  final String targetUserId;
  final String moderatorId;
  final String type;
  final String status;
  final String? reason;
  final String metadata;
  final int createdAt;
  final int? expiresAt;
}

class ModerationActionsTableCompanion {
  const ModerationActionsTableCompanion({
    this.id = const Value.absent(),
    this.classId = const Value.absent(),
    this.targetUserId = const Value.absent(),
    this.moderatorId = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.reason = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
  });

  final Value<String> id;
  final Value<String> classId;
  final Value<String> targetUserId;
  final Value<String> moderatorId;
  final Value<String> type;
  final Value<String> status;
  final Value<String?> reason;
  final Value<String> metadata;
  final Value<int> createdAt;
  final Value<int?> expiresAt;
}

class ModerationAppealRow {
  const ModerationAppealRow({
    required this.id,
    required this.actionId,
    required this.classId,
    required this.userId,
    required this.message,
    required this.status,
    this.resolutionNotes,
    required this.createdAt,
    this.resolvedAt,
  });

  final String id;
  final String actionId;
  final String classId;
  final String userId;
  final String message;
  final String status;
  final String? resolutionNotes;
  final int createdAt;
  final int? resolvedAt;
}

class ModerationAppealsTableCompanion {
  const ModerationAppealsTableCompanion({
    this.id = const Value.absent(),
    this.actionId = const Value.absent(),
    this.classId = const Value.absent(),
    this.userId = const Value.absent(),
    this.message = const Value.absent(),
    this.status = const Value.absent(),
    this.resolutionNotes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.resolvedAt = const Value.absent(),
  });

  final Value<String> id;
  final Value<String> actionId;
  final Value<String> classId;
  final Value<String> userId;
  final Value<String> message;
  final Value<String> status;
  final Value<String?> resolutionNotes;
  final Value<int> createdAt;
  final Value<int?> resolvedAt;
}

class RoundtableRow {
  const RoundtableRow({
    required this.id,
    required this.title,
    this.description,
    this.classId,
    required this.startTime,
    required this.endTime,
    this.conferencingUrl,
    this.hostConferencingUrl,
    this.meetingRoom,
    required this.reminderMinutesBefore,
    required this.createdBy,
    required this.updatedAt,
    this.recordingStoragePath,
    this.recordingUrl,
    this.recordingIndexedAt,
  });

  final String id;
  final String title;
  final String? description;
  final String? classId;
  final int startTime;
  final int endTime;
  final String? conferencingUrl;
  final String? hostConferencingUrl;
  final String? meetingRoom;
  final int reminderMinutesBefore;
  final String createdBy;
  final int updatedAt;
  final String? recordingStoragePath;
  final String? recordingUrl;
  final int? recordingIndexedAt;
}

class RoundtableEventsCompanion {
  const RoundtableEventsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.classId = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.conferencingUrl = const Value.absent(),
    this.hostConferencingUrl = const Value.absent(),
    this.meetingRoom = const Value.absent(),
    this.reminderMinutesBefore = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.recordingStoragePath = const Value.absent(),
    this.recordingUrl = const Value.absent(),
    this.recordingIndexedAt = const Value.absent(),
  });

  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> classId;
  final Value<int> startTime;
  final Value<int> endTime;
  final Value<String?> conferencingUrl;
  final Value<String?> hostConferencingUrl;
  final Value<String?> meetingRoom;
  final Value<int> reminderMinutesBefore;
  final Value<String> createdBy;
  final Value<int> updatedAt;
  final Value<String?> recordingStoragePath;
  final Value<String?> recordingUrl;
  final Value<int?> recordingIndexedAt;
}

class MeetingLinkRow {
  const MeetingLinkRow({
    required this.id,
    required this.contextType,
    required this.contextId,
    required this.roomName,
    required this.role,
    required this.url,
    required this.title,
    required this.createdAt,
    this.scheduledStart,
    this.reminderAt,
    required this.reminderScheduled,
    this.recordingStoragePath,
    this.recordingUrl,
    this.recordingIndexedAt,
  });

  final String id;
  final String contextType;
  final String contextId;
  final String roomName;
  final String role;
  final String url;
  final String title;
  final int createdAt;
  final int? scheduledStart;
  final int? reminderAt;
  final bool reminderScheduled;
  final String? recordingStoragePath;
  final String? recordingUrl;
  final int? recordingIndexedAt;
}

class MeetingLinksCompanion {
  const MeetingLinksCompanion({
    this.id = const Value.absent(),
    this.contextType = const Value.absent(),
    this.contextId = const Value.absent(),
    this.roomName = const Value.absent(),
    this.role = const Value.absent(),
    this.url = const Value.absent(),
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.scheduledStart = const Value.absent(),
    this.reminderAt = const Value.absent(),
    this.reminderScheduled = const Value.absent(),
    this.recordingStoragePath = const Value.absent(),
    this.recordingUrl = const Value.absent(),
    this.recordingIndexedAt = const Value.absent(),
  });

  final Value<String> id;
  final Value<String> contextType;
  final Value<String> contextId;
  final Value<String> roomName;
  final Value<String> role;
  final Value<String> url;
  final Value<String> title;
  final Value<int> createdAt;
  final Value<int?> scheduledStart;
  final Value<int?> reminderAt;
  final Value<bool> reminderScheduled;
  final Value<String?> recordingStoragePath;
  final Value<String?> recordingUrl;
  final Value<int?> recordingIndexedAt;
}
