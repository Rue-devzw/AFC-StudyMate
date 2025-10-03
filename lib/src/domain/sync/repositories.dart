import 'entities.dart';

abstract class SyncRepository {
  Stream<List<SyncOperation>> watchQueue();
  Future<List<SyncOperation>> fetchPending({int limit});
  Future<void> enqueue(SyncOperation operation);
  Future<void> markAttempt(String id);
  Future<void> markAttempts(Iterable<String> ids);
  Future<void> remove(String id);
  Future<void> removeMany(Iterable<String> ids);
  Future<bool> hasOperation(String userId, String opType);
  Stream<List<SyncConflict>> watchConflicts();
}
