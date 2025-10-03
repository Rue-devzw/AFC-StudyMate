import 'entities.dart';
import 'repositories.dart';

class WatchLessonsUseCase {
  final LessonRepository _repository;

  const WatchLessonsUseCase(this._repository);

  Stream<List<Lesson>> call({LessonQuery? filter}) =>
      _repository.watchLessons(filter: filter);
}

class GetLessonsUseCase {
  final LessonRepository _repository;

  const GetLessonsUseCase(this._repository);

  Future<List<Lesson>> call({LessonQuery? filter}) =>
      _repository.getLessons(filter: filter);
}

class GetLessonUseCase {
  final LessonRepository _repository;

  const GetLessonUseCase(this._repository);

  Future<Lesson?> call(String id) => _repository.getLessonById(id);
}

class WatchLessonProgressUseCase {
  final LessonRepository _repository;

  const WatchLessonProgressUseCase(this._repository);

  Stream<List<LessonProgress>> call(String userId) =>
      _repository.watchProgress(userId);
}

class UpdateProgressUseCase {
  final LessonRepository _repository;

  const UpdateProgressUseCase(this._repository);

  Future<void> call(LessonProgress progress) =>
      _repository.upsertProgress(progress);
}

class WatchLessonDraftsUseCase {
  const WatchLessonDraftsUseCase(this._repository);

  final LessonDraftRepository _repository;

  Stream<List<LessonDraft>> call(String authorId) =>
      _repository.watchDrafts(authorId);
}

class WatchPendingDraftApprovalsUseCase {
  const WatchPendingDraftApprovalsUseCase(this._repository);

  final LessonDraftRepository _repository;

  Stream<List<LessonDraft>> call() => _repository.watchPendingApprovals();
}

class SaveLessonDraftUseCase {
  const SaveLessonDraftUseCase(this._repository);

  final LessonDraftRepository _repository;

  Future<void> call(LessonDraft draft) => _repository.saveDraft(draft);
}

class DeleteLessonDraftUseCase {
  const DeleteLessonDraftUseCase(this._repository);

  final LessonDraftRepository _repository;

  Future<void> call(String id) => _repository.deleteDraft(id);
}

class WatchRoundtablesUseCase {
  const WatchRoundtablesUseCase(this._repository);

  final RoundtableRepository _repository;

  Stream<List<RoundtableSession>> call(String? classId) =>
      _repository.watchUpcoming(classId);
}

class SaveRoundtableUseCase {
  const SaveRoundtableUseCase(this._repository);

  final RoundtableRepository _repository;

  Future<void> call(RoundtableSession session) =>
      _repository.saveSession(session);
}

class CancelRoundtableUseCase {
  const CancelRoundtableUseCase(this._repository);

  final RoundtableRepository _repository;

  Future<void> call(String id) => _repository.cancelSession(id);
}

class WatchForumThreadsUseCase {
  const WatchForumThreadsUseCase(this._repository);

  final DiscussionForumRepository _repository;

  Stream<List<DiscussionThread>> call(String classId) =>
      _repository.watchThreads(classId);
}

class WatchForumPostsUseCase {
  const WatchForumPostsUseCase(this._repository);

  final DiscussionForumRepository _repository;

  Stream<List<DiscussionPost>> call(String threadId) =>
      _repository.watchPosts(threadId);
}

class UpsertForumThreadUseCase {
  const UpsertForumThreadUseCase(this._repository);

  final DiscussionForumRepository _repository;

  Future<void> call(DiscussionThread thread) =>
      _repository.upsertThread(thread);
}

class UpsertForumPostUseCase {
  const UpsertForumPostUseCase(this._repository);

  final DiscussionForumRepository _repository;

  Future<void> call(DiscussionPost post) =>
      _repository.upsertPost(post);
}

class DeleteForumPostUseCase {
  const DeleteForumPostUseCase(this._repository);

  final DiscussionForumRepository _repository;

  Future<void> call(String id) => _repository.deletePost(id);
}
