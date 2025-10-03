import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/chat/entities.dart';
import '../../domain/chat/repositories.dart';
import '../../infrastructure/db/app_database.dart';
import '../../infrastructure/db/daos/chat_dao.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(this._db, this._dao);

  final AppDatabase _db;
  final ChatDao _dao;

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
    final companion = MessagesCompanion(
      id: Value(message.id.isEmpty ? const Uuid().v4() : message.id),
      classId: Value(message.classId),
      userId: Value(message.userId),
      body: Value(message.body),
      createdAt: Value(message.createdAt.millisecondsSinceEpoch),
      deleted: Value(message.deleted),
      flagged: Value(message.flagged),
    );
    await _dao.insertMessage(companion);
  }

  @override
  Future<void> flagMessage(String id, {bool flagged = true}) {
    return _dao.updateMessage(
      id,
      MessagesCompanion(
        flagged: Value(flagged),
      ),
    );
  }

  @override
  Future<void> deleteMessage(String id) {
    return _dao.updateMessage(
      id,
      MessagesCompanion(
        deleted: const Value(true),
      ),
    );
  }
}
