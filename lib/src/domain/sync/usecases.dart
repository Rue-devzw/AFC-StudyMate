import 'entities.dart';
import 'repositories.dart';

class WatchSyncQueueUseCase {
  final SyncRepository _repository;

  const WatchSyncQueueUseCase(this._repository);

  Stream<List<SyncOperation>> call() => _repository.watchQueue();
}

class EnqueueSyncOperationUseCase {
  final SyncRepository _repository;

  const EnqueueSyncOperationUseCase(this._repository);

  Future<void> call(SyncOperation operation) =>
      _repository.enqueue(operation);
}

class MarkSyncAttemptUseCase {
  final SyncRepository _repository;

  const MarkSyncAttemptUseCase(this._repository);

  Future<void> call(String id) => _repository.markAttempt(id);
}

class RemoveSyncOperationUseCase {
  final SyncRepository _repository;

  const RemoveSyncOperationUseCase(this._repository);

  Future<void> call(String id) => _repository.remove(id);
}
