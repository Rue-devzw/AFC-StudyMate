import 'package:drift/drift.dart';

import '../app_database.dart';

class LessonDraftDao {
  LessonDraftDao(this._db);

  final AppDatabase _db;

  Stream<List<LessonDraftRow>> watchDrafts(String authorId) {
    final query = _db.select(_db.lessonDrafts)
      ..where((tbl) => tbl.authorId.equals(authorId))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]);
    return query.watch();
  }

  Future<List<LessonDraftRow>> fetchDrafts(String authorId) {
    final query = _db.select(_db.lessonDrafts)
      ..where((tbl) => tbl.authorId.equals(authorId))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]);
    return query.get();
  }

  Stream<List<LessonDraftRow>> watchPendingApprovals() {
    final query = _db.select(_db.lessonDrafts)
      ..where((tbl) => tbl.status.equals('submitted'))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.updatedAt)]);
    return query.watch();
  }

  Future<LessonDraftRow?> getDraftById(String id) {
    return (_db.select(_db.lessonDrafts)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<void> upsertDraft(LessonDraftsCompanion companion) {
    return _db.into(_db.lessonDrafts).insertOnConflictUpdate(companion);
  }

  Future<void> deleteDraft(String id) {
    return (_db.delete(_db.lessonDrafts)..where((tbl) => tbl.id.equals(id))).go();
  }
}
