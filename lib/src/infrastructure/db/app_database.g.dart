// GENERATED CODE - DO NOT MODIFY BY HAND
// This placeholder exists because build_runner could not be executed in the
// automated environment. Run `flutter pub run build_runner build` to generate
// the full implementation.

part of 'app_database.dart';

class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);

  late final TableInfo<Table, dynamic> translations = throw UnimplementedError(
      'Run build_runner to generate table bindings for `translations`.');
  late final TableInfo<Table, dynamic> verses = throw UnimplementedError(
      'Run build_runner to generate table bindings for `verses`.');
  late final TableInfo<Table, dynamic> bookmarks = throw UnimplementedError(
      'Run build_runner to generate table bindings for `bookmarks`.');
  late final TableInfo<Table, dynamic> highlights = throw UnimplementedError(
      'Run build_runner to generate table bindings for `highlights`.');
  late final TableInfo<Table, dynamic> notes = throw UnimplementedError(
      'Run build_runner to generate table bindings for `notes`.');
  late final TableInfo<Table, dynamic> noteRevisions = throw UnimplementedError(
      'Run build_runner to generate table bindings for `note_revisions`.');
  late final TableInfo<Table, dynamic> lessons = throw UnimplementedError(
      'Run build_runner to generate table bindings for `lessons`.');
  late final TableInfo<Table, dynamic> lessonObjectives =
      throw UnimplementedError(
          'Run build_runner to generate table bindings for `lesson_objectives`.');
  late final TableInfo<Table, dynamic> lessonScriptures =
      throw UnimplementedError(
          'Run build_runner to generate table bindings for `lesson_scriptures`.');
  late final TableInfo<Table, dynamic> lessonAttachments =
      throw UnimplementedError(
          'Run build_runner to generate table bindings for `lesson_attachments`.');
  late final TableInfo<Table, dynamic> lessonQuizzes = throw UnimplementedError(
      'Run build_runner to generate table bindings for `lesson_quizzes`.');
  late final TableInfo<Table, dynamic> lessonQuizOptions = throw UnimplementedError(
      'Run build_runner to generate table bindings for `lesson_quiz_options`.');
  late final TableInfo<Table, dynamic> lessonFeeds = throw UnimplementedError(
      'Run build_runner to generate table bindings for `lesson_feeds`.');
  late final TableInfo<Table, dynamic> lessonSources = throw UnimplementedError(
      'Run build_runner to generate table bindings for `lesson_sources`.');
  late final TableInfo<Table, dynamic> lessonDrafts = throw UnimplementedError(
      'Run build_runner to generate table bindings for `lesson_drafts`.');
  late final TableInfo<Table, dynamic> roundtableEvents =
      throw UnimplementedError(
          'Run build_runner to generate table bindings for `roundtable_events`.');
  late final TableInfo<Table, dynamic> meetingLinks = throw UnimplementedError(
      'Run build_runner to generate table bindings for `meeting_links`.');
  late final TableInfo<Table, dynamic> discussionThreads =
      throw UnimplementedError(
          'Run build_runner to generate table bindings for `discussion_threads`.');
  late final TableInfo<Table, dynamic> discussionPosts =
      throw UnimplementedError(
          'Run build_runner to generate table bindings for `discussion_posts`.');
  late final TableInfo<Table, dynamic> progress = throw UnimplementedError(
      'Run build_runner to generate table bindings for `progress`.');
  late final TableInfo<Table, dynamic> localUsers = throw UnimplementedError(
      'Run build_runner to generate table bindings for `local_users`.');
  late final TableInfo<Table, dynamic> syncQueue = throw UnimplementedError(
      'Run build_runner to generate table bindings for `sync_queue`.');
  late final TableInfo<Table, dynamic> messages = throw UnimplementedError(
      'Run build_runner to generate table bindings for `messages`.');
  late final TableInfo<Table, dynamic> typingIndicators =
      throw UnimplementedError(
          'Run build_runner to generate table bindings for `typing_indicators`.');
  late final TableInfo<Table, dynamic> moderationActionsTable =
      throw UnimplementedError(
          'Run build_runner to generate table bindings for `moderation_actions_table`.');
  late final TableInfo<Table, dynamic> moderationAppealsTable =
      throw UnimplementedError(
          'Run build_runner to generate table bindings for `moderation_appeals_table`.');
  late final TableInfo<Table, dynamic> noteChangeTrackers =
      throw UnimplementedError(
          'Run build_runner to generate table bindings for `note_change_trackers`.');
  late final TableInfo<Table, dynamic> progressChangeTrackers =
      throw UnimplementedError(
          'Run build_runner to generate table bindings for `progress_change_trackers`.');
  late final TableInfo<Table, dynamic> messageChangeTrackers =
      throw UnimplementedError(
          'Run build_runner to generate table bindings for `message_change_trackers`.');

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      throw UnimplementedError('Run build_runner to generate table bindings.');

  @override
  int get schemaVersion => 11;
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
class LocalUsersCompanion {
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
