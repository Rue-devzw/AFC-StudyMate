import 'package:drift/drift.dart';

import '../app_database.dart';

class SyncDao {
  SyncDao(this._db);

  final AppDatabase _db;

  Stream<List<SyncQueueData>> watchQueue() {
    return _db.select(_db.syncQueue).watch();
  }

  Future<void> enqueue(SyncQueueCompanion companion) {
    return _db.into(_db.syncQueue).insertOnConflictUpdate(companion);
  }

  Future<void> markAttempt(String id) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return _db.customStatement(
      'UPDATE sync_queue SET attempts = attempts + 1, last_tried_at = ? WHERE id = ?',
      [now, id],
    );
  }

  Future<void> remove(String id) {
    return (_db.delete(_db.syncQueue)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<bool> hasOperation(String userId, String opType) async {
    final query = _db.select(_db.syncQueue)
      ..where((tbl) => tbl.userId.equals(userId) & tbl.opType.equals(opType))
      ..limit(1);
    final result = await query.getSingleOrNull();
    return result != null;
  }
}
