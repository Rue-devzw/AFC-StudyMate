import 'dart:convert';

class ChatAttachment {
  final String id;
  final String type;
  final String name;
  final String url;
  final String? localPath;
  final int? sizeBytes;

  const ChatAttachment({
    required this.id,
    required this.type,
    required this.name,
    required this.url,
    this.localPath,
    this.sizeBytes,
  });

  Map<String, Object?> toJson() => {
        'id': id,
        'type': type,
        'name': name,
        'url': url,
        if (localPath != null) 'localPath': localPath,
        if (sizeBytes != null) 'sizeBytes': sizeBytes,
      };

  factory ChatAttachment.fromJson(Map<String, Object?> json) {
    return ChatAttachment(
      id: json['id'] as String,
      type: json['type'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      localPath: json['localPath'] as String?,
      sizeBytes: json['sizeBytes'] as int?,
    );
  }
}

enum ModerationActionType { flag, delete, mute, ban }

enum ModerationActionStatus { pending, active, resolved, expired }

class ModerationAction {
  final String id;
  final String classId;
  final String targetUserId;
  final ModerationActionType type;
  final String moderatorId;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final ModerationActionStatus status;
  final String? reason;
  final Map<String, Object?> metadata;

  const ModerationAction({
    required this.id,
    required this.classId,
    required this.targetUserId,
    required this.type,
    required this.moderatorId,
    required this.createdAt,
    this.expiresAt,
    this.status = ModerationActionStatus.pending,
    this.reason,
    this.metadata = const {},
  });

  ModerationAction copyWith({
    ModerationActionStatus? status,
    DateTime? expiresAt,
    Map<String, Object?>? metadata,
  }) {
    return ModerationAction(
      id: id,
      classId: classId,
      targetUserId: targetUserId,
      type: type,
      moderatorId: moderatorId,
      createdAt: createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      status: status ?? this.status,
      reason: reason,
      metadata: metadata ?? this.metadata,
    );
  }
}

enum ModerationAppealStatus { submitted, underReview, approved, rejected }

class ModerationAppeal {
  final String id;
  final String actionId;
  final String classId;
  final String userId;
  final String message;
  final DateTime createdAt;
  final ModerationAppealStatus status;
  final DateTime? resolvedAt;
  final String? resolutionNotes;

  const ModerationAppeal({
    required this.id,
    required this.actionId,
    required this.classId,
    required this.userId,
    required this.message,
    required this.createdAt,
    this.status = ModerationAppealStatus.submitted,
    this.resolvedAt,
    this.resolutionNotes,
  });
}

class TypingStatus {
  final String userId;
  final String classId;
  final bool isTyping;
  final DateTime updatedAt;

  const TypingStatus({
    required this.userId,
    required this.classId,
    required this.isTyping,
    required this.updatedAt,
  });
}

class ChatMessage {
  final String id;
  final String classId;
  final String userId;
  final String body;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool deleted;
  final bool flagged;
  final List<ChatAttachment> attachments;
  final String? authorName;
  final bool localOnly;

  const ChatMessage({
    required this.id,
    required this.classId,
    required this.userId,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
    this.deleted = false,
    this.flagged = false,
    this.attachments = const [],
    this.authorName,
    this.localOnly = false,
  });

  ChatMessage copyWith({
    String? body,
    DateTime? updatedAt,
    bool? deleted,
    bool? flagged,
    List<ChatAttachment>? attachments,
    bool? localOnly,
  }) {
    return ChatMessage(
      id: id,
      classId: classId,
      userId: userId,
      body: body ?? this.body,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      flagged: flagged ?? this.flagged,
      attachments: attachments ?? this.attachments,
      authorName: authorName,
      localOnly: localOnly ?? this.localOnly,
    );
  }

  static String encodeAttachments(List<ChatAttachment> attachments) {
    if (attachments.isEmpty) {
      return '[]';
    }
    return jsonEncode(attachments.map((e) => e.toJson()).toList());
  }

  static List<ChatAttachment> decodeAttachments(String? json) {
    if (json == null || json.isEmpty) {
      return const [];
    }
    final data = jsonDecode(json) as List<dynamic>;
    return data
        .map((e) => ChatAttachment.fromJson(Map<String, Object?>.from(e as Map)))
        .toList();
  }
}
