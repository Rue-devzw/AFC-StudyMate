class LessonAgeRange {
  const LessonAgeRange({required this.min, required this.max});

  final int min;
  final int max;

  bool contains(int age) => age >= min && age <= max;
}

class LessonScriptureReference {
  const LessonScriptureReference({
    required this.reference,
    this.translationId,
  });

  final String reference;
  final String? translationId;
}

enum LessonAttachmentType { image, audio, pdf, video, link }

class LessonAttachment {
  const LessonAttachment({
    required this.type,
    required this.url,
    required this.position,
    this.title,
  });

  final LessonAttachmentType type;
  final String url;
  final int position;
  final String? title;
}

enum LessonQuizType { mcq, trueFalse, shortAnswer }

class LessonQuiz {
  const LessonQuiz({
    required this.id,
    required this.type,
    required this.prompt,
    required this.options,
    required this.answers,
    required this.position,
  });

  final String id;
  final LessonQuizType type;
  final String prompt;
  final List<String> options;
  final List<String> answers;
  final int position;
}

class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.lessonClass,
    this.ageRange,
    this.objectives = const [],
    this.scriptures = const [],
    this.contentHtml,
    this.teacherNotes,
    this.attachments = const [],
    this.quizzes = const [],
    this.sourceUrl,
    this.lastFetchedAt,
    this.feedId,
    this.cohortId,
  });

  final String id;
  final String title;
  final String lessonClass;
  final LessonAgeRange? ageRange;
  final List<String> objectives;
  final List<LessonScriptureReference> scriptures;
  final String? contentHtml;
  final String? teacherNotes;
  final List<LessonAttachment> attachments;
  final List<LessonQuiz> quizzes;
  final String? sourceUrl;
  final DateTime? lastFetchedAt;
  final String? feedId;
  final String? cohortId;
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

enum LessonCompletionFilter { all, notStarted, inProgress, completed }

class LessonQuery {
  const LessonQuery({
    this.classes,
    this.age,
    this.completion = LessonCompletionFilter.all,
    this.userId = 'local-user',
  });

  final Set<String>? classes;
  final int? age;
  final LessonCompletionFilter completion;
  final String userId;
}
