import 'entities.dart';

abstract class LessonRepository {
  Stream<List<Lesson>> watchLessons({LessonQuery? filter});
  Future<List<Lesson>> getLessons({LessonQuery? filter});
  Future<Lesson?> getLessonById(String id);
  Stream<List<LessonProgress>> watchProgress(String userId);
  Future<void> upsertProgress(LessonProgress progress);
}
