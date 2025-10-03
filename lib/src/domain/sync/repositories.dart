import 'entities.dart';

abstract class SyncRepository {
  Stream<List<SyncOperation>> watchQueue();
  Future<void> enqueue(SyncOperation operation);
  Future<void> markAttempt(String id);
  Future<void> remove(String id);
}
