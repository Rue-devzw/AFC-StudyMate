class Lesson {
  final String id;
  final String title;
  final String lessonClass;
  final int? ageMin;
  final int? ageMax;
  final List<String> objectives;
  final List<Map<String, dynamic>> scriptures;
  final String? contentHtml;
  final String? teacherNotes;
  final List<Map<String, dynamic>> attachments;
  final List<Map<String, dynamic>> quizzes;
  final String? sourceUrl;
  final DateTime? lastFetchedAt;

  const Lesson({
    required this.id,
    required this.title,
    required this.lessonClass,
    this.ageMin,
    this.ageMax,
    this.objectives = const [],
    this.scriptures = const [],
    this.contentHtml,
    this.teacherNotes,
    this.attachments = const [],
    this.quizzes = const [],
    this.sourceUrl,
    this.lastFetchedAt,
  });
}

class LessonProgress {
  final String id;
  final String userId;
  final String lessonId;
  final String status;
  final double? quizScore;
  final int timeSpentSeconds;
  final DateTime updatedAt;

  const LessonProgress({
    required this.id,
    required this.userId,
    required this.lessonId,
    required this.status,
    this.quizScore,
    this.timeSpentSeconds = 0,
    required this.updatedAt,
  });
}
