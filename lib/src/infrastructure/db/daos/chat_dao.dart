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
}
