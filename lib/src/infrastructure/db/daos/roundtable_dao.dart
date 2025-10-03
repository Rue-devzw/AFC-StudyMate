import 'package:drift/drift.dart';

import '../app_database.dart';

class RoundtableDao {
  RoundtableDao(this._db);

  final AppDatabase _db;

  Stream<List<RoundtableRow>> watchUpcoming(String? classId) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final query = _db.select(_db.roundtableEvents)
      ..where((tbl) => tbl.endTime.isBiggerOrEqualValue(now));
    if (classId != null) {
      query.where((tbl) => tbl.classId.equals(classId) | tbl.classId.isNull());
    }
    query.orderBy([(tbl) => OrderingTerm.asc(tbl.startTime)]);
    return query.watch();
  }

  Future<List<RoundtableRow>> fetchAll(String? classId) {
    final query = _db.select(_db.roundtableEvents);
    if (classId != null) {
      query.where((tbl) => tbl.classId.equals(classId) | tbl.classId.isNull());
    }
    query.orderBy([(tbl) => OrderingTerm.asc(tbl.startTime)]);
    return query.get();
  }

  Future<void> upsertEvent(RoundtableEventsCompanion companion) {
    return _db.into(_db.roundtableEvents).insertOnConflictUpdate(companion);
  }

  Future<void> deleteEvent(String id) {
    return (_db.delete(_db.roundtableEvents)..where((tbl) => tbl.id.equals(id))).go();
  }
}
