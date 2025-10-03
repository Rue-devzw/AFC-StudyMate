import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/lessons/entities.dart' as domain;
import '../../domain/lessons/repositories.dart';
import '../../domain/sync/entities.dart';
import '../../domain/sync/repositories.dart';
import '../../infrastructure/db/app_database.dart' as db;
import '../../infrastructure/db/daos/lesson_dao.dart';
import '../../infrastructure/db/daos/sync_dao.dart';
import '../../infrastructure/lessons/lesson_ingestion_pipeline.dart';

class LessonRepositoryImpl implements LessonRepository {
  LessonRepositoryImpl(
    this._db,
    this._dao,
    this._pipeline,
    this._syncDao,
    this._syncRepository,
  );

  final db.AppDatabase _db;
  final LessonDao _dao;
  final LessonIngestionPipeline _pipeline;
  final SyncDao _syncDao;
  final SyncRepository _syncRepository;

  Future<void> _ensureSeeded() async {
    await _db.ensureSeeded();
    await _pipeline.ensureBundledFeeds();
  }

  @override
  Stream<List<domain.Lesson>> watchLessons(
      {domain.LessonQuery? filter}) async* {
    await _ensureSeeded();
    final daoFilter = _mapFilter(filter);
    yield* _dao.watchLessons(daoFilter).map(_mapLessons);
  }

  @override
  Future<List<domain.Lesson>> getLessons({domain.LessonQuery? filter}) async {
    await _ensureSeeded();
    final rows = await _dao.getLessons(_mapFilter(filter));
    return _mapLessons(rows);
  }

  @override
  Future<domain.Lesson?> getLessonById(String id) async {
    await _ensureSeeded();
    final row = await _dao.getLessonById(id);
    if (row == null) {
      return null;
    }
    return _mapLesson(row);
  }

  @override
  Stream<List<domain.LessonProgress>> watchProgress(String userId) async* {
    await _ensureSeeded();
    yield* _dao.watchProgress(userId).map(_mapProgressList);
  }

  @override
  Future<void> upsertProgress(domain.LessonProgress progress) async {
    await _ensureSeeded();
    final companion = db.ProgressCompanion(
      id: Value(progress.id),
      userId: Value(progress.userId),
      lessonId: Value(progress.lessonId),
      status: Value(progress.status),
      quizScore: Value(progress.quizScore),
      timeSpentSeconds: Value(progress.timeSpentSeconds),
      startedAt: progress.startedAt == null
          ? const Value.absent()
          : Value(progress.startedAt!.millisecondsSinceEpoch),
      completedAt: progress.completedAt == null
          ? const Value.absent()
          : Value(progress.completedAt!.millisecondsSinceEpoch),
      updatedAt: Value(progress.updatedAt.millisecondsSinceEpoch),
    );
    await _dao.upsertProgress(companion);
    await _syncDao.recordProgressChange(
      progressId: progress.id,
      userId: progress.userId,
      localUpdatedAt: progress.updatedAt.millisecondsSinceEpoch,
      operation: 'upsert',
    );
    await _syncRepository.enqueue(
      SyncOperation(
        id: 'progress:${progress.id}',
        userId: progress.userId,
        opType: 'progress.upsert',
        payload: {
          'progressId': progress.id,
          'lessonId': progress.lessonId,
          'status': progress.status,
          'quizScore': progress.quizScore,
          'timeSpentSeconds': progress.timeSpentSeconds,
          'updatedAt': progress.updatedAt.millisecondsSinceEpoch,
          'startedAt': progress.startedAt?.millisecondsSinceEpoch,
          'completedAt': progress.completedAt?.millisecondsSinceEpoch,
        },
        createdAt: progress.updatedAt,
      ),
    );
  }

  LessonQueryFilter _mapFilter(domain.LessonQuery? filter) {
    if (filter == null) {
      return const LessonQueryFilter();
    }
    return LessonQueryFilter(
      classes: filter.classes,
      age: filter.age,
      completion: _mapCompletion(filter.completion),
      userId: filter.userId,
    );
  }

  LessonCompletionState _mapCompletion(domain.LessonCompletionFilter filter) {
    switch (filter) {
      case domain.LessonCompletionFilter.all:
        return LessonCompletionState.all;
      case domain.LessonCompletionFilter.notStarted:
        return LessonCompletionState.notStarted;
      case domain.LessonCompletionFilter.inProgress:
        return LessonCompletionState.inProgress;
      case domain.LessonCompletionFilter.completed:
        return LessonCompletionState.completed;
    }
  }

  List<domain.Lesson> _mapLessons(List<LessonWithRelations> rows) =>
      rows.map(_mapLesson).toList();

  domain.Lesson _mapLesson(LessonWithRelations row) {
    final lesson = row.lesson;
    final ageRange = (lesson.ageMin != null || lesson.ageMax != null)
        ? domain.LessonAgeRange(
            min: lesson.ageMin ?? lesson.ageMax ?? 0,
            max: lesson.ageMax ?? lesson.ageMin ?? 0,
          )
        : null;
    return domain.Lesson(
      id: lesson.id,
      title: lesson.title,
      lessonClass: lesson.lessonClass,
      ageRange: ageRange,
      objectives: row.objectives.map((o) => o.objective).toList(),
      scriptures: row.scriptures
          .map(
            (s) => domain.LessonScriptureReference(
              reference: s.reference,
              translationId: s.translationId,
            ),
          )
          .toList(),
      contentHtml: lesson.contentHtml,
      teacherNotes: lesson.teacherNotes,
      attachments: row.attachments
          .map(
            (attachment) => domain.LessonAttachment(
              type: _mapAttachmentType(attachment.type),
              url: attachment.url,
              position: attachment.position,
              title: attachment.title,
              localPath: attachment.localPath,
            ),
          )
          .toList(),
      quizzes: row.quizzes.map(_mapQuiz).toList(),
      sourceUrl: lesson.sourceUrl,
      lastFetchedAt: lesson.lastFetchedAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(lesson.lastFetchedAt!),
      feedId: lesson.feedId,
      cohortId: lesson.cohortId,
    );
  }

  domain.LessonQuiz _mapQuiz(LessonQuizWithOptions quiz) {
    final answers = quiz.quiz.answer == null || quiz.quiz.answer!.isEmpty
        ? const <String>[]
        : List<String>.from(json.decode(quiz.quiz.answer!) as List<dynamic>);
    return domain.LessonQuiz(
      id: quiz.quiz.id,
      type: _mapQuizType(quiz.quiz.type),
      prompt: quiz.quiz.prompt,
      options: quiz.options.map((o) => o.label).toList(),
      answers: answers,
      position: quiz.quiz.position,
    );
  }

  domain.LessonAttachmentType _mapAttachmentType(String type) {
    switch (type.toLowerCase()) {
      case 'image':
        return domain.LessonAttachmentType.image;
      case 'audio':
        return domain.LessonAttachmentType.audio;
      case 'pdf':
        return domain.LessonAttachmentType.pdf;
      case 'video':
        return domain.LessonAttachmentType.video;
      case 'recording':
        return domain.LessonAttachmentType.recording;
      default:
        return domain.LessonAttachmentType.link;
    }
  }

  String _mapAttachmentTypeToString(domain.LessonAttachmentType type) {
    switch (type) {
      case domain.LessonAttachmentType.image:
        return 'image';
      case domain.LessonAttachmentType.audio:
        return 'audio';
      case domain.LessonAttachmentType.pdf:
        return 'pdf';
      case domain.LessonAttachmentType.video:
        return 'video';
      case domain.LessonAttachmentType.link:
        return 'link';
      case domain.LessonAttachmentType.recording:
        return 'recording';
    }
  }

  domain.LessonQuizType _mapQuizType(String type) {
    switch (type.toLowerCase()) {
      case 'true_false':
      case 'true-false':
        return domain.LessonQuizType.trueFalse;
      case 'short_answer':
      case 'short-answer':
        return domain.LessonQuizType.shortAnswer;
      case 'mcq':
      default:
        return domain.LessonQuizType.mcq;
    }
  }

  List<domain.LessonProgress> _mapProgressList(List<db.ProgressData> rows) {
    return rows
        .map(
          (row) => domain.LessonProgress(
            id: row.id,
            userId: row.userId,
            lessonId: row.lessonId,
            status: row.status,
            quizScore: row.quizScore,
            timeSpentSeconds: row.timeSpentSeconds,
            updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
            startedAt: row.startedAt == null
                ? null
                : DateTime.fromMillisecondsSinceEpoch(row.startedAt!),
            completedAt: row.completedAt == null
                ? null
                : DateTime.fromMillisecondsSinceEpoch(row.completedAt!),
          ),
        )
        .toList();
  }

  @override
  Future<domain.LessonAttachment> addAttachment(
    String lessonId,
    domain.LessonAttachment attachment,
  ) async {
    await _ensureSeeded();
    final existing = await (_db.select(_db.lessonAttachments)
          ..where((tbl) => tbl.lessonId.equals(lessonId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.position)])
          ..limit(1))
        .getSingleOrNull();
    final nextPosition = (existing?.position ?? -1) + 1;
    await _db.into(_db.lessonAttachments).insertOnConflictUpdate(
          LessonAttachmentsCompanion(
            lessonId: Value(lessonId),
            position: Value(nextPosition),
            type: Value(_mapAttachmentTypeToString(attachment.type)),
            title: Value(attachment.title),
            url: Value(attachment.url),
            localPath: Value(attachment.localPath),
          ),
        );
    return domain.LessonAttachment(
      type: attachment.type,
      url: attachment.url,
      position: nextPosition,
      title: attachment.title,
      localPath: attachment.localPath,
    );
  }
}
