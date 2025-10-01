import 'package:shared_preferences/shared_preferences.dart';

class ReadingProgressService {
  static const String _bookKey = 'last_read_book';
  static const String _chapterKey = 'last_read_chapter';

  Future<void> saveReadingProgress(int bookId, int chapter) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_bookKey, bookId);
    await prefs.setInt(_chapterKey, chapter);
  }

  Future<Map<String, int?>> getReadingProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final bookId = prefs.getInt(_bookKey);
    final chapter = prefs.getInt(_chapterKey);
    return {'bookId': bookId, 'chapter': chapter};
  }

  Future<void> clearReadingProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_bookKey);
    await prefs.remove(_chapterKey);
  }
}
