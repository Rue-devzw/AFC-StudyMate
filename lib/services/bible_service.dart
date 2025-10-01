import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bible.dart';
import 'cache_service.dart';

class BibleService {
  static const String _apiKey = '575753847d77ffdbb70153876b4d0434';
  static const String _baseUrl = 'https://api.scripture.api.bible/v1';

  static Future<List<Bible>> getBibles() async {
    final cachedBibles = await CacheService.getBibles();
    if (cachedBibles != null) {
      return cachedBibles;
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/bibles'),
      headers: {'api-key': _apiKey},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      final bibles = data.map((json) => Bible.fromJson(json)).toList();
      await CacheService.saveBibles(bibles);
      return bibles;
    } else {
      throw Exception('Failed to load Bibles');
    }
  }

  static Future<Bible> getBible(String bibleId) async {
    // This method is not cached as it is not used in the app
    final response = await http.get(
      Uri.parse('$_baseUrl/bibles/$bibleId'),
      headers: {'api-key': _apiKey},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return Bible.fromJson(data);
    } else {
      throw Exception('Failed to load Bible');
    }
  }

  static Future<List<Book>> getBooks(String bibleId) async {
    final cachedBooks = await CacheService.getBooks(bibleId);
    if (cachedBooks != null) {
      return cachedBooks;
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/bibles/$bibleId/books'),
      headers: {'api-key': _apiKey},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      final books = data.map((json) => Book.fromJson(json)).toList();
      await CacheService.saveBooks(bibleId, books);
      return books;
    } else {
      throw Exception('Failed to load books');
    }
  }

  static Future<List<Chapter>> getChapters(String bibleId, String bookId) async {
    final cachedChapters = await CacheService.getChapters(bibleId, bookId);
    if (cachedChapters != null) {
      return cachedChapters;
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/bibles/$bibleId/books/$bookId/chapters'),
      headers: {'api-key': _apiKey},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      final chapters = data.map((json) => Chapter.fromJson(json)).toList();
      await CacheService.saveChapters(bibleId, bookId, chapters);
      return chapters;
    } else {
      throw Exception('Failed to load chapters');
    }
  }

  static Future<Chapter> getChapter(String bibleId, String chapterId) async {
    final cachedChapter = await CacheService.getChapter(bibleId, chapterId);
    if (cachedChapter != null) {
      return cachedChapter;
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/bibles/$bibleId/chapters/$chapterId?content-type=json'),
      headers: {'api-key': _apiKey},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      final chapter = Chapter.fromJson(data);
      await CacheService.saveChapter(bibleId, chapterId, chapter);
      return chapter;
    } else {
      throw Exception('Failed to load chapter');
    }
  }

  // This is not an efficient way to search, but the api.bible API does not provide a search endpoint.
  // This method will fetch the entire bible and then search for the query.
  static Future<List<Verse>> searchBible(String bibleId, String query) async {
    final books = await getBooks(bibleId);
    final List<Verse> results = [];

    for (final book in books) {
      final chapters = await getChapters(bibleId, book.id);
      for (final chapter in chapters) {
        try {
          final chapterContent = await getChapter(bibleId, chapter.id);
          for (final verse in chapterContent.verses) {
            if (verse.text.toLowerCase().contains(query.toLowerCase())) {
              results.add(verse);
            }
          }
        } catch (e) {
          // Ignore errors for chapters that fail to load
        }
      }
    }

    return results;
  }
}
