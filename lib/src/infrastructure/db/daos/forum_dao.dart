import 'package:drift/drift.dart';

import '../app_database.dart';

class ForumDao {
  ForumDao(this._db);

  final AppDatabase _db;

  Stream<List<DiscussionThreadRow>> watchThreads(String classId) {
    final query = _db.select(_db.discussionThreads)
      ..where((tbl) => tbl.classId.equals(classId))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]);
    return query.watch();
  }

  Future<List<DiscussionThreadRow>> fetchThreads(String classId) {
    final query = _db.select(_db.discussionThreads)
      ..where((tbl) => tbl.classId.equals(classId))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]);
    return query.get();
  }

  Stream<List<DiscussionPostRow>> watchPosts(String threadId) {
    final query = _db.select(_db.discussionPosts)
      ..where((tbl) => tbl.threadId.equals(threadId))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)]);
    return query.watch();
  }

  Future<void> upsertThread(DiscussionThreadsCompanion companion) {
    return _db.into(_db.discussionThreads).insertOnConflictUpdate(companion);
  }

  Future<void> upsertPost(DiscussionPostsCompanion companion) {
    return _db.into(_db.discussionPosts).insertOnConflictUpdate(companion);
  }

  Future<void> deletePost(String id) {
    return (_db.delete(_db.discussionPosts)..where((tbl) => tbl.id.equals(id))).go();
  }
}
