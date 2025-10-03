import '../../domain/lessons/entities.dart';
import '../../domain/lessons/repositories.dart';
import '../../domain/sync/entities.dart';
import '../../domain/sync/repositories.dart';
import '../../infrastructure/db/app_database.dart';
import '../../infrastructure/db/daos/roundtable_dao.dart';

class RoundtableRepositoryImpl implements RoundtableRepository {
  RoundtableRepositoryImpl(
    this._db,
    this._dao,
    this._syncRepository,
  );

  final AppDatabase _db;
  final RoundtableDao _dao;
  final SyncRepository _syncRepository;

  Future<void> _ensureSeeded() => _db.ensureSeeded();

  @override
  Stream<List<RoundtableSession>> watchUpcoming(String? classId) async* {
    await _ensureSeeded();
    yield* _dao.watchUpcoming(classId).map(_mapSessions);
  }

  @override
  Future<void> saveSession(RoundtableSession session) async {
    await _ensureSeeded();
    await _dao.upsertEvent(
      RoundtableEventsCompanion(
        id: Value(session.id),
        title: Value(session.title),
        description: Value(session.description),
        classId: Value(session.classId),
        startTime: Value(session.startTime.millisecondsSinceEpoch),
        endTime: Value(session.endTime.millisecondsSinceEpoch),
        conferencingUrl: Value(session.conferencingUrl),
        reminderMinutesBefore: Value(session.reminderMinutesBefore),
        createdBy: Value(session.createdBy),
        updatedAt: Value(session.updatedAt.millisecondsSinceEpoch),
      ),
    );
    await _syncRepository.enqueue(
      SyncOperation(
        id: 'roundtable:${session.id}',
        userId: session.createdBy,
        opType: 'roundtable.upsert',
        payload: {
          'id': session.id,
          'title': session.title,
          'description': session.description,
          'classId': session.classId,
          'startTime': session.startTime.toIso8601String(),
          'endTime': session.endTime.toIso8601String(),
          'conferencingUrl': session.conferencingUrl,
          'reminderMinutesBefore': session.reminderMinutesBefore,
          'updatedAt': session.updatedAt.millisecondsSinceEpoch,
        },
        createdAt: session.updatedAt,
      ),
    );
  }

  @override
  Future<void> cancelSession(String id) async {
    await _ensureSeeded();
    await _dao.deleteEvent(id);
    await _syncRepository.enqueue(
      SyncOperation(
        id: 'roundtable:$id:cancel',
        userId: 'system',
        opType: 'roundtable.cancel',
        payload: {
          'id': id,
        },
        createdAt: DateTime.now(),
      ),
    );
  }

  List<RoundtableSession> _mapSessions(List<RoundtableRow> rows) {
    return rows
        .map(
          (row) => RoundtableSession(
            id: row.id,
            title: row.title,
            description: row.description,
            classId: row.classId,
            startTime: DateTime.fromMillisecondsSinceEpoch(row.startTime),
            endTime: DateTime.fromMillisecondsSinceEpoch(row.endTime),
            conferencingUrl: row.conferencingUrl,
            reminderMinutesBefore: row.reminderMinutesBefore,
            createdBy: row.createdBy,
            updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
          ),
        )
        .toList();
  }
}
