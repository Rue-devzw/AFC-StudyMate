import '../models/bible.dart';
import 'bible_database_service.dart';

class BibleService {
  final DatabaseService _databaseService = DatabaseService();
  static const String _defaultBibleId = 'kjv';

  Future<String> _resolveBibleId([String? translationId]) async {
    final normalized = (translationId ?? '').trim().toLowerCase();
    if (normalized.isEmpty) {
      return _defaultBibleId;
    }

    final availableBibles = await _databaseService.getBibleVersions();
    for (final bible in availableBibles) {
      final idLower = bible.id.toLowerCase();
      if (idLower == normalized) {
        return bible.id;
      }

      final nameLower = bible.name.toLowerCase();
      if (nameLower == normalized) {
        return bible.id;
      }

      final sanitizedName = nameLower.replaceAll(RegExp(r'\s+'), '_');
      if (sanitizedName == normalized) {
        return bible.id;
      }
    }

    return _defaultBibleId;
  }

  Future<List<Book>> loadBooks({String? translationId}) async {
    final bibleId = await _resolveBibleId(translationId);
    return _databaseService.getBooks(bibleId);
  }

  Future<List<Verse>> getVerses(
    int bookId,
    int chapter, {
    String? translationId,
  }) async {
    final bibleId = await _resolveBibleId(translationId);
    return _databaseService.getVerses(bibleId, bookId, chapter);
  }

  Future<Verse?> getVerse(
    int bookId,
    int chapter,
    int verseNumber, {
    String? translationId,
  }) async {
    final bibleId = await _resolveBibleId(translationId);
    return _databaseService.getVerse(bibleId, bookId, chapter, verseNumber);
  }

  Future<List<Bible>> getBibleVersions() async {
    return _databaseService.getBibleVersions();
  }

  Future<Bible?> findBible(String translationId) async {
    final normalized = translationId.trim().toLowerCase();
    if (normalized.isEmpty) {
      return null;
    }

    final availableBibles = await _databaseService.getBibleVersions();
    for (final bible in availableBibles) {
      final idLower = bible.id.toLowerCase();
      if (idLower == normalized) {
        return bible;
      }

      final nameLower = bible.name.toLowerCase();
      if (nameLower == normalized) {
        return bible;
      }

      final sanitizedName = nameLower.replaceAll(RegExp(r'\s+'), '_');
      if (sanitizedName == normalized) {
        return bible;
      }
    }

    return null;
  }

  Future<bool> hasTranslation(String translationId) async {
    return await findBible(translationId) != null;
  }

  Future<List<Verse>> searchVerses(
    String query, {
    String? translationId,
    int? limit,
  }) async {
    final bibleId = await _resolveBibleId(translationId);
    return _databaseService.searchVerses(bibleId, query, limit: limit);
  }
}
