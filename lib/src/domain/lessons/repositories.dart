import 'entities.dart';

abstract class LessonRepository {
  Stream<List<Lesson>> watchLessons({LessonQuery? filter});
  Future<List<Lesson>> getLessons({LessonQuery? filter});
  Future<Lesson?> getLessonById(String id);
  Stream<List<LessonProgress>> watchProgress(String userId);
  Future<void> upsertProgress(LessonProgress progress);
}

abstract class LessonDraftRepository {
  Stream<List<LessonDraft>> watchDrafts(String authorId);
  Stream<List<LessonDraft>> watchPendingApprovals();
  Future<LessonDraft?> getDraftById(String id);
  Future<void> saveDraft(LessonDraft draft);
  Future<void> deleteDraft(String id);
}

abstract class RoundtableRepository {
  Stream<List<RoundtableSession>> watchUpcoming(String? classId);
  Future<void> saveSession(RoundtableSession session);
  Future<void> cancelSession(String id);
}

abstract class DiscussionForumRepository {
  Stream<List<DiscussionThread>> watchThreads(String classId);
  Stream<List<DiscussionPost>> watchPosts(String threadId);
  Future<void> upsertThread(DiscussionThread thread);
  Future<void> upsertPost(DiscussionPost post);
  Future<void> deletePost(String postId);
}
