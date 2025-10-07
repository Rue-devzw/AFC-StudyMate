import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../drift/app_database.dart';
import '../models/enums.dart';
import '../models/lesson.dart';
import '../services/schedule_service.dart';

final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  return LessonRepository(
    database: ref.read(appDatabaseProvider),
    scheduleService: ref.read(scheduleServiceProvider),
  );
});

class LessonRepository {
  LessonRepository({required this.database, required this.scheduleService});

  final AppDatabase database;
  final ScheduleService scheduleService;

  Future<Lesson?> getCurrentSundayLesson(Track track) async {
    final lessons = await database.getLessonsByTrack(track);
    return lessons.firstWhere(
      (lesson) => lesson.weekIndex == scheduleService.currentSundayWeekIndex,
      orElse: () => lessons.isEmpty ? null : lessons.first,
    );
  }

  Future<Lesson?> getDiscoveryLesson() async {
    final lessons = await database.getLessonsByTrack(Track.discovery);
    return lessons.firstWhere(
      (lesson) => lesson.weekIndex == scheduleService.discoveryWeekIndex,
      orElse: () => lessons.isEmpty ? null : lessons.first,
    );
  }

  Future<Lesson?> getDaybreakLesson() async {
    final lessons = await database.getLessonsByTrack(Track.daybreak);
    return lessons.firstWhere(
      (lesson) => lesson.dayIndex == scheduleService.daybreakIndex,
      orElse: () => lessons.isEmpty ? null : lessons.first,
    );
  }

  Future<List<Lesson>> getLessonsForTrack(Track track) => database.getLessonsByTrack(track);

  Future<Lesson?> getLessonById(String id) => database.getLesson(id);
}
