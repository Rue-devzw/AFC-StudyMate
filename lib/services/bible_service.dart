import '../models/bible.dart';
import 'bible_database_service.dart';

class BibleService {
  final DatabaseService _databaseService = DatabaseService();
  static const String _defaultBibleId = 'kjv';

  Future<List<Book>> loadBooks() async {
    return _databaseService.getBooks(_defaultBibleId);
  }

  Future<List<Verse>> getVerses(int bookId, int chapter) async {
    return _databaseService.getVerses(_defaultBibleId, bookId, chapter);
  }

  Future<List<Bible>> getBibleVersions() async {
    return _databaseService.getBibleVersions();
  }
}
