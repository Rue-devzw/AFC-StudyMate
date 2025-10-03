import 'entities.dart';
import 'repositories.dart';

class WatchLessonsUseCase {
  final LessonRepository _repository;

  const WatchLessonsUseCase(this._repository);

  Stream<List<Lesson>> call() => _repository.watchLessons();
}

class GetLessonsUseCase {
  final LessonRepository _repository;

  const GetLessonsUseCase(this._repository);

  Future<List<Lesson>> call() => _repository.getLessons();
}

class GetLessonUseCase {
  final LessonRepository _repository;

  const GetLessonUseCase(this._repository);

  Future<Lesson?> call(String id) => _repository.getLessonById(id);
}

class WatchLessonProgressUseCase {
  final LessonRepository _repository;

  const WatchLessonProgressUseCase(this._repository);

  Stream<List<LessonProgress>> call(String userId) =>
      _repository.watchProgress(userId);
}

class UpdateProgressUseCase {
  final LessonRepository _repository;

  const UpdateProgressUseCase(this._repository);

  Future<void> call(LessonProgress progress) =>
      _repository.upsertProgress(progress);
}
