import 'entities.dart';

class LessonProgressSnapshot {
  const LessonProgressSnapshot({
    required this.lesson,
    required this.progress,
  });

  final Lesson lesson;
  final LessonProgress? progress;
}

class LessonClassSummary {
  const LessonClassSummary({
    required this.lessonClass,
    required this.totalLessons,
    required this.completedLessons,
    required this.inProgressLessons,
    required this.notStartedLessons,
    required this.totalTimeSpentSeconds,
    required this.averageQuizScore,
  });

  final String lessonClass;
  final int totalLessons;
  final int completedLessons;
  final int inProgressLessons;
  final int notStartedLessons;
  final int totalTimeSpentSeconds;
  final double averageQuizScore;
}

class LessonProgressDashboardData {
  const LessonProgressDashboardData({
    required this.snapshots,
    required this.completedCount,
    required this.inProgressCount,
    required this.notStartedCount,
    required this.totalTimeSpentSeconds,
    required this.averageQuizScore,
    required this.classSummaries,
    required this.completionsByDay,
  });

  final List<LessonProgressSnapshot> snapshots;
  final int completedCount;
  final int inProgressCount;
  final int notStartedCount;
  final int totalTimeSpentSeconds;
  final double averageQuizScore;
  final List<LessonClassSummary> classSummaries;
  final Map<DateTime, int> completionsByDay;

  int get totalLessons =>
      completedCount + inProgressCount + notStartedCount;

  double get completionRate =>
      totalLessons == 0 ? 0.0 : completedCount / totalLessons;
}
