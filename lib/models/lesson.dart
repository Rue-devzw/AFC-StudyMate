

// Represents a group of lessons, e.g., "Beginners Quarter 1"
class LessonGroup {
  final String title;
  final List<Lesson> lessons;

  LessonGroup({required this.title, required this.lessons});

  factory LessonGroup.fromJson(Map<String, dynamic> json) {
    return LessonGroup(
      title: json['title'],
      lessons: (json['lessons'] as List)
          .map((l) => Lesson.fromJson(l as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'lessons': lessons.map((l) => l.toJson()).toList(),
  };
}

// Represents a single lesson with all its components
class Lesson {
  final String id;
  final String title;
  final String className;
  final String ageRange;
  final List<String> objectives;
  final List<ScriptureReference> scriptures;
  final String contentHtml;
  final String? teacherNotes;
  final List<Attachment> attachments;
  final List<QuizItem> quizzes;
  // Tracking progress
  final String status; // not_started, in_progress, completed
  final int score;
  final int timeSpent; // in seconds

  Lesson({
    required this.id,
    required this.title,
    required this.className,
    required this.ageRange,
    this.objectives = const [],
    this.scriptures = const [],
    required this.contentHtml,
    this.teacherNotes,
    this.attachments = const [],
    this.quizzes = const [],
    this.status = 'not_started',
    this.score = 0,
    this.timeSpent = 0,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      className: json['class'],
      ageRange: json['ageRange'],
      objectives: List<String>.from(json['objectives'] ?? []),
      scriptures: (json['scriptures'] as List? ?? [])
          .map((s) => ScriptureReference.fromJson(s as Map<String, dynamic>))
          .toList(),
      contentHtml: json['contentHtml'],
      teacherNotes: json['teacherNotes'],
      attachments: (json['attachments'] as List? ?? [])
          .map((a) => Attachment.fromJson(a as Map<String, dynamic>))
          .toList(),
      quizzes: (json['quizzes'] as List? ?? [])
          .map((q) => QuizItem.fromJson(q as Map<String, dynamic>))
          .toList(),
      status: json['status'] ?? 'not_started',
      score: json['score'] ?? 0,
      timeSpent: json['timeSpent'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'class': className,
    'ageRange': ageRange,
    'objectives': objectives,
    'scriptures': scriptures.map((s) => s.toJson()).toList(),
    'contentHtml': contentHtml,
    'teacherNotes': teacherNotes,
    'attachments': attachments.map((a) => a.toJson()).toList(),
    'quizzes': quizzes.map((q) => q.toJson()).toList(),
    'status': status,
    'score': score,
    'timeSpent': timeSpent,
  };
}

// Represents a reference to a Bible scripture
class ScriptureReference {
  final String translationId;
  final String book;
  final int chapter;
  final List<int> verses;

  ScriptureReference({
    required this.translationId,
    required this.book,
    required this.chapter,
    required this.verses,
  });

  factory ScriptureReference.fromJson(Map<String, dynamic> json) {
    return ScriptureReference(
      translationId: json['translationId'],
      book: json['book'],
      chapter: json['chapter'],
      verses: List<int>.from(json['verses']),
    );
  }

  Map<String, dynamic> toJson() => {
    'translationId': translationId,
    'book': book,
    'chapter': chapter,
    'verses': verses,
  };
}

// Represents a lesson attachment (e.g., image, audio, pdf)
class Attachment {
  final String type; // 'image', 'audio', 'pdf', 'video'
  final String url;
  final String? localPath;

  Attachment({required this.type, required this.url, this.localPath});

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      type: json['type'],
      url: json['url'],
      localPath: json['localPath'],
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'url': url,
    'localPath': localPath,
  };
}

// Represents a single quiz item
class QuizItem {
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String type; // e.g., 'multiple_choice', 'fill_in_the_blank'

  QuizItem({
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    this.type = 'multiple_choice',
  });

  factory QuizItem.fromJson(Map<String, dynamic> json) {
    return QuizItem(
      question: json['question'],
      options: List<String>.from(json['options']),
      correctOptionIndex: json['correctOptionIndex'],
      type: json['type'] ?? 'multiple_choice',
    );
  }

  Map<String, dynamic> toJson() => {
    'question': question,
    'options': options,
    'correctOptionIndex': correctOptionIndex,
    'type': type,
  };
}
