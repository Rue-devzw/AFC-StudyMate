import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bible.dart';
import '../models/lesson.dart';

class CacheService {
  // Save a list of bibles to cache
  static Future<void> saveBibles(List<Bible> bibles) async {
    final prefs = await SharedPreferences.getInstance();
    final biblesJson = bibles.map((bible) => bible.toJson()).toList();
    await prefs.setString('bibles', json.encode(biblesJson));
  }

  // Get a list of bibles from cache
  static Future<List<Bible>?> getBibles() async {
    final prefs = await SharedPreferences.getInstance();
    final biblesJson = prefs.getString('bibles');
    if (biblesJson != null) {
      final biblesList = json.decode(biblesJson) as List;
      return biblesList.map((json) => Bible.fromJson(json)).toList();
    }
    return null;
  }

  // Save the books of a bible to cache
  static Future<void> saveBooks(String bibleId, List<Book> books) async {
    final prefs = await SharedPreferences.getInstance();
    final booksJson = books.map((book) => book.toJson()).toList();
    await prefs.setString('books_$bibleId', json.encode(booksJson));
  }

  // Get the books of a bible from cache
  static Future<List<Book>?> getBooks(String bibleId) async {
    final prefs = await SharedPreferences.getInstance();
    final booksJson = prefs.getString('books_$bibleId');
    if (booksJson != null) {
      final booksList = json.decode(booksJson) as List;
      return booksList.map((json) => Book.fromJson(json)).toList();
    }
    return null;
  }

  // Save the chapters of a book to cache
  static Future<void> saveChapters(String bibleId, String bookId, List<Chapter> chapters) async {
    final prefs = await SharedPreferences.getInstance();
    final chaptersJson = chapters.map((chapter) => chapter.toJson()).toList();
    await prefs.setString('chapters_${bibleId}_$bookId', json.encode(chaptersJson));
  }

  // Get the chapters of a book from cache
  static Future<List<Chapter>?> getChapters(String bibleId, String bookId) async {
    final prefs = await SharedPreferences.getInstance();
    final chaptersJson = prefs.getString('chapters_${bibleId}_$bookId');
    if (chaptersJson != null) {
      final chaptersList = json.decode(chaptersJson) as List;
      return chaptersList.map((json) => Chapter.fromJson(json)).toList();
    }
    return null;
  }

  // Save a chapter to cache
  static Future<void> saveChapter(String bibleId, String chapterId, Chapter chapter) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chapter_${bibleId}_$chapterId', json.encode(chapter.toJson()));
  }

  // Get a chapter from cache
  static Future<Chapter?> getChapter(String bibleId, String chapterId) async {
    final prefs = await SharedPreferences.getInstance();
    final chapterJson = prefs.getString('chapter_${bibleId}_$chapterId');
    if (chapterJson != null) {
      return Chapter.fromJson(json.decode(chapterJson));
    }
    return null;
  }

  // Save a list of lesson groups to cache
  static Future<void> saveLessonGroups(List<LessonGroup> lessonGroups) async {
    final prefs = await SharedPreferences.getInstance();
    final lessonGroupsJson = lessonGroups.map((lg) => lg.toJson()).toList();
    await prefs.setString('lesson_groups', json.encode(lessonGroupsJson));
  }

  // Get a list of lesson groups from cache
  static Future<List<LessonGroup>?> getLessonGroups() async {
    final prefs = await SharedPreferences.getInstance();
    final lessonGroupsJson = prefs.getString('lesson_groups');
    if (lessonGroupsJson != null) {
      final lessonGroupsList = json.decode(lessonGroupsJson) as List;
      return lessonGroupsList.map((json) => LessonGroup.fromJson(json)).toList();
    }
    return null;
  }
}
