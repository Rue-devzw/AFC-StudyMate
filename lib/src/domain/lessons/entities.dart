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
    this.localPath,
  });

  final LessonAttachmentType type;
  final String url;
  final int position;
  final String? title;
  final String? localPath;
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
  final DateTime? startedAt;
  final DateTime? completedAt;

  const LessonProgress({
    required this.id,
    required this.userId,
    required this.lessonId,
    required this.status,
    this.quizScore,
    this.timeSpentSeconds = 0,
    required this.updatedAt,
    this.startedAt,
    this.completedAt,
  });

  LessonProgress copyWith({
    String? id,
    String? userId,
    String? lessonId,
    String? status,
    double? quizScore,
    bool removeQuizScore = false,
    int? timeSpentSeconds,
    DateTime? updatedAt,
    DateTime? startedAt,
    bool removeStartedAt = false,
    DateTime? completedAt,
    bool removeCompletedAt = false,
  }) {
    return LessonProgress(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      lessonId: lessonId ?? this.lessonId,
      status: status ?? this.status,
      quizScore: removeQuizScore ? null : quizScore ?? this.quizScore,
      timeSpentSeconds: timeSpentSeconds ?? this.timeSpentSeconds,
      updatedAt: updatedAt ?? this.updatedAt,
      startedAt:
          removeStartedAt ? null : startedAt ?? this.startedAt,
      completedAt:
          removeCompletedAt ? null : completedAt ?? this.completedAt,
    );
  }
}

enum LessonCompletionFilter { all, notStarted, inProgress, completed }

class LessonQuery {
  const LessonQuery({
    this.classes,
    this.age,
    this.completion = LessonCompletionFilter.all,
    required this.userId,
  });

  final Set<String>? classes;
  final int? age;
  final LessonCompletionFilter completion;
  final String userId;
}

enum LessonDraftStatus { draft, submitted, approved, rejected }

class LessonDraft {
  const LessonDraft({
    required this.id,
    this.lessonId,
    required this.authorId,
    required this.title,
    required this.deltaJson,
    required this.status,
    this.approverId,
    this.reviewerComment,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String? lessonId;
  final String authorId;
  final String title;
  final String deltaJson;
  final LessonDraftStatus status;
  final String? approverId;
  final String? reviewerComment;
  final DateTime createdAt;
  final DateTime updatedAt;

  LessonDraft copyWith({
    String? id,
    String? lessonId,
    String? authorId,
    String? title,
    String? deltaJson,
    LessonDraftStatus? status,
    String? approverId,
    bool removeApprover = false,
    String? reviewerComment,
    bool removeComment = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LessonDraft(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      authorId: authorId ?? this.authorId,
      title: title ?? this.title,
      deltaJson: deltaJson ?? this.deltaJson,
      status: status ?? this.status,
      approverId: removeApprover ? null : approverId ?? this.approverId,
      reviewerComment:
          removeComment ? null : reviewerComment ?? this.reviewerComment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class RoundtableSession {
  const RoundtableSession({
    required this.id,
    required this.title,
    this.description,
    this.classId,
    required this.startTime,
    required this.endTime,
    this.conferencingUrl,
    required this.reminderMinutesBefore,
    required this.createdBy,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String? description;
  final String? classId;
  final DateTime startTime;
  final DateTime endTime;
  final String? conferencingUrl;
  final int reminderMinutesBefore;
  final String createdBy;
  final DateTime updatedAt;
}

enum DiscussionPostStatus { pending, published, rejected }

class DiscussionThread {
  const DiscussionThread({
    required this.id,
    required this.classId,
    required this.title,
    required this.createdBy,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String classId;
  final String title;
  final String createdBy;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class DiscussionPost {
  const DiscussionPost({
    required this.id,
    required this.threadId,
    required this.authorId,
    this.role,
    required this.body,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String threadId;
  final String authorId;
  final String? role;
  final String body;
  final DiscussionPostStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
}
