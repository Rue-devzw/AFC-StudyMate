import 'package:afc_studymate/data/drift/app_database.dart';
import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/progress.dart';
import 'package:afc_studymate/data/repositories/lesson_repository.dart';
import 'package:afc_studymate/data/services/analytics_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final progressServiceProvider = Provider<ProgressService>((ref) {
  return ProgressService(
    analyticsService: ref.read(analyticsServiceProvider),
    database: ref.read(appDatabaseProvider),
    lessonRepository: ref.read(lessonRepositoryProvider),
  );
});

class ProgressService {
  ProgressService({
    required this.analyticsService,
    required this.database,
    required this.lessonRepository,
  });

  final AnalyticsService analyticsService;
  final AppDatabase database;
  final LessonRepository lessonRepository;

  Future<void> recordCompletion({
    required String userId,
    required String lessonId,
    double? score,
  }) async {
    await recordComplete(
      userId: userId,
      lessonId: lessonId,
      track: _inferTrackFromLessonId(lessonId),
      score: score,
    );
  }

  Future<void> recordComplete({
    required String userId,
    required String lessonId,
    required Track track,
    DateTime? completedAt,
    double? score,
  }) async {
    final now = DateTime.now();
    final progressList = await getUserProgress(userId);
    final completed = completedAt ?? now;
    final streak = _calculateStreak(progressList, completed);

    final progress = Progress(
      userId: userId,
      lessonId: lessonId,
      completedAt: completed,
      score: score,
      streakCount: streak,
    );
    await database.upsertProgress(progress);
    await analyticsService.logLessonCompleted(
      lessonId: lessonId,
      track: track,
    );
  }

  Future<List<Progress>> getUserProgress(String userId) =>
      database.getProgressForUser(userId);

  Future<bool> isLessonCompleted(String userId, String lessonId) async {
    final progress = await getUserProgress(userId);
    return progress.any((p) => p.lessonId == lessonId);
  }

  int getStreak(List<Progress> progress) {
    return _calculateStreak(progress, DateTime.now());
  }

  int getBestStreak(List<Progress> progress) {
    if (progress.isEmpty) return 0;
    var maxStreak = 0;
    for (final p in progress) {
      if ((p.streakCount ?? 0) > maxStreak) {
        maxStreak = p.streakCount ?? 0;
      }
    }
    return maxStreak;
  }

  /// Returns the last [limit] progress entries sorted newest-first.
  List<Progress> getRecentActivity(List<Progress> progress, {int limit = 5}) {
    final sorted = List<Progress>.from(progress)
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
    return sorted.take(limit).toList();
  }

  /// Returns a map of Track → count of completed lessons.
  /// Uses lessonId prefix convention or falls back to a lookup.
  Future<Map<String, int>> getProgressCountByType(
    List<Progress> progress,
  ) async {
    final counts = <String, int>{};
    for (final p in progress) {
      // Attempt to look up the lesson to get its track name
      final lesson = await lessonRepository.getLessonById(p.lessonId);
      final label = lesson?.track.name ?? _inferType(p.lessonId);
      counts[label] = (counts[label] ?? 0) + 1;
    }
    return counts;
  }

  String _inferType(String lessonId) {
    if (lessonId.startsWith('search')) return Track.search.name;
    if (lessonId.startsWith('answer')) return Track.answer.name;
    if (lessonId.startsWith('beginners')) return Track.beginners.name;
    if (lessonId.startsWith('primary')) return Track.primaryPals.name;
    if (lessonId.startsWith('discovery')) return Track.discovery.name;
    if (lessonId.startsWith('daybreak')) return Track.daybreak.name;
    return 'Other';
  }

  Track _inferTrackFromLessonId(String lessonId) {
    if (lessonId.startsWith('search')) return Track.search;
    if (lessonId.startsWith('answer')) return Track.answer;
    if (lessonId.startsWith('beginners')) return Track.beginners;
    if (lessonId.startsWith('primary')) return Track.primaryPals;
    if (lessonId.startsWith('discovery')) return Track.discovery;
    if (lessonId.startsWith('daybreak')) return Track.daybreak;
    return Track.search;
  }

  int _calculateStreak(List<Progress> progress, DateTime relativeTo) {
    if (progress.isEmpty) return 0;

    final sorted = progress.toList()
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
    final uniqueDays =
        sorted
            .map(
              (p) => DateTime(
                p.completedAt.year,
                p.completedAt.month,
                p.completedAt.day,
              ),
            )
            .toSet()
            .toList()
          ..sort((a, b) => b.compareTo(a));

    var streak = 0;
    var currentDay = DateTime(
      relativeTo.year,
      relativeTo.month,
      relativeTo.day,
    );

    for (final day in uniqueDays) {
      if (day == currentDay) {
        streak++;
        currentDay = currentDay.subtract(const Duration(days: 1));
      } else if (day.isAfter(currentDay)) {
        continue;
      } else {
        break;
      }
    }

    return streak;
  }
}
