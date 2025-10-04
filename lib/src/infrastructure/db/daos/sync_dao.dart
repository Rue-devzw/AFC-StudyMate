import 'dart:convert';

import 'package:drift/drift.dart';

import '../app_database.dart';

class SyncDao {
  SyncDao(this._db);

  final AppDatabase _db;

  Stream<List<SyncQueueData>> watchQueue() {
    return _db.select(_db.syncQueue).watch();
  }

  Future<int> queueCount() async {
    final query = _db.selectOnly(_db.syncQueue)..addColumns([_db.syncQueue.id.count()]);
    final result = await query.getSingle();
    return result.read<int>('COUNT(*)') ?? 0;
  }

  Future<List<SyncQueueData>> pendingOps({int limit = 50}) {
    final query = (_db.select(_db.syncQueue)
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)])
          ..limit(limit))
        .get();
    return query;
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

  Future<void> markAttempts(Iterable<String> ids) async {
    if (ids.isEmpty) {
      return;
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.batch((batch) {
      for (final id in ids) {
        batch.customStatement(
          'UPDATE sync_queue SET attempts = attempts + 1, last_tried_at = ? WHERE id = ?',
          [now, id],
        );
      }
    });
  }

  Future<void> remove(String id) {
    return (_db.delete(_db.syncQueue)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> removeMany(Iterable<String> ids) {
    if (ids.isEmpty) {
      return Future.value();
    }
    return (_db.delete(_db.syncQueue)
          ..where((tbl) => tbl.id.isIn(ids.toList())))
        .go();
  }

  Future<bool> hasOperation(String userId, String opType) async {
    final query = _db.select(_db.syncQueue)
      ..where((tbl) => tbl.userId.equals(userId) & tbl.opType.equals(opType))
      ..limit(1);
    final result = await query.getSingleOrNull();
    return result != null;
  }

  Future<void> recordNoteChange({
    required String noteId,
    required String userId,
    required int localUpdatedAt,
    required String operation,
  }) async {
    final existing = await (_db.select(_db.noteChangeTrackers)
          ..where((tbl) => tbl.noteId.equals(noteId)))
        .getSingleOrNull();
    final companion = NoteChangeTrackersCompanion(
      noteId: Value(noteId),
      userId: Value(userId),
      localUpdatedAt: Value(localUpdatedAt),
      lastOperation: Value(operation),
      status: const Value('pending'),
      conflictReason: const Value<String?>(null),
      conflictPayload: const Value<String?>(null),
      conflictDetectedAt: const Value<int?>(null),
    );
    if (existing == null) {
      await _db.into(_db.noteChangeTrackers).insert(
            NoteChangeTrackersCompanion.insert(
              noteId: noteId,
              userId: userId,
              localUpdatedAt: Value(localUpdatedAt),
              lastOperation: Value(operation),
            ),
            mode: InsertMode.insertOrReplace,
          );
    } else {
      await (_db.update(_db.noteChangeTrackers)
            ..where((tbl) => tbl.noteId.equals(noteId)))
          .write(companion);
    }
  }

  Future<void> recordProgressChange({
    required String progressId,
    required String userId,
    required int localUpdatedAt,
    required String operation,
  }) async {
    final existing = await (_db.select(_db.progressChangeTrackers)
          ..where((tbl) => tbl.progressId.equals(progressId)))
        .getSingleOrNull();
    final companion = ProgressChangeTrackersCompanion(
      progressId: Value(progressId),
      userId: Value(userId),
      localUpdatedAt: Value(localUpdatedAt),
      lastOperation: Value(operation),
      status: const Value('pending'),
      conflictReason: const Value<String?>(null),
      conflictPayload: const Value<String?>(null),
      conflictDetectedAt: const Value<int?>(null),
    );
    if (existing == null) {
      await _db.into(_db.progressChangeTrackers).insert(
            ProgressChangeTrackersCompanion.insert(
              progressId: progressId,
              userId: userId,
              localUpdatedAt: Value(localUpdatedAt),
              lastOperation: Value(operation),
            ),
            mode: InsertMode.insertOrReplace,
          );
    } else {
      await (_db.update(_db.progressChangeTrackers)
            ..where((tbl) => tbl.progressId.equals(progressId)))
          .write(companion);
    }
  }

  Future<void> recordMessageChange({
    required String messageId,
    required String userId,
    required int localUpdatedAt,
    required String operation,
  }) async {
    final existing = await (_db.select(_db.messageChangeTrackers)
          ..where((tbl) => tbl.messageId.equals(messageId)))
        .getSingleOrNull();
    final companion = MessageChangeTrackersCompanion(
      messageId: Value(messageId),
      userId: Value(userId),
      localUpdatedAt: Value(localUpdatedAt),
      lastOperation: Value(operation),
      status: const Value('pending'),
      conflictReason: const Value<String?>(null),
      conflictPayload: const Value<String?>(null),
      conflictDetectedAt: const Value<int?>(null),
    );
    if (existing == null) {
      await _db.into(_db.messageChangeTrackers).insert(
            MessageChangeTrackersCompanion.insert(
              messageId: messageId,
              userId: userId,
              localUpdatedAt: Value(localUpdatedAt),
              lastOperation: Value(operation),
            ),
            mode: InsertMode.insertOrReplace,
          );
    } else {
      await (_db.update(_db.messageChangeTrackers)
            ..where((tbl) => tbl.messageId.equals(messageId)))
          .write(companion);
    }
  }

  Future<void> markNoteSynced(String noteId, int remoteUpdatedAt,
      {String? userId}) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final rows = await (_db.update(_db.noteChangeTrackers)
          ..where((tbl) => tbl.noteId.equals(noteId)))
        .write(
      NoteChangeTrackersCompanion(
        localUpdatedAt: Value(remoteUpdatedAt),
        remoteUpdatedAt: Value(remoteUpdatedAt),
        lastSyncedAt: Value(now),
        status: const Value('synced'),
        conflictReason: const Value<String?>(null),
        conflictPayload: const Value<String?>(null),
        conflictDetectedAt: const Value<int?>(null),
      ),
    );
    if (rows == 0 && userId != null) {
      await _db.into(_db.noteChangeTrackers).insert(
            NoteChangeTrackersCompanion(
              noteId: Value(noteId),
              userId: Value(userId),
              localUpdatedAt: Value(remoteUpdatedAt),
              remoteUpdatedAt: Value(remoteUpdatedAt),
              lastSyncedAt: Value(now),
              status: const Value('synced'),
              lastOperation: const Value('upsert'),
              conflictReason: const Value<String?>(null),
              conflictPayload: const Value<String?>(null),
              conflictDetectedAt: const Value<int?>(null),
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
  }

  Future<void> markProgressSynced(String progressId, int remoteUpdatedAt,
      {String? userId}) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final rows = await (_db.update(_db.progressChangeTrackers)
          ..where((tbl) => tbl.progressId.equals(progressId)))
        .write(
      ProgressChangeTrackersCompanion(
        localUpdatedAt: Value(remoteUpdatedAt),
        remoteUpdatedAt: Value(remoteUpdatedAt),
        lastSyncedAt: Value(now),
        status: const Value('synced'),
        conflictReason: const Value<String?>(null),
        conflictPayload: const Value<String?>(null),
        conflictDetectedAt: const Value<int?>(null),
      ),
    );
    if (rows == 0 && userId != null) {
      await _db.into(_db.progressChangeTrackers).insert(
            ProgressChangeTrackersCompanion(
              progressId: Value(progressId),
              userId: Value(userId),
              localUpdatedAt: Value(remoteUpdatedAt),
              remoteUpdatedAt: Value(remoteUpdatedAt),
              lastSyncedAt: Value(now),
              status: const Value('synced'),
              lastOperation: const Value('upsert'),
              conflictReason: const Value<String?>(null),
              conflictPayload: const Value<String?>(null),
              conflictDetectedAt: const Value<int?>(null),
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
  }

  Future<void> markMessageSynced(String messageId, int remoteUpdatedAt,
      {String? userId}) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final rows = await (_db.update(_db.messageChangeTrackers)
          ..where((tbl) => tbl.messageId.equals(messageId)))
        .write(
      MessageChangeTrackersCompanion(
        localUpdatedAt: Value(remoteUpdatedAt),
        remoteUpdatedAt: Value(remoteUpdatedAt),
        lastSyncedAt: Value(now),
        status: const Value('synced'),
        conflictReason: const Value<String?>(null),
        conflictPayload: const Value<String?>(null),
        conflictDetectedAt: const Value<int?>(null),
      ),
    );
    if (rows == 0 && userId != null) {
      await _db.into(_db.messageChangeTrackers).insert(
            MessageChangeTrackersCompanion(
              messageId: Value(messageId),
              userId: Value(userId),
              localUpdatedAt: Value(remoteUpdatedAt),
              remoteUpdatedAt: Value(remoteUpdatedAt),
              lastSyncedAt: Value(now),
              status: const Value('synced'),
              lastOperation: const Value('upsert'),
              conflictReason: const Value<String?>(null),
              conflictPayload: const Value<String?>(null),
              conflictDetectedAt: const Value<int?>(null),
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
  }

  Future<void> markNoteConflict(
    String noteId, {
    required String reason,
    Map<String, dynamic>? remoteSnapshot,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return (_db.update(_db.noteChangeTrackers)
          ..where((tbl) => tbl.noteId.equals(noteId)))
        .write(
      NoteChangeTrackersCompanion(
        status: const Value('conflict'),
        conflictReason: Value(reason),
        conflictPayload: Value(remoteSnapshot == null ? null : json.encode(remoteSnapshot)),
        conflictDetectedAt: Value(now),
      ),
    );
  }

  Future<void> markProgressConflict(
    String progressId, {
    required String reason,
    Map<String, dynamic>? remoteSnapshot,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return (_db.update(_db.progressChangeTrackers)
          ..where((tbl) => tbl.progressId.equals(progressId)))
        .write(
      ProgressChangeTrackersCompanion(
        status: const Value('conflict'),
        conflictReason: Value(reason),
        conflictPayload: Value(remoteSnapshot == null ? null : json.encode(remoteSnapshot)),
        conflictDetectedAt: Value(now),
      ),
    );
  }

  Future<void> markMessageConflict(
    String messageId, {
    required String reason,
    Map<String, dynamic>? remoteSnapshot,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return (_db.update(_db.messageChangeTrackers)
          ..where((tbl) => tbl.messageId.equals(messageId)))
        .write(
      MessageChangeTrackersCompanion(
        status: const Value('conflict'),
        conflictReason: Value(reason),
        conflictPayload: Value(remoteSnapshot == null ? null : json.encode(remoteSnapshot)),
        conflictDetectedAt: Value(now),
      ),
    );
  }

  Stream<List<NoteChangeTracker>> watchNoteConflicts() {
    final query = _db.select(_db.noteChangeTrackers)
      ..where((tbl) => tbl.status.equals('conflict'));
    return query.watch();
  }

  Stream<List<ProgressChangeTracker>> watchProgressConflicts() {
    final query = _db.select(_db.progressChangeTrackers)
      ..where((tbl) => tbl.status.equals('conflict'));
    return query.watch();
  }

  Stream<List<MessageChangeTracker>> watchMessageConflicts() {
    final query = _db.select(_db.messageChangeTrackers)
      ..where((tbl) => tbl.status.equals('conflict'));
    return query.watch();
  }
}
