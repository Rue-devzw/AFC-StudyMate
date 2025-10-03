import 'package:drift/drift.dart';

import '../app_database.dart';

class MeetingLinkDao {
  MeetingLinkDao(this._db);

  final AppDatabase _db;

  Future<void> upsert(MeetingLinksCompanion companion) {
    return _db.into(_db.meetingLinks).insertOnConflictUpdate(companion);
  }

  Stream<List<MeetingLinkRow>> watchByContext(
    String contextType,
    String contextId, {
    String? role,
  }) {
    final query = _db.select(_db.meetingLinks)
      ..where((tbl) => tbl.contextType.equals(contextType))
      ..where((tbl) => tbl.contextId.equals(contextId));
    if (role != null) {
      query.where((tbl) => tbl.role.equals(role));
    }
    query.orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]);
    return query.watch();
  }

  Stream<List<MeetingLinkRow>> watchPendingReminders() {
    final query = _db.select(_db.meetingLinks)
      ..where((tbl) =>
          tbl.reminderAt.isNotNull() & tbl.reminderScheduled.equals(false));
    return query.watch();
  }

  Future<List<MeetingLinkRow>> fetchByContext(
    String contextType,
    String contextId, {
    String? role,
  }) {
    final query = _db.select(_db.meetingLinks)
      ..where((tbl) => tbl.contextType.equals(contextType))
      ..where((tbl) => tbl.contextId.equals(contextId));
    if (role != null) {
      query.where((tbl) => tbl.role.equals(role));
    }
    query.orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]);
    return query.get();
  }

  Future<void> markReminderScheduled(String id) {
    return (_db.update(_db.meetingLinks)..where((tbl) => tbl.id.equals(id)))
        .write(
      const MeetingLinksCompanion(reminderScheduled: Value(true)),
    );
  }

  Future<void> saveRecording(
    String contextType,
    String contextId, {
    required String recordingUrl,
    required String storagePath,
    int? indexedAt,
  }) {
    final query = _db.update(_db.meetingLinks)
      ..where((tbl) => tbl.contextType.equals(contextType))
      ..where((tbl) => tbl.contextId.equals(contextId));
    return query.write(
      MeetingLinksCompanion(
        recordingUrl: Value(recordingUrl),
        recordingStoragePath: Value(storagePath),
        recordingIndexedAt: Value(indexedAt),
      ),
    );
  }
}
