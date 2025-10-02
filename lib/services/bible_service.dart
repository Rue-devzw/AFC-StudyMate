import '../models/bible.dart';
import 'bible_database_service.dart';

class BibleService {
  final DatabaseService _databaseService = DatabaseService();
  static const String _defaultBibleId = 'kjv';

  Future<String> _resolveBibleId(String translationId) async {
    final normalized = translationId.trim().toLowerCase();
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

  Future<List<Book>> loadBooks([String? translationId]) async {
    final bibleId = await _resolveBibleId(translationId ?? _defaultBibleId);
    return _databaseService.getBooks(bibleId);
  }

  Future<List<Verse>> getVerses(
    int bookId,
    int chapter, [
    String? translationId,
  ]) async {
    final bibleId = await _resolveBibleId(translationId ?? _defaultBibleId);
    return _databaseService.getVerses(bibleId, bookId, chapter);
  }

  Future<List<Bible>> getBibleVersions() async {
    return _databaseService.getBibleVersions();
  }

  Future<List<Verse>> searchVerses(
    String query, {
    int? limit,
    String? translationId,
  }) async {
    final bibleId = await _resolveBibleId(translationId ?? _defaultBibleId);
    return _databaseService.searchVerses(bibleId, query, limit: limit);
  }
}
