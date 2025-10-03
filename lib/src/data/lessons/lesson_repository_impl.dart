import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/lessons/entities.dart' as domain;
import '../../domain/lessons/repositories.dart';
import '../../infrastructure/db/app_database.dart' as db;
import '../../infrastructure/db/daos/lesson_dao.dart';

class LessonRepositoryImpl implements LessonRepository {
  LessonRepositoryImpl(this._db, this._dao);

  final db.AppDatabase _db;
  final LessonDao _dao;

  Future<void> _ensureSeeded() => _db.ensureSeeded();

  @override
  Stream<List<domain.Lesson>> watchLessons() async* {
    await _ensureSeeded();
    yield* _dao.watchLessons().map(_mapLessons);
  }

  @override
  Future<List<domain.Lesson>> getLessons() async {
    await _ensureSeeded();
    final rows = await _dao.getLessons();
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
  Future<void> upsertProgress(domain.LessonProgress progress) {
    final companion = db.ProgressCompanion(
      id: Value(progress.id),
      userId: Value(progress.userId),
      lessonId: Value(progress.lessonId),
      status: Value(progress.status),
      quizScore: Value(progress.quizScore),
      timeSpentSeconds: Value(progress.timeSpentSeconds),
      updatedAt: Value(progress.updatedAt.millisecondsSinceEpoch),
    );
    return _dao.upsertProgress(companion);
  }

  List<domain.Lesson> _mapLessons(List<db.Lesson> rows) => rows.map(_mapLesson).toList();

  domain.Lesson _mapLesson(db.Lesson row) {
    return domain.Lesson(
      id: row.id,
      title: row.title,
      lessonClass: row.lessonClass,
      ageMin: row.ageMin,
      ageMax: row.ageMax,
      objectives: _decodeList(row.objectives),
      scriptures: _decodeObjectList(row.scriptures),
      contentHtml: row.contentHtml,
      teacherNotes: row.teacherNotes,
      attachments: _decodeObjectList(row.attachments),
      quizzes: _decodeObjectList(row.quizzes),
      sourceUrl: row.sourceUrl,
      lastFetchedAt: row.lastFetchedAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(row.lastFetchedAt!),
    );
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
          ),
        )
        .toList();
  }

  List<String> _decodeList(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) {
      return const [];
    }
    return List<String>.from(json.decode(jsonString) as List<dynamic>);
  }

  List<Map<String, dynamic>> _decodeObjectList(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) {
      return const [];
    }
    return List<Map<String, dynamic>>.from(
      (json.decode(jsonString) as List<dynamic>).map(
        (entry) => Map<String, dynamic>.from(entry as Map),
      ),
    );
  }
}
