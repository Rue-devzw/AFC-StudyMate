import 'package:drift/drift.dart';

import '../app_database.dart';

class LessonDao {
  LessonDao(this._db);

  final AppDatabase _db;

  Stream<List<Lesson>> watchLessons() {
    return _db.select(_db.lessons).watch();
  }

  Future<List<Lesson>> getLessons() {
    return _db.select(_db.lessons).get();
  }

  Future<Lesson?> getLessonById(String id) {
    return (_db.select(_db.lessons)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Stream<List<ProgressData>> watchProgress(String userId) {
    return (_db.select(_db.progress)..where((tbl) => tbl.userId.equals(userId))).watch();
  }

  Future<void> upsertProgress(ProgressCompanion companion) {
    return _db.into(_db.progress).insertOnConflictUpdate(companion);
  }
}
