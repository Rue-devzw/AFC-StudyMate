import '../../domain/lessons/entities.dart';
import '../../domain/lessons/repositories.dart';
import '../../domain/sync/entities.dart';
import '../../domain/sync/repositories.dart';
import '../../infrastructure/db/app_database.dart';
import '../../infrastructure/db/daos/forum_dao.dart';

class DiscussionForumRepositoryImpl implements DiscussionForumRepository {
  DiscussionForumRepositoryImpl(
    this._db,
    this._dao,
    this._syncRepository,
  );

  final AppDatabase _db;
  final ForumDao _dao;
  final SyncRepository _syncRepository;

  Future<void> _ensureSeeded() => _db.ensureSeeded();

  @override
  Stream<List<DiscussionThread>> watchThreads(String classId) async* {
    await _ensureSeeded();
    yield* _dao.watchThreads(classId).map(_mapThreads);
  }

  @override
  Stream<List<DiscussionPost>> watchPosts(String threadId) async* {
    await _ensureSeeded();
    yield* _dao.watchPosts(threadId).map(_mapPosts);
  }

  @override
  Future<void> upsertThread(DiscussionThread thread) async {
    await _ensureSeeded();
    await _dao.upsertThread(
      DiscussionThreadsCompanion(
        id: Value(thread.id),
        classId: Value(thread.classId),
        title: Value(thread.title),
        createdBy: Value(thread.createdBy),
        status: Value(thread.status),
        createdAt: Value(thread.createdAt.millisecondsSinceEpoch),
        updatedAt: Value(thread.updatedAt.millisecondsSinceEpoch),
      ),
    );
    await _syncRepository.enqueue(
      SyncOperation(
        id: 'forum-thread:${thread.id}',
        userId: thread.createdBy,
        opType: 'forum.thread.upsert',
        payload: {
          'id': thread.id,
          'classId': thread.classId,
          'title': thread.title,
          'status': thread.status,
          'createdAt': thread.createdAt.toIso8601String(),
          'updatedAt': thread.updatedAt.toIso8601String(),
        },
        createdAt: thread.updatedAt,
      ),
    );
  }

  @override
  Future<void> upsertPost(DiscussionPost post) async {
    await _ensureSeeded();
    await _dao.upsertPost(
      DiscussionPostsCompanion(
        id: Value(post.id),
        threadId: Value(post.threadId),
        authorId: Value(post.authorId),
        role: Value(post.role),
        body: Value(post.body),
        status: Value(_statusToString(post.status)),
        createdAt: Value(post.createdAt.millisecondsSinceEpoch),
        updatedAt: Value(post.updatedAt.millisecondsSinceEpoch),
      ),
    );
    await _syncRepository.enqueue(
      SyncOperation(
        id: 'forum-post:${post.id}',
        userId: post.authorId,
        opType: 'forum.post.upsert',
        payload: {
          'id': post.id,
          'threadId': post.threadId,
          'authorId': post.authorId,
          'role': post.role,
          'body': post.body,
          'status': _statusToString(post.status),
          'createdAt': post.createdAt.toIso8601String(),
          'updatedAt': post.updatedAt.toIso8601String(),
        },
        createdAt: post.updatedAt,
      ),
    );
  }

  @override
  Future<void> deletePost(String postId) async {
    await _ensureSeeded();
    await _dao.deletePost(postId);
    await _syncRepository.enqueue(
      SyncOperation(
        id: 'forum-post:$postId:delete',
        userId: 'system',
        opType: 'forum.post.delete',
        payload: {
          'id': postId,
        },
        createdAt: DateTime.now(),
      ),
    );
  }

  List<DiscussionThread> _mapThreads(List<DiscussionThreadRow> rows) {
    return rows
        .map(
          (row) => DiscussionThread(
            id: row.id,
            classId: row.classId,
            title: row.title,
            createdBy: row.createdBy,
            status: row.status,
            createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
            updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
          ),
        )
        .toList();
  }

  List<DiscussionPost> _mapPosts(List<DiscussionPostRow> rows) {
    return rows
        .map(
          (row) => DiscussionPost(
            id: row.id,
            threadId: row.threadId,
            authorId: row.authorId,
            role: row.role,
            body: row.body,
            status: _statusFromString(row.status),
            createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
            updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
          ),
        )
        .toList();
  }

  DiscussionPostStatus _statusFromString(String value) {
    switch (value) {
      case 'published':
        return DiscussionPostStatus.published;
      case 'rejected':
        return DiscussionPostStatus.rejected;
      case 'pending':
      default:
        return DiscussionPostStatus.pending;
    }
  }

  String _statusToString(DiscussionPostStatus status) {
    switch (status) {
      case DiscussionPostStatus.pending:
        return 'pending';
      case DiscussionPostStatus.published:
        return 'published';
      case DiscussionPostStatus.rejected:
        return 'rejected';
    }
  }
}
