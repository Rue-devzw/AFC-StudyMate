import 'dart:convert';

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../../domain/sync/entities.dart';
import '../../domain/sync/repositories.dart';
import '../../infrastructure/db/app_database.dart';
import '../../infrastructure/db/daos/sync_dao.dart';

class SyncRepositoryImpl implements SyncRepository {
  SyncRepositoryImpl(this._db, this._dao);

  final AppDatabase _db;
  final SyncDao _dao;

  Future<void> _ensureSeeded() => _db.ensureSeeded();

  @override
  Stream<List<SyncOperation>> watchQueue() async* {
    await _ensureSeeded();
    yield* _dao.watchQueue().map(_mapList);
  }

  @override
  Future<List<SyncOperation>> fetchPending({int limit = 50}) async {
    await _ensureSeeded();
    final rows = await _dao.pendingOps(limit: limit);
    return _mapList(rows);
  }

  @override
  Future<void> enqueue(SyncOperation operation) async {
    await _ensureSeeded();
    final companion = SyncQueueCompanion(
      id: Value(operation.id.isEmpty ? const Uuid().v4() : operation.id),
      userId: Value(operation.userId),
      opType: Value(operation.opType),
      payload: Value(json.encode(operation.payload)),
      createdAt: Value(operation.createdAt.millisecondsSinceEpoch),
      lastTriedAt: Value(operation.lastTriedAt?.millisecondsSinceEpoch),
      attempts: Value(operation.attempts),
    );
    await _dao.enqueue(companion);
  }

  @override
  Future<void> markAttempt(String id) async {
    await _ensureSeeded();
    await _dao.markAttempt(id);
  }

  @override
  Future<void> markAttempts(Iterable<String> ids) async {
    await _ensureSeeded();
    await _dao.markAttempts(ids);
  }

  @override
  Future<void> remove(String id) async {
    await _ensureSeeded();
    await _dao.remove(id);
  }

  @override
  Future<void> removeMany(Iterable<String> ids) async {
    await _ensureSeeded();
    await _dao.removeMany(ids);
  }

  @override
  Future<bool> hasOperation(String userId, String opType) async {
    await _ensureSeeded();
    return _dao.hasOperation(userId, opType);
  }

  @override
  Stream<List<SyncConflict>> watchConflicts() async* {
    await _ensureSeeded();
    yield* Rx.combineLatest3(
      _dao.watchNoteConflicts(),
      _dao.watchProgressConflicts(),
      _dao.watchMessageConflicts(),
      (
        List<NoteChangeTrackerData> noteRows,
        List<ProgressChangeTrackerData> progressRows,
        List<MessageChangeTrackerData> messageRows,
      ) {
        final conflicts = <SyncConflict>[];
        conflicts.addAll(noteRows.map(_mapNoteConflict));
        conflicts.addAll(progressRows.map(_mapProgressConflict));
        conflicts.addAll(messageRows.map(_mapMessageConflict));
        conflicts.sort((a, b) => b.detectedAt.compareTo(a.detectedAt));
        return conflicts;
      },
    );
  }

  List<SyncOperation> _mapList(List<SyncQueueData> rows) {
    return rows
        .map(
          (row) => SyncOperation(
            id: row.id,
            userId: row.userId,
            opType: row.opType,
            payload: Map<String, dynamic>.from(json.decode(row.payload) as Map),
            createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
            lastTriedAt: row.lastTriedAt == null
                ? null
                : DateTime.fromMillisecondsSinceEpoch(row.lastTriedAt!),
            attempts: row.attempts,
          ),
        )
        .toList();
  }

  SyncConflict _mapNoteConflict(NoteChangeTrackerData row) {
    return SyncConflict(
      entityType: SyncEntityType.note,
      entityId: row.noteId,
      userId: row.userId,
      reason: row.conflictReason ?? 'conflict',
      remoteSnapshot: _decodePayload(row.conflictPayload),
      detectedAt: _resolveTimestamp(row.conflictDetectedAt, row.localUpdatedAt),
    );
  }

  SyncConflict _mapProgressConflict(ProgressChangeTrackerData row) {
    return SyncConflict(
      entityType: SyncEntityType.progress,
      entityId: row.progressId,
      userId: row.userId,
      reason: row.conflictReason ?? 'conflict',
      remoteSnapshot: _decodePayload(row.conflictPayload),
      detectedAt: _resolveTimestamp(row.conflictDetectedAt, row.localUpdatedAt),
    );
  }

  SyncConflict _mapMessageConflict(MessageChangeTrackerData row) {
    return SyncConflict(
      entityType: SyncEntityType.message,
      entityId: row.messageId,
      userId: row.userId,
      reason: row.conflictReason ?? 'conflict',
      remoteSnapshot: _decodePayload(row.conflictPayload),
      detectedAt: _resolveTimestamp(row.conflictDetectedAt, row.localUpdatedAt),
    );
  }

  Map<String, dynamic>? _decodePayload(String? payload) {
    if (payload == null || payload.isEmpty) {
      return null;
    }
    try {
      final decoded = json.decode(payload);
      return decoded is Map<String, dynamic>
          ? decoded
          : Map<String, dynamic>.from(decoded as Map);
    } catch (_) {
      return null;
    }
  }

  DateTime _resolveTimestamp(int? conflictDetectedAt, int fallbackMs) {
    final milliseconds = conflictDetectedAt ?? fallbackMs;
    return DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: false);
  }
}
