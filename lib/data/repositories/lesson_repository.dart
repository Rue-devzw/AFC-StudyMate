import 'package:collection/collection.dart';
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
    if (lessons.isEmpty) {
      return null;
    }

    final sortedLessons = lessons.toList()
      ..sort((a, b) => (a.weekIndex ?? 0).compareTo(b.weekIndex ?? 0));
    final targetWeek = scheduleService.weekIndexForTrack(track);

    final matchingLesson = sortedLessons.firstWhereOrNull(
      (lesson) => (lesson.weekIndex ?? -1) == targetWeek,
    );

    if (matchingLesson != null) {
      return matchingLesson;
    }

    return sortedLessons.firstWhereOrNull((lesson) => (lesson.weekIndex ?? 0) > targetWeek) ??
        sortedLessons.last;
  }

  Future<Lesson?> getDiscoveryLesson() async {
    final lessons = await database.getLessonsByTrack(Track.discovery);
    final matchingLesson = lessons.firstWhereOrNull(
      (lesson) => lesson.weekIndex == scheduleService.discoveryWeekIndex,
    );

    if (matchingLesson != null) {
      return matchingLesson;
    }

    if (lessons.isEmpty) {
      return null;
    }

    return lessons.first;
  }

  Future<Lesson?> getDaybreakLesson() async {
    final lessons = await database.getLessonsByTrack(Track.daybreak);
    final matchingLesson = lessons.firstWhereOrNull(
      (lesson) => lesson.dayIndex == scheduleService.daybreakIndex,
    );

    if (matchingLesson != null) {
      return matchingLesson;
    }

    if (lessons.isEmpty) {
      return null;
    }

    return lessons.first;
  }

  Future<List<Lesson>> getLessonsForTrack(Track track) => database.getLessonsByTrack(track);

  Future<Lesson?> getLessonById(String id) => database.getLesson(id);
}
