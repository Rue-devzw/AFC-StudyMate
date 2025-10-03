import 'entities.dart';

abstract class LessonRepository {
  Stream<List<Lesson>> watchLessons();
  Future<List<Lesson>> getLessons();
  Future<Lesson?> getLessonById(String id);
  Stream<List<LessonProgress>> watchProgress(String userId);
  Future<void> upsertProgress(LessonProgress progress);
}
