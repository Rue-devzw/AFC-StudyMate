import 'package:afc_studymate/data/drift/app_database.dart';
import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/lesson.dart';
import 'package:afc_studymate/data/services/schedule_service.dart';
import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

    final override = _resolveCurrentLessonOverride(track, lessons);
    if (override != null) {
      return override;
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

    return sortedLessons.firstWhereOrNull(
          (lesson) => (lesson.weekIndex ?? 0) > targetWeek,
        ) ??
        sortedLessons.last;
  }

  Lesson? _resolveCurrentLessonOverride(Track track, List<Lesson> lessons) {
    switch (track) {
      case Track.primaryPals:
        // Dataset currently does not contain 19a; include a stable fallback.
        return _firstByIdOrDisplayNumber(
          lessons,
          ids: const {'19a', 'primary_pals_lesson_19a', '20a'},
          displayNumbers: const {19, 20},
        );
      case Track.answer:
        return _firstByIdOrDisplayNumber(
          lessons,
          ids: const {'answer_79'},
          displayNumbers: const {79},
        );
      case Track.search:
        return _firstByIdOrDisplayNumber(
          lessons,
          ids: const {'lesson_79', 'search_lesson_79'},
          displayNumbers: const {79},
        );
      default:
        return null;
    }
  }

  Lesson? _firstByIdOrDisplayNumber(
    List<Lesson> lessons, {
    required Set<String> ids,
    required Set<int> displayNumbers,
  }) {
    for (final lesson in lessons) {
      if (ids.contains(lesson.id.toLowerCase())) {
        return lesson;
      }
      final number = lesson.displayNumber;
      if (number != null && displayNumbers.contains(number)) {
        return lesson;
      }
    }
    return null;
  }

  Future<Lesson?> getDiscoveryLesson() async {
    final lessons = await database.getLessonsByTrack(Track.discovery);
    if (lessons.isEmpty) {
      return null;
    }

    final sortedLessons = lessons.toList()
      ..sort((a, b) => (a.weekIndex ?? 0).compareTo(b.weekIndex ?? 0));
    final targetWeek = scheduleService.discoveryWeekIndex;

    final exactMatch = sortedLessons.firstWhereOrNull(
      (lesson) => lesson.weekIndex == targetWeek,
    );
    if (exactMatch != null && _isUsableDiscoveryLesson(exactMatch)) {
      return exactMatch;
    }

    final nextUsable = sortedLessons.firstWhereOrNull(
      (lesson) =>
          (lesson.weekIndex ?? -1) >= targetWeek &&
          _isUsableDiscoveryLesson(lesson),
    );
    if (nextUsable != null) {
      return nextUsable;
    }

    return sortedLessons.firstWhereOrNull(_isUsableDiscoveryLesson) ??
        sortedLessons.first;
  }

  bool _isUsableDiscoveryLesson(Lesson lesson) {
    if (lesson.track != Track.discovery) {
      return true;
    }
    final title = lesson.title.trim().toUpperCase();
    if (title == 'UNIT') {
      return false;
    }
    final payload = lesson.payload;
    final questions = payload['questions'] as List<dynamic>? ?? <dynamic>[];
    final hasAnyBodyContent =
        (payload['background'] as String? ?? '').trim().isNotEmpty ||
        (payload['conclusion'] as String? ?? '').trim().isNotEmpty ||
        (payload['keyVerse'] as String? ?? '').trim().isNotEmpty ||
        questions.isNotEmpty ||
        lesson.bibleReferences.isNotEmpty;
    return hasAnyBodyContent;
  }

  Future<Lesson?> getDaybreakLesson() async {
    return getDaybreakLessonForDate(DateTime.now());
  }

  Future<Lesson?> getDaybreakLessonForDate(DateTime date) async {
    final lessons = await database.getLessonsByTrack(Track.daybreak);
    if (lessons.isEmpty) {
      return null;
    }
    final targetIndex =
        scheduleService.daybreakIndexForDate(date) % lessons.length;
    final matchingLesson = lessons.firstWhereOrNull(
      (lesson) => lesson.dayIndex == targetIndex,
    );

    if (matchingLesson != null) {
      return matchingLesson;
    }

    if (lessons.isEmpty) {
      return null;
    }

    return lessons.first;
  }

  Future<List<Lesson>> getLessonsForTrack(Track track) =>
      database.getLessonsByTrack(track);

  Future<Lesson?> getLessonById(String id) => database.getLesson(id);
}
