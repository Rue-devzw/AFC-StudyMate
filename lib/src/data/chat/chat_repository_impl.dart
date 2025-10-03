import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/chat/entities.dart';
import '../../domain/chat/errors.dart';
import '../../domain/chat/repositories.dart';
import '../../domain/sync/entities.dart';
import '../../domain/sync/repositories.dart';
import '../../infrastructure/db/app_database.dart';
import '../../infrastructure/db/daos/chat_dao.dart';
import '../../infrastructure/db/daos/sync_dao.dart';
import 'chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(
    this._db,
    this._dao,
    this._syncDao,
    this._syncRepository,
    this._remote,
  );

  final AppDatabase _db;
  final ChatDao _dao;
  final SyncDao _syncDao;
  final SyncRepository _syncRepository;
  final ChatRemoteDataSource _remote;

  final _messageSubscriptions = <String, StreamSubscription>{};
  final _typingSubscriptions = <String, StreamSubscription>{};
  final _moderationSubscriptions = <String, StreamSubscription>{};
  final _appealSubscriptions = <String, StreamSubscription>{};

  Future<void> _ensureSeeded() => _db.ensureSeeded();

  Future<void> dispose() async {
    for (final sub in _messageSubscriptions.values) {
      await sub.cancel();
    }
    for (final sub in _typingSubscriptions.values) {
      await sub.cancel();
    }
    for (final sub in _moderationSubscriptions.values) {
      await sub.cancel();
    }
    for (final sub in _appealSubscriptions.values) {
      await sub.cancel();
    }
    _messageSubscriptions.clear();
    _typingSubscriptions.clear();
    _moderationSubscriptions.clear();
    _appealSubscriptions.clear();
  }

  Future<void> _ensureRemoteSubscriptions(String classId) async {
    if (!_messageSubscriptions.containsKey(classId)) {
      final messageSub = _remote.watchMessages(classId).listen(
        (remoteMessages) async {
          for (final remote in remoteMessages) {
            final companion = MessagesCompanion(
              id: Value(remote.id),
              classId: Value(remote.classId),
              userId: Value(remote.userId),
              body: Value(remote.body),
              createdAt: Value(remote.createdAt.millisecondsSinceEpoch),
              updatedAt: Value(remote.updatedAt.millisecondsSinceEpoch),
              deleted: Value(remote.deleted),
              flagged: Value(remote.flagged),
              attachments:
                  Value(ChatMessage.encodeAttachments(remote.attachments)),
              authorName: Value(remote.authorName),
            );
            await _dao.insertMessage(companion);
          }
        },
        onError: (_) {},
      );
      _messageSubscriptions[classId] = messageSub;
    }

    if (!_typingSubscriptions.containsKey(classId)) {
      final typingSub = _remote.watchTyping(classId).listen(
        (statuses) async {
          final activeUsers = statuses
              .where((status) => status.isTyping)
              .map((status) => status.userId)
              .toList(growable: false);
          await _db.transaction(() async {
            if (activeUsers.isEmpty) {
              await (_db.delete(_db.typingIndicators)
                    ..where((tbl) => tbl.classId.equals(classId)))
                  .go();
            } else {
              await (_db.delete(_db.typingIndicators)
                    ..where(
                      (tbl) => tbl.classId.equals(classId) &
                          tbl.userId.isNotIn(activeUsers),
                    ))
                  .go();
            }
            for (final status in statuses) {
              if (!status.isTyping) {
                await _dao.removeTyping(classId, status.userId);
                continue;
              }
              await _dao.upsertTyping(
                TypingIndicatorsCompanion(
                  classId: Value(status.classId),
                  userId: Value(status.userId),
                  isTyping: Value(status.isTyping),
                  updatedAt: Value(
                    status.updatedAt.millisecondsSinceEpoch,
                  ),
                ),
              );
            }
          });
        },
        onError: (_) {},
      );
      _typingSubscriptions[classId] = typingSub;
    }

    if (!_moderationSubscriptions.containsKey(classId)) {
      final moderationSub = _remote.watchModerationActions(classId).listen(
        (actions) async {
          for (final action in actions) {
            await _dao.upsertModerationAction(
              ModerationActionsTableCompanion(
                id: Value(action.id),
                classId: Value(action.classId),
                targetUserId: Value(action.targetUserId),
                moderatorId: Value(action.moderatorId),
                type: Value(action.type.name),
                status: Value(action.status.name),
                reason: Value(action.reason),
                metadata: Value(jsonEncode(action.metadata)),
                createdAt: Value(action.createdAt.millisecondsSinceEpoch),
                expiresAt: Value(action.expiresAt?.millisecondsSinceEpoch),
              ),
            );
          }
        },
        onError: (_) {},
      );
      _moderationSubscriptions[classId] = moderationSub;
    }

    if (!_appealSubscriptions.containsKey(classId)) {
      final appealSub = _remote.watchAppeals(classId).listen(
        (appeals) async {
          for (final appeal in appeals) {
            await _dao.upsertModerationAppeal(
              ModerationAppealsTableCompanion(
                id: Value(appeal.id),
                actionId: Value(appeal.actionId),
                classId: Value(classId),
                userId: Value(appeal.userId),
                message: Value(appeal.message),
                status: Value(appeal.status.name),
                resolutionNotes: Value(appeal.resolutionNotes),
                createdAt: Value(appeal.createdAt.millisecondsSinceEpoch),
                resolvedAt: Value(appeal.resolvedAt?.millisecondsSinceEpoch),
              ),
            );
          }
        },
        onError: (_) {},
      );
      _appealSubscriptions[classId] = appealSub;
    }
  }

  List<ChatMessage> _mapMessages(List<Message> rows) {
    return rows
        .map(
          (row) => ChatMessage(
            id: row.id,
            classId: row.classId,
            userId: row.userId,
            body: row.body,
            createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
            updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
            deleted: row.deleted,
            flagged: row.flagged,
            attachments: ChatMessage.decodeAttachments(row.attachments),
            authorName: row.authorName,
          ),
        )
        .toList(growable: false);
  }

  @override
  Stream<List<ChatMessage>> watchMessages(String classId) async* {
    await _ensureSeeded();
    unawaited(_ensureRemoteSubscriptions(classId));
    yield* _dao.watchMessages(classId).map(_mapMessages);
  }

  @override
  Stream<List<TypingStatus>> watchTyping(String classId) async* {
    await _ensureSeeded();
    unawaited(_ensureRemoteSubscriptions(classId));
    yield* _dao.watchTyping(classId).map(
          (rows) => rows
              .map(
                (row) => TypingStatus(
                  userId: row.userId,
                  classId: row.classId,
                  isTyping: row.isTyping,
                  updatedAt:
                      DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
                ),
              )
              .toList(growable: false),
        );
  }

  @override
  Stream<List<ModerationAction>> watchModerationActions(String classId) async* {
    await _ensureSeeded();
    unawaited(_ensureRemoteSubscriptions(classId));
    yield* _dao.watchModerationActions(classId).map(
          (rows) => rows
              .map(
                (row) => ModerationAction(
                  id: row.id,
                  classId: row.classId,
                  targetUserId: row.targetUserId,
                  type: ModerationActionType.values.firstWhere(
                    (value) => value.name == row.type,
                    orElse: () => ModerationActionType.flag,
                  ),
                  moderatorId: row.moderatorId,
                  createdAt:
                      DateTime.fromMillisecondsSinceEpoch(row.createdAt),
                  expiresAt: row.expiresAt != null
                      ? DateTime.fromMillisecondsSinceEpoch(row.expiresAt!)
                      : null,
                  status: ModerationActionStatus.values.firstWhere(
                    (value) => value.name == row.status,
                    orElse: () => ModerationActionStatus.pending,
                  ),
                  reason: row.reason,
                  metadata: Map<String, Object?>.from(
                    jsonDecode(row.metadata) as Map,
                  ),
                ),
              )
              .toList(growable: false),
        );
  }

  @override
  Future<void> addMessage(ChatMessage message) async {
    await _ensureSeeded();
    final activeActions = await _dao.getModerationActionsForUser(
      message.classId,
      message.userId,
    );
    final nowMs = DateTime.now().toUtc().millisecondsSinceEpoch;
    ModerationActionRow? activeBan;
    ModerationActionRow? activeMute;
    for (final action in activeActions) {
      if (action.status == ModerationActionStatus.resolved.name ||
          action.status == ModerationActionStatus.expired.name) {
        continue;
      }
      if (action.expiresAt != null && action.expiresAt! <= nowMs) {
        await _dao.updateModerationActionStatus(
          action.id,
          ModerationActionStatus.expired.name,
        );
        continue;
      }
      if (action.type == ModerationActionType.ban.name) {
        activeBan = action;
        break;
      }
      if (action.type != ModerationActionType.mute.name) {
        continue;
      }
      if (activeMute == null) {
        activeMute = action;
        continue;
      }
      if (activeMute.expiresAt == null) {
        continue;
      }
      if (action.expiresAt == null) {
        activeMute = action;
        continue;
      }
      if (action.expiresAt! > (activeMute.expiresAt ?? 0)) {
        activeMute = action;
      }
    }

    if (activeBan != null) {
      final banReason = activeBan.reason;
      final banMessage = StringBuffer('You are banned from this class chat');
      if (banReason != null && banReason.isNotEmpty) {
        banMessage.write(': $banReason.');
      } else {
        banMessage.write('.');
      }
      throw ChatModerationException(
        message: banMessage.toString(),
        actionType: ModerationActionType.ban,
        actionId: activeBan.id,
        reason: banReason,
      );
    }

    if (activeMute != null) {
      final muteReason = activeMute.reason;
      final expiresAtUtc = activeMute.expiresAt != null
          ? DateTime.fromMillisecondsSinceEpoch(
              activeMute.expiresAt!,
              isUtc: true,
            )
          : null;
      final buffer = StringBuffer('You are muted in this class chat');
      if (expiresAtUtc != null) {
        buffer.write(' until ${expiresAtUtc.toLocal()}');
      }
      if (muteReason != null && muteReason.isNotEmpty) {
        buffer.write('. Reason: $muteReason.');
      } else {
        buffer.write('.');
      }
      throw ChatModerationException(
        message: buffer.toString(),
        actionType: ModerationActionType.mute,
        actionId: activeMute.id,
        expiresAt: expiresAtUtc,
        reason: muteReason,
      );
    }
    final id = message.id.isEmpty ? const Uuid().v4() : message.id;
    final createdAt = message.createdAt.millisecondsSinceEpoch;
    final uploadedAttachments = <ChatAttachment>[];
    for (final attachment in message.attachments) {
      if ((attachment.url.isEmpty) && attachment.localPath != null) {
        final file = File(attachment.localPath!);
        if (await file.exists()) {
          final url = await _remote.uploadAttachment(
            classId: message.classId,
            messageId: id,
            file: file,
            fileName: attachment.name,
          );
          uploadedAttachments.add(
            ChatAttachment(
              id: attachment.id,
              type: attachment.type,
              name: attachment.name,
              url: url,
              localPath: attachment.localPath,
              sizeBytes: attachment.sizeBytes ?? await file.length(),
            ),
          );
        }
      } else {
        uploadedAttachments.add(attachment);
      }
    }

    final companion = MessagesCompanion(
      id: Value(id),
      classId: Value(message.classId),
      userId: Value(message.userId),
      body: Value(message.body),
      createdAt: Value(createdAt),
      updatedAt: Value(message.updatedAt.millisecondsSinceEpoch),
      deleted: Value(message.deleted),
      flagged: Value(message.flagged),
      attachments: Value(ChatMessage.encodeAttachments(uploadedAttachments)),
      authorName: Value(message.authorName),
    );
    await _dao.insertMessage(companion);
    await _syncDao.recordMessageChange(
      messageId: id,
      userId: message.userId,
      localUpdatedAt: message.updatedAt.millisecondsSinceEpoch,
      operation: 'upsert',
    );
    await _syncRepository.enqueue(
      SyncOperation(
        id: 'message:$id',
        userId: message.userId,
        opType: 'message.upsert',
        payload: {
          'messageId': id,
          'classId': message.classId,
          'body': message.body,
          'createdAt': createdAt,
          'updatedAt': message.updatedAt.millisecondsSinceEpoch,
          'deleted': message.deleted,
          'flagged': message.flagged,
          'attachments':
              uploadedAttachments.map((attachment) => attachment.toJson()).toList(),
          if (message.authorName != null) 'authorName': message.authorName,
        },
        createdAt: message.createdAt,
      ),
    );
    final remoteMessage = RemoteChatMessage(
      id: id,
      classId: message.classId,
      userId: message.userId,
      body: message.body,
      createdAt: message.createdAt.toUtc(),
      updatedAt: message.updatedAt.toUtc(),
      deleted: message.deleted,
      flagged: message.flagged,
      attachments: uploadedAttachments,
      authorName: message.authorName,
    );
    await _remote.sendMessage(remoteMessage);
  }

  @override
  Future<void> flagMessage(
    String id, {
    bool flagged = true,
    String? moderatorId,
    String? reason,
  }) async {
    await _ensureSeeded();
    final existing = await _dao.getMessageById(id);
    if (existing == null) {
      return;
    }
    final now = DateTime.now();
    await _dao.updateMessage(
      id,
      MessagesCompanion(
        flagged: Value(flagged),
        updatedAt: Value(now.millisecondsSinceEpoch),
      ),
    );
    await _syncDao.recordMessageChange(
      messageId: id,
      userId: existing.userId,
      localUpdatedAt: now.millisecondsSinceEpoch,
      operation: 'upsert',
    );
    await _syncRepository.enqueue(
      SyncOperation(
        id: 'message:$id',
        userId: existing.userId,
        opType: 'message.upsert',
        payload: {
          'messageId': id,
          'classId': existing.classId,
          'body': existing.body,
          'createdAt': existing.createdAt,
          'updatedAt': now.millisecondsSinceEpoch,
          'deleted': existing.deleted,
          'flagged': flagged,
          'attachments': jsonDecode(existing.attachments),
          if (existing.authorName != null) 'authorName': existing.authorName,
        },
        createdAt: now,
      ),
    );
    await _remote.updateMessage(existing.classId, id, {
      'flagged': flagged,
      'updatedAt': DateTime.now().toUtc(),
      if (reason != null) 'flagReason': reason,
    });
    if (moderatorId != null) {
      await _logModerationAction(
        classId: existing.classId,
        targetUserId: existing.userId,
        type: ModerationActionType.flag,
        moderatorId: moderatorId,
        reason: reason,
        metadata: {
          'messageId': id,
        },
      );
    }
  }

  @override
  Future<void> deleteMessage(
    String id, {
    String? moderatorId,
    String? reason,
  }) async {
    await _ensureSeeded();
    final existing = await _dao.getMessageById(id);
    if (existing == null) {
      return;
    }
    final now = DateTime.now();
    await _dao.updateMessage(
      id,
      MessagesCompanion(
        deleted: const Value(true),
        updatedAt: Value(now.millisecondsSinceEpoch),
      ),
    );
    await _syncDao.recordMessageChange(
      messageId: id,
      userId: existing.userId,
      localUpdatedAt: now.millisecondsSinceEpoch,
      operation: 'delete',
    );
    await _syncRepository.enqueue(
      SyncOperation(
        id: 'message:$id',
        userId: existing.userId,
        opType: 'message.delete',
        payload: {
          'messageId': id,
          'classId': existing.classId,
          'updatedAt': now.millisecondsSinceEpoch,
          'deleted': true,
        },
        createdAt: now,
      ),
    );
    await _remote.deleteMessage(existing.classId, id);
    if (moderatorId != null) {
      await _logModerationAction(
        classId: existing.classId,
        targetUserId: existing.userId,
        type: ModerationActionType.delete,
        moderatorId: moderatorId,
        reason: reason,
        metadata: {
          'messageId': id,
        },
      );
    }
  }

  Future<void> _logModerationAction({
    required String classId,
    required String targetUserId,
    required ModerationActionType type,
    required String moderatorId,
    String? reason,
    Map<String, Object?> metadata = const {},
    Duration? duration,
  }) async {
    await _ensureSeeded();
    final id = const Uuid().v4();
    final now = DateTime.now().toUtc();
    final expiresAt = duration != null ? now.add(duration) : null;
    final action = ModerationAction(
      id: id,
      classId: classId,
      targetUserId: targetUserId,
      type: type,
      moderatorId: moderatorId,
      createdAt: now,
      expiresAt: expiresAt,
      status: ModerationActionStatus.active,
      reason: reason,
      metadata: metadata,
    );
    await _dao.upsertModerationAction(
      ModerationActionsTableCompanion(
        id: Value(id),
        classId: Value(classId),
        targetUserId: Value(targetUserId),
        moderatorId: Value(moderatorId),
        type: Value(type.name),
        status: Value(action.status.name),
        reason: Value(reason),
        metadata: Value(jsonEncode(metadata)),
        createdAt: Value(now.millisecondsSinceEpoch),
        expiresAt: Value(expiresAt?.millisecondsSinceEpoch),
      ),
    );
    await _remote.recordModerationAction(
      RemoteModerationAction(
        id: id,
        classId: classId,
        targetUserId: targetUserId,
        type: type,
        moderatorId: moderatorId,
        createdAt: now,
        expiresAt: expiresAt,
        status: ModerationActionStatus.active,
        reason: reason,
        metadata: Map<String, dynamic>.from(metadata),
      ),
    );
  }

  @override
  Future<void> muteUser({
    required String classId,
    required String userId,
    required Duration duration,
    required String moderatorId,
    String? reason,
  }) {
    return _logModerationAction(
      classId: classId,
      targetUserId: userId,
      type: ModerationActionType.mute,
      moderatorId: moderatorId,
      reason: reason,
      metadata: const {},
      duration: duration,
    );
  }

  @override
  Future<void> banUser({
    required String classId,
    required String userId,
    required String moderatorId,
    String? reason,
  }) {
    return _logModerationAction(
      classId: classId,
      targetUserId: userId,
      type: ModerationActionType.ban,
      moderatorId: moderatorId,
      reason: reason,
    );
  }

  @override
  Future<void> unbanOrUnmute({
    required String actionId,
    required String moderatorId,
    String? notes,
  }) async {
    await _ensureSeeded();
    final action = await _dao.getModerationAction(actionId);
    if (action == null) {
      return;
    }
    await _dao.upsertModerationAction(
      ModerationActionsTableCompanion(
        id: Value(actionId),
        status: Value(ModerationActionStatus.resolved.name),
        reason: Value(action.reason),
        metadata: Value(action.metadata),
        classId: Value(action.classId),
        targetUserId: Value(action.targetUserId),
        moderatorId: Value(moderatorId),
        type: Value(action.type),
        createdAt: Value(action.createdAt),
        expiresAt: Value(action.expiresAt),
      ),
    );
    await _remote.recordModerationAction(
      RemoteModerationAction(
        id: actionId,
        classId: action.classId,
        targetUserId: action.targetUserId,
        type: ModerationActionType.values.firstWhere(
          (value) => value.name == action.type,
          orElse: () => ModerationActionType.flag,
        ),
        moderatorId: moderatorId,
        createdAt:
            DateTime.fromMillisecondsSinceEpoch(action.createdAt, isUtc: true),
        expiresAt: action.expiresAt != null
            ? DateTime.fromMillisecondsSinceEpoch(action.expiresAt!, isUtc: true)
            : null,
        status: ModerationActionStatus.resolved,
        reason: action.reason,
        metadata: Map<String, dynamic>.from(
          jsonDecode(action.metadata) as Map,
        )
          ..['resolutionNotes'] = notes,
      ),
    );
  }

  @override
  Future<void> submitAppeal(ModerationAppeal appeal) async {
    await _ensureSeeded();
    await _dao.upsertModerationAppeal(
      ModerationAppealsTableCompanion(
        id: Value(appeal.id),
        actionId: Value(appeal.actionId),
        classId: Value(appeal.classId),
        userId: Value(appeal.userId),
        message: Value(appeal.message),
        status: Value(appeal.status.name),
        createdAt: Value(appeal.createdAt.millisecondsSinceEpoch),
        resolvedAt: Value(appeal.resolvedAt?.millisecondsSinceEpoch),
        resolutionNotes: Value(appeal.resolutionNotes),
      ),
    );
    await _remote.submitAppeal(
      RemoteModerationAppeal(
        id: appeal.id,
        actionId: appeal.actionId,
        userId: appeal.userId,
        message: appeal.message,
        createdAt: appeal.createdAt.toUtc(),
        status: appeal.status,
        resolvedAt: appeal.resolvedAt?.toUtc(),
        resolutionNotes: appeal.resolutionNotes,
      ),
      appeal.classId,
    );
  }

  @override
  Future<void> updateTyping({
    required String classId,
    required String userId,
    required bool isTyping,
  }) async {
    await _ensureSeeded();
    final now = DateTime.now();
    if (isTyping) {
      await _dao.upsertTyping(
        TypingIndicatorsCompanion(
          classId: Value(classId),
          userId: Value(userId),
          isTyping: const Value(true),
          updatedAt: Value(now.millisecondsSinceEpoch),
        ),
      );
      await _remote.setTyping(
        RemoteTypingStatus(
          userId: userId,
          classId: classId,
          isTyping: true,
          updatedAt: now.toUtc(),
        ),
      );
    } else {
      await _dao.removeTyping(classId, userId);
      await _remote.removeTyping(classId, userId);
    }
  }
}
