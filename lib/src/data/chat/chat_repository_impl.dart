import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/chat/entities.dart';
import '../../domain/chat/repositories.dart';
import '../../domain/sync/entities.dart';
import '../../domain/sync/repositories.dart';
import '../../infrastructure/db/app_database.dart';
import '../../infrastructure/db/daos/chat_dao.dart';
import '../../infrastructure/db/daos/sync_dao.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(this._db, this._dao, this._syncDao, this._syncRepository);

  final AppDatabase _db;
  final ChatDao _dao;
  final SyncDao _syncDao;
  final SyncRepository _syncRepository;

  Future<void> _ensureSeeded() => _db.ensureSeeded();

  @override
  Stream<List<ChatMessage>> watchMessages(String classId) async* {
    await _ensureSeeded();
    yield* _dao.watchMessages(classId).map(
      (rows) => rows
          .map(
            (row) => ChatMessage(
              id: row.id,
              classId: row.classId,
              userId: row.userId,
              body: row.body,
              createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
              deleted: row.deleted,
              flagged: row.flagged,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<void> addMessage(ChatMessage message) async {
    await _ensureSeeded();
    final id = message.id.isEmpty ? const Uuid().v4() : message.id;
    final createdAt = message.createdAt.millisecondsSinceEpoch;
    final companion = MessagesCompanion(
      id: Value(id),
      classId: Value(message.classId),
      userId: Value(message.userId),
      body: Value(message.body),
      createdAt: Value(createdAt),
      updatedAt: Value(createdAt),
      deleted: Value(message.deleted),
      flagged: Value(message.flagged),
    );
    await _dao.insertMessage(companion);
    await _syncDao.recordMessageChange(
      messageId: id,
      userId: message.userId,
      localUpdatedAt: createdAt,
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
          'updatedAt': createdAt,
          'deleted': message.deleted,
          'flagged': message.flagged,
        },
        createdAt: message.createdAt,
      ),
    );
  }

  @override
  Future<void> flagMessage(String id, {bool flagged = true}) async {
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
        },
        createdAt: now,
      ),
    );
  }

  @override
  Future<void> deleteMessage(String id) async {
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
  }
}
