import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/meetings/entities.dart';
import '../../domain/meetings/repositories.dart';
import '../../infrastructure/db/app_database.dart';
import '../../infrastructure/db/daos/meeting_link_dao.dart';

class MeetingRepositoryImpl implements MeetingRepository {
  MeetingRepositoryImpl(this._db, this._dao);

  final AppDatabase _db;
  final MeetingLinkDao _dao;
  final _uuid = const Uuid();

  Future<void> _ensureSeeded() => _db.ensureSeeded();

  @override
  Stream<List<MeetingLink>> watchLinks(
    MeetingContextType contextType,
    String contextId, {
    MeetingRole? role,
  }) async* {
    await _ensureSeeded();
    yield* _dao
        .watchByContext(contextType.storageValue, contextId,
            role: role?.storageValue)
        .map(_mapLinks);
  }

  @override
  Stream<List<MeetingLink>> watchPendingReminders() async* {
    await _ensureSeeded();
    yield* _dao.watchPendingReminders().map(_mapLinks);
  }

  @override
  Future<List<MeetingLink>> fetchLinks(
    MeetingContextType contextType,
    String contextId, {
    MeetingRole? role,
  }) async {
    await _ensureSeeded();
    final rows = await _dao.fetchByContext(
      contextType.storageValue,
      contextId,
      role: role?.storageValue,
    );
    return _mapLinks(rows);
  }

  @override
  Future<void> saveLink(MeetingLink link) async {
    await _ensureSeeded();
    final companion = MeetingLinksCompanion(
      id: Value(link.id.isEmpty ? _uuid.v4() : link.id),
      contextType: Value(link.contextType.storageValue),
      contextId: Value(link.contextId),
      roomName: Value(link.roomName),
      role: Value(link.role.storageValue),
      url: Value(link.url.toString()),
      title: Value(link.title),
      createdAt: Value(link.createdAt.millisecondsSinceEpoch),
      scheduledStart: Value(link.scheduledStart?.millisecondsSinceEpoch),
      reminderAt: Value(link.reminderAt?.millisecondsSinceEpoch),
      reminderScheduled: Value(link.reminderScheduled),
      recordingStoragePath: Value(link.recordingStoragePath),
      recordingUrl: Value(link.recordingUrl?.toString()),
      recordingIndexedAt:
          Value(link.recordingIndexedAt?.millisecondsSinceEpoch),
    );
    await _dao.upsert(companion);
  }

  @override
  Future<void> markReminderScheduled(String id) async {
    await _ensureSeeded();
    await _dao.markReminderScheduled(id);
  }

  @override
  Future<void> saveRecording(
    MeetingContextType contextType,
    String contextId, {
    required Uri recordingUrl,
    required String storagePath,
    DateTime? indexedAt,
  }) async {
    await _ensureSeeded();
    await _dao.saveRecording(
      contextType.storageValue,
      contextId,
      recordingUrl: recordingUrl.toString(),
      storagePath: storagePath,
      indexedAt: indexedAt?.millisecondsSinceEpoch,
    );
  }

  List<MeetingLink> _mapLinks(List<MeetingLinkRow> rows) {
    return rows
        .map(
          (row) => MeetingLink(
            id: row.id,
            contextType: MeetingContextTypeX.fromStorage(row.contextType),
            contextId: row.contextId,
            roomName: row.roomName,
            role: MeetingRoleX.fromStorage(row.role),
            url: Uri.parse(row.url),
            title: row.title,
            createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
            scheduledStart: row.scheduledStart == null
                ? null
                : DateTime.fromMillisecondsSinceEpoch(row.scheduledStart!),
            reminderAt: row.reminderAt == null
                ? null
                : DateTime.fromMillisecondsSinceEpoch(row.reminderAt!),
            reminderScheduled: row.reminderScheduled,
            recordingStoragePath: row.recordingStoragePath,
            recordingUrl: row.recordingUrl == null
                ? null
                : Uri.tryParse(row.recordingUrl!),
            recordingIndexedAt: row.recordingIndexedAt == null
                ? null
                : DateTime.fromMillisecondsSinceEpoch(row.recordingIndexedAt!),
          ),
        )
        .toList();
  }
}
