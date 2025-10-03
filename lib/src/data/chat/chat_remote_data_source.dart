import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/chat/entities.dart';

class RemoteChatMessage {
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

  RemoteChatMessage({
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
  });

  factory RemoteChatMessage.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return RemoteChatMessage(
      id: doc.id,
      classId: data['classId'] as String,
      userId: data['userId'] as String,
      body: data['body'] as String? ?? '',
      createdAt: _fromTimestamp(data['createdAt']),
      updatedAt: _fromTimestamp(data['updatedAt']),
      deleted: data['deleted'] as bool? ?? false,
      flagged: data['flagged'] as bool? ?? false,
      attachments: _parseAttachments(data['attachments']),
      authorName: data['authorName'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'classId': classId,
        'userId': userId,
        'body': body,
        'createdAt': Timestamp.fromDate(createdAt.toUtc()),
        'updatedAt': Timestamp.fromDate(updatedAt.toUtc()),
        'deleted': deleted,
        'flagged': flagged,
        'attachments': attachments.map((e) => e.toJson()).toList(),
        if (authorName != null) 'authorName': authorName,
      };

  static List<ChatAttachment> _parseAttachments(dynamic raw) {
    if (raw == null) {
      return const [];
    }
    final list = (raw as List<dynamic>)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList(growable: false);
    return list
        .map(
          (item) => ChatAttachment(
            id: item['id'] as String,
            type: item['type'] as String,
            name: item['name'] as String? ?? '',
            url: item['url'] as String? ?? '',
            localPath: item['localPath'] as String?,
            sizeBytes: item['sizeBytes'] as int?,
          ),
        )
        .toList();
  }
}

class RemoteTypingStatus {
  final String userId;
  final String classId;
  final bool isTyping;
  final DateTime updatedAt;

  RemoteTypingStatus({
    required this.userId,
    required this.classId,
    required this.isTyping,
    required this.updatedAt,
  });

  factory RemoteTypingStatus.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return RemoteTypingStatus(
      userId: data['userId'] as String,
      classId: data['classId'] as String,
      isTyping: data['isTyping'] as bool? ?? false,
      updatedAt: _fromTimestamp(data['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'classId': classId,
        'isTyping': isTyping,
        'updatedAt': Timestamp.fromDate(updatedAt.toUtc()),
      };
}

class RemoteModerationAction {
  final String id;
  final String classId;
  final String targetUserId;
  final ModerationActionType type;
  final String moderatorId;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final ModerationActionStatus status;
  final String? reason;
  final Map<String, dynamic> metadata;

  RemoteModerationAction({
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

  factory RemoteModerationAction.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return RemoteModerationAction(
      id: doc.id,
      classId: data['classId'] as String,
      targetUserId: data['targetUserId'] as String,
      type: ModerationActionType.values.firstWhere(
        (value) => value.name == (data['type'] as String? ?? 'flag'),
        orElse: () => ModerationActionType.flag,
      ),
      moderatorId: data['moderatorId'] as String? ?? '',
      createdAt: _fromTimestamp(data['createdAt']),
      expiresAt: data['expiresAt'] != null ? _fromTimestamp(data['expiresAt']) : null,
      status: ModerationActionStatus.values.firstWhere(
        (value) => value.name == (data['status'] as String? ?? 'pending'),
        orElse: () => ModerationActionStatus.pending,
      ),
      reason: data['reason'] as String?,
      metadata: Map<String, dynamic>.from(data['metadata'] as Map? ?? const {}),
    );
  }

  Map<String, dynamic> toMap() => {
        'classId': classId,
        'targetUserId': targetUserId,
        'type': type.name,
        'moderatorId': moderatorId,
        'createdAt': Timestamp.fromDate(createdAt.toUtc()),
        'expiresAt': expiresAt != null
            ? Timestamp.fromDate(expiresAt!.toUtc())
            : null,
        'status': status.name,
        if (reason != null) 'reason': reason,
        'metadata': metadata,
      }..removeWhere((key, value) => value == null);
}

class RemoteModerationAppeal {
  final String id;
  final String actionId;
  final String userId;
  final String message;
  final DateTime createdAt;
  final ModerationAppealStatus status;
  final DateTime? resolvedAt;
  final String? resolutionNotes;

  RemoteModerationAppeal({
    required this.id,
    required this.actionId,
    required this.userId,
    required this.message,
    required this.createdAt,
    this.status = ModerationAppealStatus.submitted,
    this.resolvedAt,
    this.resolutionNotes,
  });

  factory RemoteModerationAppeal.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return RemoteModerationAppeal(
      id: doc.id,
      actionId: data['actionId'] as String,
      userId: data['userId'] as String,
      message: data['message'] as String? ?? '',
      createdAt: _fromTimestamp(data['createdAt']),
      status: ModerationAppealStatus.values.firstWhere(
        (value) => value.name == (data['status'] as String? ?? 'submitted'),
        orElse: () => ModerationAppealStatus.submitted,
      ),
      resolvedAt:
          data['resolvedAt'] != null ? _fromTimestamp(data['resolvedAt']) : null,
      resolutionNotes: data['resolutionNotes'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'actionId': actionId,
        'userId': userId,
        'message': message,
        'createdAt': Timestamp.fromDate(createdAt.toUtc()),
        'status': status.name,
        if (resolvedAt != null)
          'resolvedAt': Timestamp.fromDate(resolvedAt!.toUtc()),
        if (resolutionNotes != null) 'resolutionNotes': resolutionNotes,
      };
}

class ChatRemoteDataSource {
  ChatRemoteDataSource(this._firestore, this._storage);

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  CollectionReference<Map<String, dynamic>> _messagesCollection(String classId) {
    return _firestore.collection('classes').doc(classId).collection('messages');
  }

  CollectionReference<Map<String, dynamic>> _typingCollection(String classId) {
    return _firestore.collection('classes').doc(classId).collection('typing');
  }

  CollectionReference<Map<String, dynamic>> _moderationCollection(String classId) {
    return _firestore.collection('classes').doc(classId).collection('moderation');
  }

  CollectionReference<Map<String, dynamic>> _appealsCollection(String classId) {
    return _firestore.collection('classes').doc(classId).collection('appeals');
  }

  Stream<List<RemoteChatMessage>> watchMessages(String classId) {
    return _messagesCollection(classId)
        .orderBy('createdAt')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(RemoteChatMessage.fromDoc)
              .toList(growable: false),
        );
  }

  Stream<List<RemoteTypingStatus>> watchTyping(String classId) {
    return _typingCollection(classId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(RemoteTypingStatus.fromDoc)
              .toList(growable: false),
        );
  }

  Stream<List<RemoteModerationAction>> watchModerationActions(String classId) {
    return _moderationCollection(classId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(RemoteModerationAction.fromDoc)
              .toList(growable: false),
        );
  }

  Stream<List<RemoteModerationAppeal>> watchAppeals(String classId) {
    return _appealsCollection(classId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(RemoteModerationAppeal.fromDoc)
              .toList(growable: false),
        );
  }

  Future<void> sendMessage(RemoteChatMessage message) {
    final doc = _messagesCollection(message.classId).doc(message.id);
    return doc.set(message.toMap(), SetOptions(merge: true));
  }

  Future<void> updateMessage(
    String classId,
    String messageId,
    Map<String, dynamic> data,
  ) {
    final sanitized = <String, dynamic>{};
    data.forEach((key, value) {
      if (value is DateTime) {
        sanitized[key] = Timestamp.fromDate(value.toUtc());
      } else {
        sanitized[key] = value;
      }
    });
    return _messagesCollection(classId)
        .doc(messageId)
        .set(sanitized, SetOptions(merge: true));
  }

  Future<void> deleteMessage(String classId, String messageId) {
    return _messagesCollection(classId).doc(messageId).update({
      'deleted': true,
      'updatedAt': Timestamp.fromDate(DateTime.now().toUtc()),
    });
  }

  Future<String> uploadAttachment({
    required String classId,
    required String messageId,
    required File file,
    required String fileName,
  }) async {
    final ref = _storage
        .ref()
        .child('classes/$classId/messages/$messageId/${DateTime.now().millisecondsSinceEpoch}_$fileName');
    final uploadTask = await ref.putFile(file);
    return uploadTask.ref.getDownloadURL();
  }

  Future<void> setTyping(RemoteTypingStatus status) {
    return _typingCollection(status.classId)
        .doc(status.userId)
        .set(status.toMap(), SetOptions(merge: true));
  }

  Future<void> removeTyping(String classId, String userId) {
    return _typingCollection(classId).doc(userId).delete();
  }

  Future<void> recordModerationAction(RemoteModerationAction action) {
    return _moderationCollection(action.classId)
        .doc(action.id)
        .set(action.toMap(), SetOptions(merge: true));
  }

  Future<void> submitAppeal(RemoteModerationAppeal appeal, String classId) {
    return _appealsCollection(classId)
        .doc(appeal.id)
        .set(appeal.toMap(), SetOptions(merge: true));
  }

  static DateTime _fromTimestamp(dynamic value) {
    if (value is Timestamp) {
      return value.toDate().toUtc();
    }
    if (value is DateTime) {
      return value.toUtc();
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
    }
    return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  }
}
