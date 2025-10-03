import '../entities.dart';

typedef LessonQuizResponses = Map<String, LessonQuizSubmission>;

class LessonQuizSubmission {
  const LessonQuizSubmission({
    this.selectedOptions = const <String>{},
    this.shortAnswer,
  });

  final Set<String> selectedOptions;
  final String? shortAnswer;
}

class LessonQuizGrader {
  const LessonQuizGrader();

  double grade(List<LessonQuiz> quizzes, LessonQuizResponses responses) {
    if (quizzes.isEmpty) {
      return 0;
    }
    var earned = 0.0;
    for (final quiz in quizzes) {
      final response = responses[quiz.id];
      if (response == null) {
        continue;
      }
      switch (quiz.type) {
        case LessonQuizType.mcq:
        case LessonQuizType.trueFalse:
          if (quiz.answers.isEmpty) {
            continue;
          }
          if (quiz.answers.toSet().containsAll(response.selectedOptions) &&
              response.selectedOptions.length == quiz.answers.length) {
            earned += 1;
          }
          break;
        case LessonQuizType.shortAnswer:
          if (quiz.answers.isEmpty) {
            continue;
          }
          final normalizedExpected = quiz.answers
              .map((answer) => answer.trim().toLowerCase())
              .toSet();
          final submission = response.shortAnswer?.trim().toLowerCase();
          if (submission != null && normalizedExpected.contains(submission)) {
            earned += 1;
          }
          break;
      }
    }
    if (earned == 0) {
      return 0;
    }
    return earned / quizzes.length;
  }
}
