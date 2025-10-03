import 'dart:convert';

import 'package:drift/drift.dart';
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
  Future<void> markAttempt(String id) {
    return _dao.markAttempt(id);
  }

  @override
  Future<void> remove(String id) {
    return _dao.remove(id);
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
}
