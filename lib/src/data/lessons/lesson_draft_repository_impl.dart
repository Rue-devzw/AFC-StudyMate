import 'package:drift/drift.dart';

import '../../domain/lessons/entities.dart';
import '../../domain/lessons/repositories.dart';
import '../../domain/sync/entities.dart';
import '../../domain/sync/repositories.dart';
import '../../infrastructure/db/app_database.dart';
import '../../infrastructure/db/daos/lesson_draft_dao.dart';

class LessonDraftRepositoryImpl implements LessonDraftRepository {
  LessonDraftRepositoryImpl(
    this._db,
    this._dao,
    this._syncRepository,
  );

  final AppDatabase _db;
  final LessonDraftDao _dao;
  final SyncRepository _syncRepository;

  Future<void> _ensureSeeded() => _db.ensureSeeded();

  @override
  Stream<List<LessonDraft>> watchDrafts(String authorId) async* {
    await _ensureSeeded();
    yield* _dao.watchDrafts(authorId).map(_mapDrafts);
  }

  @override
  Stream<List<LessonDraft>> watchPendingApprovals() async* {
    await _ensureSeeded();
    yield* _dao.watchPendingApprovals().map(_mapDrafts);
  }

  @override
  Future<LessonDraft?> getDraftById(String id) async {
    await _ensureSeeded();
    final row = await _dao.getDraftById(id);
    return row == null ? null : _mapDraft(row);
  }

  @override
  Future<void> saveDraft(LessonDraft draft) async {
    await _ensureSeeded();
    final companion = LessonDraftsCompanion(
      id: Value(draft.id),
      lessonId: Value(draft.lessonId),
      authorId: Value(draft.authorId),
      title: Value(draft.title),
      deltaJson: Value(draft.deltaJson),
      status: Value(_statusToString(draft.status)),
      approverId: Value(draft.approverId),
      reviewerComment: Value(draft.reviewerComment),
      createdAt: Value(draft.createdAt.millisecondsSinceEpoch),
      updatedAt: Value(draft.updatedAt.millisecondsSinceEpoch),
    );
    await _dao.upsertDraft(companion);
    if (draft.status == LessonDraftStatus.submitted ||
        draft.status == LessonDraftStatus.approved ||
        draft.status == LessonDraftStatus.rejected) {
      await _syncRepository.enqueue(
        SyncOperation(
          id: 'lesson-draft:${draft.id}',
          userId: draft.authorId,
          opType: 'lessonDraft.${_statusToString(draft.status)}',
          payload: {
            'draftId': draft.id,
            'lessonId': draft.lessonId,
            'title': draft.title,
            'delta': draft.deltaJson,
            'status': _statusToString(draft.status),
            'approverId': draft.approverId,
            'reviewerComment': draft.reviewerComment,
            'updatedAt': draft.updatedAt.millisecondsSinceEpoch,
          },
          createdAt: draft.updatedAt,
        ),
      );
    }
  }

  @override
  Future<void> deleteDraft(String id) async {
    await _ensureSeeded();
    await _dao.deleteDraft(id);
  }

  List<LessonDraft> _mapDrafts(List<LessonDraftRow> rows) =>
      rows.map(_mapDraft).toList();

  LessonDraft _mapDraft(LessonDraftRow row) {
    return LessonDraft(
      id: row.id,
      lessonId: row.lessonId,
      authorId: row.authorId,
      title: row.title,
      deltaJson: row.deltaJson,
      status: _statusFromString(row.status),
      approverId: row.approverId,
      reviewerComment: row.reviewerComment,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
    );
  }

  LessonDraftStatus _statusFromString(String status) {
    switch (status) {
      case 'submitted':
        return LessonDraftStatus.submitted;
      case 'approved':
        return LessonDraftStatus.approved;
      case 'rejected':
        return LessonDraftStatus.rejected;
      case 'draft':
      default:
        return LessonDraftStatus.draft;
    }
  }

  String _statusToString(LessonDraftStatus status) {
    switch (status) {
      case LessonDraftStatus.draft:
        return 'draft';
      case LessonDraftStatus.submitted:
        return 'submitted';
      case LessonDraftStatus.approved:
        return 'approved';
      case LessonDraftStatus.rejected:
        return 'rejected';
    }
  }
}
