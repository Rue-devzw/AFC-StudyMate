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
    final progress = Progress(
      userId: userId,
      lessonId: lessonId,
      completedAt: DateTime.now(),
      score: score,
      streakCount: null,
    );
    await database.upsertProgress(progress);
  }

  Future<List<Progress>> getUserProgress(String userId) => database.getProgressForUser(userId);
}
