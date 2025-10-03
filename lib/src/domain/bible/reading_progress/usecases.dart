import 'entities.dart';
import 'repositories.dart';

class WatchReadingProgressUseCase {
  const WatchReadingProgressUseCase(this._repository);

  final ReadingProgressRepository _repository;

  Stream<ReadingPosition?> call() => _repository.watch();
}

class GetLastReadingPositionUseCase {
  const GetLastReadingPositionUseCase(this._repository);

  final ReadingProgressRepository _repository;

  Future<ReadingPosition?> call() => _repository.getLastPosition();
}

class SaveReadingProgressUseCase {
  const SaveReadingProgressUseCase(this._repository);

  final ReadingProgressRepository _repository;

  Future<void> call(ReadingPosition position) =>
      _repository.savePosition(position);
}
