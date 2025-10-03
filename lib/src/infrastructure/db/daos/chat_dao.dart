import 'package:drift/drift.dart';

import '../app_database.dart';

class ChatDao {
  ChatDao(this._db);

  final AppDatabase _db;

  Stream<List<Message>> watchMessages(String classId) {
    final query = _db.select(_db.messages)
      ..where((tbl) => tbl.classId.equals(classId))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)]);
    return query.watch();
  }

  Future<void> insertMessage(MessagesCompanion companion) {
    return _db.into(_db.messages).insertOnConflictUpdate(companion);
  }

  Future<void> updateMessage(String id, MessagesCompanion companion) {
    return (_db.update(_db.messages)..where((tbl) => tbl.id.equals(id)))
        .write(companion);
  }

  Future<Message?> getMessageById(String id) {
    return (_db.select(_db.messages)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Stream<List<TypingIndicatorRow>> watchTyping(String classId) {
    final query = _db.select(_db.typingIndicators)
      ..where((tbl) => tbl.classId.equals(classId));
    return query.watch();
  }

  Future<void> upsertTyping(TypingIndicatorsCompanion companion) {
    return _db
        .into(_db.typingIndicators)
        .insertOnConflictUpdate(companion);
  }

  Future<void> removeTyping(String classId, String userId) {
    return (_db.delete(_db.typingIndicators)
          ..where(
            (tbl) =>
                tbl.classId.equals(classId) & tbl.userId.equals(userId),
          ))
        .go();
  }

  Stream<List<ModerationActionRow>> watchModerationActions(String classId) {
    final query = _db.select(_db.moderationActionsTable)
      ..where((tbl) => tbl.classId.equals(classId))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]);
    return query.watch();
  }

  Stream<List<ModerationAppealRow>> watchModerationAppeals(String classId) {
    final query = _db.select(_db.moderationAppealsTable)
      ..where((tbl) => tbl.classId.equals(classId))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]);
    return query.watch();
  }

  Future<void> upsertModerationAction(
    ModerationActionsTableCompanion companion,
  ) {
    return _db
        .into(_db.moderationActionsTable)
        .insertOnConflictUpdate(companion);
  }

  Future<void> upsertModerationAppeal(
    ModerationAppealsTableCompanion companion,
  ) {
    return _db
        .into(_db.moderationAppealsTable)
        .insertOnConflictUpdate(companion);
  }

  Future<ModerationActionRow?> getModerationAction(String id) {
    return (_db.select(_db.moderationActionsTable)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<ModerationActionRow>> getModerationActionsForUser(
    String classId,
    String userId,
  ) {
    final query = _db.select(_db.moderationActionsTable)
      ..where(
        (tbl) => tbl.classId.equals(classId) & tbl.targetUserId.equals(userId),
      )
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]);
    return query.get();
  }

  Future<void> updateModerationActionStatus(String id, String status) {
    return (_db.update(_db.moderationActionsTable)
          ..where((tbl) => tbl.id.equals(id)))
        .write(
      ModerationActionsTableCompanion(
        status: Value(status),
      ),
    );
  }
}
