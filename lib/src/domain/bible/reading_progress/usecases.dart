import 'entities.dart';
import 'repositories.dart';

class WatchReadingProgressUseCase {
  const WatchReadingProgressUseCase(this._repository);

  final ReadingProgressRepository _repository;

  Stream<ReadingPosition?> call(String userId) => _repository.watch(userId);
}

class GetLastReadingPositionUseCase {
  const GetLastReadingPositionUseCase(this._repository);

  final ReadingProgressRepository _repository;

  Future<ReadingPosition?> call(String userId) =>
      _repository.getLastPosition(userId);
}

class SaveReadingProgressUseCase {
  const SaveReadingProgressUseCase(this._repository);

  final ReadingProgressRepository _repository;

  Future<void> call(String userId, ReadingPosition position) =>
      _repository.savePosition(userId, position);
}
