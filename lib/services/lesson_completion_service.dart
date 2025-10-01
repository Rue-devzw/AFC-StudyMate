import 'package:shared_preferences/shared_preferences.dart';

class LessonCompletionService {
  static const String _completionKeyPrefix = 'lesson_completed_';

  Future<void> markLessonAsComplete(String lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_completionKeyPrefix$lessonId', true);
  }

  Future<bool> isLessonCompleted(String lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_completionKeyPrefix$lessonId') ?? false;
  }
}
