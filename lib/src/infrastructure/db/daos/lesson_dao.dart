import 'package:drift/drift.dart';
import 'package:rxdart/rxdart.dart';

import '../app_database.dart';

class LessonDao {
  LessonDao(this._db);

  final AppDatabase _db;

  Stream<List<LessonWithRelations>> watchLessons(LessonQueryFilter filter) {
    final lessonsStream = _filteredQuery(filter).watch();
    final objectivesStream = _db.select(_db.lessonObjectives).watch();
    final scripturesStream = _db.select(_db.lessonScriptures).watch();
    final attachmentsStream = _db.select(_db.lessonAttachments).watch();
    final quizzesStream = _db.select(_db.lessonQuizzes).watch();
    final optionsStream = _db.select(_db.lessonQuizOptions).watch();

    return Rx.combineLatest6(
      lessonsStream,
      objectivesStream,
      scripturesStream,
      attachmentsStream,
      quizzesStream,
      optionsStream,
      (List<LessonRow> lessons,
          List<LessonObjectiveRow> objectives,
          List<LessonScriptureRow> scriptures,
          List<LessonAttachmentRow> attachments,
          List<LessonQuizRow> quizzes,
          List<LessonQuizOptionRow> options) {
        return _mapRelations(
          lessons,
          objectives,
          scriptures,
          attachments,
          quizzes,
          options,
        );
      },
    );
  }

  Future<List<LessonWithRelations>> getLessons(LessonQueryFilter filter) async {
    final lessons = await _filteredQuery(filter).get();
    if (lessons.isEmpty) {
      return const [];
    }
    final ids = lessons.map((lesson) => lesson.id).toList();
    final objectives = await (_db.select(_db.lessonObjectives)
          ..where((tbl) => tbl.lessonId.isIn(ids)))
        .get();
    final scriptures = await (_db.select(_db.lessonScriptures)
          ..where((tbl) => tbl.lessonId.isIn(ids)))
        .get();
    final attachments = (await (_db.select(_db.lessonAttachments)
              ..where((tbl) => tbl.lessonId.isIn(ids)))
            .get())
        .cast<LessonAttachmentRow>();
    final quizzes = await (_db.select(_db.lessonQuizzes)
          ..where((tbl) => tbl.lessonId.isIn(ids)))
        .get();
    final quizIds = quizzes.map((quiz) => quiz.id).toList();
    final options = quizIds.isEmpty
        ? <LessonQuizOptionRow>[]
        : await (_db.select(_db.lessonQuizOptions)
              ..where((tbl) => tbl.quizId.isIn(quizIds)))
            .get();

    return _mapRelations(
      lessons,
      objectives,
      scriptures,
      attachments,
      quizzes,
      options,
    );
  }

  Future<LessonWithRelations?> getLessonById(String id) async {
    final lesson = await (_db.select(_db.lessons)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    if (lesson == null) {
      return null;
    }
    final objectives = await (_db.select(_db.lessonObjectives)
          ..where((tbl) => tbl.lessonId.equals(id)))
        .get();
    final scriptures = await (_db.select(_db.lessonScriptures)
          ..where((tbl) => tbl.lessonId.equals(id)))
        .get();
    final attachments = (await (_db.select(_db.lessonAttachments)
              ..where((tbl) => tbl.lessonId.equals(id)))
            .get())
        .cast<LessonAttachmentRow>();
    final quizzes = await (_db.select(_db.lessonQuizzes)
          ..where((tbl) => tbl.lessonId.equals(id)))
        .get();
    final quizIds = quizzes.map((quiz) => quiz.id).toList();
    final options = quizIds.isEmpty
        ? <LessonQuizOptionRow>[]
        : await (_db.select(_db.lessonQuizOptions)
              ..where((tbl) => tbl.quizId.isIn(quizIds)))
            .get();

    final results = _mapRelations(
      [lesson],
      objectives,
      scriptures,
      attachments,
      quizzes,
      options,
    );
    return results.isEmpty ? null : results.first;
  }

  Stream<List<ProgressData>> watchProgress(String userId) {
    return (_db.select(_db.progress)..where((tbl) => tbl.userId.equals(userId))).watch();
  }

  Future<void> upsertProgress(ProgressCompanion companion) {
    return _db.into(_db.progress).insertOnConflictUpdate(companion);
  }

  SimpleSelectStatement<Lessons, LessonRow> _filteredQuery(
    LessonQueryFilter filter,
  ) {
    final query = _db.select(_db.lessons);
    if (filter.classes != null && filter.classes!.isNotEmpty) {
      query.where((tbl) => tbl.lessonClass.isIn(filter.classes!.toList()));
    }
    if (filter.age != null) {
      final age = filter.age!;
      query.where(
        (tbl) => ((tbl.ageMin.isNull() | tbl.ageMin.isSmallerOrEqualValue(age)) &
            (tbl.ageMax.isNull() | tbl.ageMax.isBiggerOrEqualValue(age))),
      );
    }

    final completion = filter.completion;
    if (completion != LessonCompletionState.all) {
      final progress = _db.progress;
      switch (completion) {
        case LessonCompletionState.completed:
          query.where(
            (tbl) => tbl.id.isInQuery(
              _db.selectOnly(progress)
                ..addColumns([progress.lessonId])
                ..where(progress.userId.equals(filter.userId))
                ..where(progress.lessonId.equalsExp(_db.lessons.id))
                ..where(progress.status.equals('completed')),
            ),
          );
          break;
        case LessonCompletionState.inProgress:
          query.where(
            (tbl) => tbl.id.isInQuery(
              _db.selectOnly(progress)
                ..addColumns([progress.lessonId])
                ..where(progress.userId.equals(filter.userId))
                ..where(progress.lessonId.equalsExp(_db.lessons.id))
                ..where(progress.status.equals('in_progress')),
            ),
          );
          break;
        case LessonCompletionState.notStarted:
          query.where(
            (tbl) => tbl.id.isNotInQuery(
              _db.selectOnly(progress)
                ..addColumns([progress.lessonId])
                ..where(progress.userId.equals(filter.userId))
                ..where(progress.lessonId.equalsExp(_db.lessons.id))
                ..where(
                  progress.status.equals('completed') |
                      progress.status.equals('in_progress'),
                ),
            ),
          );
          break;
        case LessonCompletionState.all:
          break;
      }
    }

    query.orderBy([(tbl) => OrderingTerm(expression: tbl.title)]);
    return query;
  }

  List<LessonWithRelations> _mapRelations(
    List<LessonRow> lessons,
    List<LessonObjectiveRow> objectives,
    List<LessonScriptureRow> scriptures,
    List<LessonAttachmentRow> attachments,
    List<LessonQuizRow> quizzes,
    List<LessonQuizOptionRow> options,
  ) {
    final lessonMap = {for (final lesson in lessons) lesson.id: lesson};
    if (lessonMap.isEmpty) {
      return const [];
    }

    final objectiveMap = <String, List<LessonObjectiveRow>>{};
    for (final objective in objectives) {
      final bucket = objectiveMap.putIfAbsent(objective.lessonId, () => []);
      bucket.add(objective);
    }

    final scriptureMap = <String, List<LessonScriptureRow>>{};
    for (final scripture in scriptures) {
      final bucket = scriptureMap.putIfAbsent(scripture.lessonId, () => []);
      bucket.add(scripture);
    }

    final attachmentMap = <String, List<LessonAttachmentRow>>{};
    for (final attachment in attachments) {
      final bucket = attachmentMap.putIfAbsent(attachment.lessonId, () => []);
      bucket.add(attachment);
    }

    final quizMap = <String, List<LessonQuizWithOptions>>{};
    final optionMap = <String, List<LessonQuizOptionRow>>{};
    for (final option in options) {
      final bucket = optionMap.putIfAbsent(option.quizId, () => []);
      bucket.add(option);
    }
    for (final quiz in quizzes) {
      final quizOptions = (optionMap[quiz.id] ?? [])
        ..sort((a, b) => a.position.compareTo(b.position));
      final bucket = quizMap.putIfAbsent(quiz.lessonId, () => []);
      bucket.add(LessonQuizWithOptions(quiz: quiz, options: quizOptions));
    }

    return lessons.map((lesson) {
      final lessonObjectives = (objectiveMap[lesson.id] ?? [])
        ..sort((a, b) => a.position.compareTo(b.position));
      final lessonScriptures = (scriptureMap[lesson.id] ?? [])
        ..sort((a, b) => a.position.compareTo(b.position));
      final lessonAttachments = (attachmentMap[lesson.id] ?? [])
        ..sort((a, b) => a.position.compareTo(b.position));
      final lessonQuizzes = quizMap[lesson.id] ?? [];
      lessonQuizzes.sort((a, b) => a.quiz.position.compareTo(b.quiz.position));
      return LessonWithRelations(
        lesson: lesson,
        objectives: List.unmodifiable(lessonObjectives),
        scriptures: List.unmodifiable(lessonScriptures),
        attachments: List.unmodifiable(lessonAttachments),
        quizzes: List.unmodifiable(lessonQuizzes),
      );
    }).toList();
  }
}

class LessonWithRelations {
  LessonWithRelations({
    required this.lesson,
    required this.objectives,
    required this.scriptures,
    required this.attachments,
    required this.quizzes,
  });

  final LessonRow lesson;
  final List<LessonObjectiveRow> objectives;
  final List<LessonScriptureRow> scriptures;
  final List<LessonAttachmentRow> attachments;
  final List<LessonQuizWithOptions> quizzes;
}

class LessonQuizWithOptions {
  LessonQuizWithOptions({required this.quiz, required this.options});

  final LessonQuizRow quiz;
  final List<LessonQuizOptionRow> options;
}

class LessonQueryFilter {
  const LessonQueryFilter({
    this.classes,
    this.age,
    this.completion = LessonCompletionState.all,
    this.userId = 'local-user',
  });

  final Set<String>? classes;
  final int? age;
  final LessonCompletionState completion;
  final String userId;
}

enum LessonCompletionState { all, notStarted, inProgress, completed }
