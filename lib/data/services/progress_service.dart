import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../drift/app_database.dart';
import '../models/progress.dart';

final progressServiceProvider = Provider<ProgressService>((ref) {
  return ProgressService(database: ref.read(appDatabaseProvider));
});

class ProgressService {
  ProgressService({required this.database});

  final AppDatabase database;

  Future<void> recordCompletion({
    required String userId,
    required String lessonId,
    double? score,
  }) async {
    final now = DateTime.now();
    final progressList = await getUserProgress(userId);
    final streak = _calculateStreak(progressList, now);

    final progress = Progress(
      userId: userId,
      lessonId: lessonId,
      completedAt: now,
      score: score,
      streakCount: streak,
    );
    await database.upsertProgress(progress);
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

    int streak = 0;
    DateTime currentDay = DateTime(
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
