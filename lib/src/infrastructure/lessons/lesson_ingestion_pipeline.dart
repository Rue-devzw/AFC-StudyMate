import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../db/app_database.dart';
import 'lesson_source_registry.dart';

class LessonIngestionPipeline {
  LessonIngestionPipeline(
    this._db,
    this._bundle, {
    LessonSourceRegistry? registry,
    http.Client? httpClient,
  })  : _registry = registry,
        _httpClient = httpClient ?? http.Client();

  final AppDatabase _db;
  final AssetBundle _bundle;
  final LessonSourceRegistry? _registry;
  final http.Client _httpClient;

  Future<void>? _bundledIngestion;

  Future<void> ensureBundledFeeds() {
    return _bundledIngestion ??= _ingestBundledFeeds();
  }

  Future<void> _ingestBundledFeeds() async {
    await _registry?.registerBundledSources(_bundle);
    final indexJson = await _safeLoadString('assets/lessons/index.json');
    if (indexJson == null || indexJson.trim().isEmpty) {
      return;
    }

    Map<String, dynamic> index;
    try {
      index = json.decode(indexJson) as Map<String, dynamic>;
    } on FormatException {
      return;
    }

    final feeds = (index['feeds'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();

    for (final feed in feeds) {
      final assetPath = feed['assetPath'] as String?;
      if (assetPath == null) {
        continue;
      }
      await ingestAssetFeed(
        assetPath: assetPath,
        feedId: feed['id'] as String? ?? 'asset:$assetPath',
        fallbackClass: feed['class'] as String?,
        fallbackTitle: feed['title'] as String?,
      );
    }
  }

  Future<LessonFeedIngestionResult> ingestRemoteFeed(Uri uri,
      {String? feedId}) async {
    final response = await _httpClient.get(uri);
    if (response.statusCode >= 400) {
      throw http.ClientException(
        'Failed to download lesson feed (status ${response.statusCode})',
        uri,
      );
    }

    final bodyBytes = response.bodyBytes;
    final checksum = sha1.convert(bodyBytes).toString();
    final parsed = _parseFeed(utf8.decode(bodyBytes));

    DateTime? lastModified;
    final lastModifiedHeader = response.headers['last-modified'];
    if (lastModifiedHeader != null) {
      try {
        lastModified = HttpDate.parse(lastModifiedHeader);
      } on FormatException {
        lastModified = null;
      }
    }

    final id = feedId ?? uri.toString();
    await _registry?.upsertSource(
      id: id,
      type: LessonSourceType.remote,
      location: uri.toString(),
    );

    final result = await _persistFeed(
      feedId: feedId ?? uri.toString(),
      source: uri.toString(),
      checksum: checksum,
      cohortTitle: parsed.cohortTitle,
      cohortClass: parsed.cohortClass,
      lessons: parsed.lessons,
      etag: response.headers['etag'],
      lastModified: lastModified,
    );

    await _registry?.updateSuccess(
      id,
      checksum: result.checksum,
      etag: result.etag,
      lastModified: result.lastModified,
      lessonCount: result.lessonCount,
    );

    return result;
  }

  Future<LessonFeedIngestionResult?> ingestAssetFeed({
    required String assetPath,
    required String feedId,
    String? fallbackClass,
    String? fallbackTitle,
  }) async {
    await _registry?.upsertSource(
      id: feedId,
      type: LessonSourceType.asset,
      location: 'asset:$assetPath',
      label: fallbackTitle,
      lessonClass: fallbackClass,
      cohort: fallbackTitle,
      isBundled: true,
    );

    final jsonString = await _safeLoadString(assetPath);
    if (jsonString == null) {
      return null;
    }

    final checksum = sha1.convert(utf8.encode(jsonString)).toString();
    final parsed = _parseFeed(
      jsonString,
      fallbackClass: fallbackClass,
    );

    final result = await _persistFeed(
      feedId: feedId,
      source: 'asset:$assetPath',
      checksum: checksum,
      cohortTitle: parsed.cohortTitle ?? fallbackTitle,
      cohortClass: parsed.cohortClass ?? fallbackClass,
      lessons: parsed.lessons,
    );

    await _registry?.updateSuccess(
      feedId,
      checksum: result.checksum,
      lessonCount: result.lessonCount,
    );

    return result;
  }

  Future<LessonFeedIngestionResult> _persistFeed({
    required String feedId,
    required String source,
    required String checksum,
    required List<_ParsedLesson> lessons,
    String? cohortTitle,
    String? cohortClass,
    String? etag,
    DateTime? lastModified,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final lessonIds = lessons.map((lesson) => lesson.id).toList();

    LessonFeedIngestionResult? result;
    await _db.transaction(() async {
      if (lessonIds.isNotEmpty) {
        final existing = await (_db.select(_db.lessons)
              ..where((tbl) => tbl.feedId.equals(feedId)))
            .get();
        final existingIds = existing.map<String>((row) => row.id).toSet();
        final incomingIds = lessons.map((lesson) => lesson.id).toSet();
        final toDelete = existingIds.difference(incomingIds);
        if (toDelete.isNotEmpty) {
          await (_db.delete(_db.lessons)
                ..where((tbl) => tbl.id.isIn(toDelete.toList())))
              .go();
        }
      }

      for (final lesson in lessons) {
        await _db.into(_db.lessons).insertOnConflictUpdate(
              LessonsCompanion(
                id: Value(lesson.id),
                title: Value(lesson.title),
                lessonClass: Value(lesson.lessonClass ?? cohortClass ?? 'General'),
                ageMin: Value(lesson.ageMin),
                ageMax: Value(lesson.ageMax),
                contentHtml: Value(lesson.contentHtml),
                teacherNotes: Value(lesson.teacherNotes),
                sourceUrl: Value(lesson.sourceUrl),
                lastFetchedAt: Value(now),
                feedId: Value(feedId),
                cohortId: Value(lesson.cohortId ?? feedId),
              ),
            );
      }

      if (lessonIds.isNotEmpty) {
        await (_db.delete(_db.lessonObjectives)
              ..where((tbl) => tbl.lessonId.isIn(lessonIds)))
            .go();
        await (_db.delete(_db.lessonScriptures)
              ..where((tbl) => tbl.lessonId.isIn(lessonIds)))
            .go();
        await (_db.delete(_db.lessonAttachments)
              ..where((tbl) => tbl.lessonId.isIn(lessonIds)))
            .go();
        await (_db.delete(_db.lessonQuizzes)
              ..where((tbl) => tbl.lessonId.isIn(lessonIds)))
            .go();
      }

      if (lessons.isEmpty) {
        result = LessonFeedIngestionResult(
          feedId: feedId,
          checksum: checksum,
          lessonIds: const [],
          etag: etag,
          lastModified: lastModified,
        );
        return;
      }

      await _db.batch((batch) {
        final objectives = <LessonObjectivesCompanion>[];
        final scriptures = <LessonScripturesCompanion>[];
        final attachments = <LessonAttachmentsCompanion>[];
        final quizzes = <LessonQuizzesCompanion>[];
        final options = <LessonQuizOptionsCompanion>[];

        for (final lesson in lessons) {
          for (var i = 0; i < lesson.objectives.length; i++) {
            objectives.add(
              LessonObjectivesCompanion.insert(
                lessonId: lesson.id,
                position: i,
                objective: lesson.objectives[i],
              ),
            );
          }

          for (var i = 0; i < lesson.scriptures.length; i++) {
            final scripture = lesson.scriptures[i];
            scriptures.add(
              LessonScripturesCompanion.insert(
                lessonId: lesson.id,
                position: i,
                reference: scripture.reference,
                translationId: Value(scripture.translationId),
              ),
            );
          }

          for (var i = 0; i < lesson.attachments.length; i++) {
            final attachment = lesson.attachments[i];
            attachments.add(
              LessonAttachmentsCompanion.insert(
                lessonId: lesson.id,
                position: i,
                type: attachment.type,
                title: Value(attachment.title),
                url: attachment.url,
              ),
            );
          }

          for (var i = 0; i < lesson.quizzes.length; i++) {
            final quiz = lesson.quizzes[i];
            quizzes.add(
              LessonQuizzesCompanion.insert(
                id: quiz.id,
                lessonId: lesson.id,
                position: i,
                type: quiz.type,
                prompt: quiz.prompt,
                answer: Value(quiz.answerJson),
              ),
            );
            for (var j = 0; j < quiz.options.length; j++) {
              final option = quiz.options[j];
              options.add(
                LessonQuizOptionsCompanion.insert(
                  quizId: quiz.id,
                  position: j,
                  label: option.label,
                  isCorrect: Value(option.isCorrect),
                ),
              );
            }
          }
        }

        if (objectives.isNotEmpty) {
          batch.insertAll(
            _db.lessonObjectives,
            objectives,
            mode: InsertMode.insertOrReplace,
          );
        }
        if (scriptures.isNotEmpty) {
          batch.insertAll(
            _db.lessonScriptures,
            scriptures,
            mode: InsertMode.insertOrReplace,
          );
        }
        if (attachments.isNotEmpty) {
          batch.insertAll(
            _db.lessonAttachments,
            attachments,
            mode: InsertMode.insertOrReplace,
          );
        }
        if (quizzes.isNotEmpty) {
          batch.insertAll(
            _db.lessonQuizzes,
            quizzes,
            mode: InsertMode.insertOrReplace,
          );
        }
        if (options.isNotEmpty) {
          batch.insertAll(
            _db.lessonQuizOptions,
            options,
            mode: InsertMode.insertOrReplace,
          );
        }
      });
    });

    await _db.into(_db.lessonFeeds).insertOnConflictUpdate(
          LessonFeedsCompanion(
            id: Value(feedId),
            source: Value(source),
            cohort: Value(cohortTitle),
            lessonClass: Value(cohortClass),
            checksum: Value(checksum),
            etag: Value(etag),
            lastModified: Value(lastModified?.millisecondsSinceEpoch),
            lastFetchedAt: Value(now),
            lastCheckedAt: Value(now),
          ),
        );

    final resolvedResult = result ??= LessonFeedIngestionResult(
      feedId: feedId,
      checksum: checksum,
      lessonIds: lessonIds,
      etag: etag,
      lastModified: lastModified,
    );

    return resolvedResult;
  }

  Future<String?> _safeLoadString(String assetPath) async {
    try {
      return await _bundle.loadString(assetPath);
    } on FlutterError {
      return null;
    }
  }

  _ParsedFeed _parseFeed(String jsonString, {String? fallbackClass}) {
    dynamic data;
    try {
      data = json.decode(jsonString);
    } on FormatException {
      return const _ParsedFeed(lessons: []);
    }

    if (data is Map<String, dynamic>) {
      final lessons = (data['lessons'] as List<dynamic>? ?? const [])
          .map(
            (lesson) => _parseLesson(
              lesson as Map<String, dynamic>,
              fallbackClass: data['class'] as String? ?? fallbackClass,
              cohortId: data['cohortId'] as String?,
            ),
          )
          .whereType<_ParsedLesson>()
          .toList();
      return _ParsedFeed(
        cohortId: data['cohortId'] as String?,
        cohortTitle: data['title'] as String?,
        cohortClass: data['class'] as String? ?? fallbackClass,
        lessons: lessons,
      );
    } else if (data is List) {
      final lessons = data
          .map((lesson) => lesson as Map<String, dynamic>)
          .map(
            (lesson) => _parseLesson(
              lesson,
              fallbackClass: fallbackClass,
              cohortId: fallbackClass,
            ),
          )
          .whereType<_ParsedLesson>()
          .toList();
      return _ParsedFeed(
        cohortClass: fallbackClass,
        lessons: lessons,
      );
    }

    return const _ParsedFeed(lessons: []);
  }

  _ParsedLesson? _parseLesson(
    Map<String, dynamic> json, {
    String? fallbackClass,
    String? cohortId,
  }) {
    final id = json['id'] as String?;
    final title = json['title'] as String?;
    if (id == null || title == null) {
      return null;
    }

    final lessonClass = json['class'] as String? ?? fallbackClass;
    final ageRange = json['ageRange'];
    int? ageMin;
    int? ageMax;
    if (ageRange is Map<String, dynamic>) {
      ageMin = (ageRange['min'] as num?)?.toInt();
      ageMax = (ageRange['max'] as num?)?.toInt();
    } else if (ageRange is String) {
      final parts = ageRange
          .split(RegExp(r'[^0-9]+'))
          .where((part) => part.isNotEmpty)
          .toList();
      if (parts.isNotEmpty) {
        ageMin = int.tryParse(parts.first);
        ageMax = int.tryParse(parts.length > 1 ? parts.last : parts.first);
      }
    }

    final objectives = (json['objectives'] as List<dynamic>? ?? const [])
        .whereType<String>()
        .toList();

    final scriptures = (json['scriptures'] as List<dynamic>? ?? const [])
        .map((entry) => entry as Map<String, dynamic>)
        .map(
          (entry) => _ParsedScripture(
            reference: entry['ref'] as String? ?? '',
            translationId: entry['tId'] as String?,
          ),
        )
        .where((scripture) => scripture.reference.isNotEmpty)
        .toList();

    final attachments = (json['attachments'] as List<dynamic>? ?? const [])
        .map((entry) => entry as Map<String, dynamic>)
        .map(
          (entry) => _ParsedAttachment(
            type: entry['type'] as String? ?? 'link',
            title: entry['title'] as String?,
            url: entry['url'] as String? ?? '',
          ),
        )
        .where((attachment) => attachment.url.isNotEmpty)
        .toList();

    final quizzes = (json['quizzes'] as List<dynamic>? ?? const [])
        .map((entry) => entry as Map<String, dynamic>)
        .map(_parseQuiz)
        .whereType<_ParsedQuiz>()
        .toList();

    return _ParsedLesson(
      id: id,
      title: title,
      lessonClass: lessonClass,
      ageMin: ageMin,
      ageMax: ageMax,
      objectives: objectives,
      scriptures: scriptures,
      attachments: attachments,
      quizzes: quizzes,
      contentHtml: json['contentHtml'] as String?,
      teacherNotes: json['teacherNotes'] as String?,
      sourceUrl: json['sourceUrl'] as String?,
      cohortId: json['cohortId'] as String? ?? cohortId,
    );
  }

  _ParsedQuiz? _parseQuiz(Map<String, dynamic> json) {
    final id = json['id'] as String? ?? json['prompt'] as String?;
    final prompt = json['prompt'] as String?;
    if (id == null || prompt == null) {
      return null;
    }
    final type = (json['type'] as String? ?? 'mcq').toLowerCase();

    final rawOptions = (json['options'] as List<dynamic>? ?? const [])
        .map((option) => option.toString())
        .toList();

    final answerValue = json['answer'];
    final answers = <String>[];
    if (answerValue is List) {
      answers.addAll(answerValue.map((e) => e.toString()));
    } else if (answerValue != null) {
      answers.add(answerValue.toString());
    }

    final options = <_ParsedQuizOption>[];
    if (rawOptions.isEmpty && answers.isNotEmpty) {
      for (final answer in answers) {
        options.add(_ParsedQuizOption(label: answer, isCorrect: true));
      }
    } else {
      for (final option in rawOptions) {
        options.add(
          _ParsedQuizOption(
            label: option,
            isCorrect: answers.contains(option),
          ),
        );
      }
    }

    return _ParsedQuiz(
      id: id,
      type: type,
      prompt: prompt,
      options: options,
      answers: answers,
    );
  }

  void dispose() {
    _httpClient.close();
  }
}

class LessonFeedIngestionResult {
  const LessonFeedIngestionResult({
    required this.feedId,
    required this.checksum,
    required this.lessonIds,
    this.etag,
    this.lastModified,
  });

  final String feedId;
  final String checksum;
  final List<String> lessonIds;
  final String? etag;
  final DateTime? lastModified;

  int get lessonCount => lessonIds.length;
}

class _ParsedFeed {
  const _ParsedFeed({
    this.cohortId,
    this.cohortTitle,
    this.cohortClass,
    required this.lessons,
  });

  final String? cohortId;
  final String? cohortTitle;
  final String? cohortClass;
  final List<_ParsedLesson> lessons;
}

class _ParsedLesson {
  const _ParsedLesson({
    required this.id,
    required this.title,
    this.lessonClass,
    this.ageMin,
    this.ageMax,
    required this.objectives,
    required this.scriptures,
    required this.attachments,
    required this.quizzes,
    this.contentHtml,
    this.teacherNotes,
    this.sourceUrl,
    this.cohortId,
  });

  final String id;
  final String title;
  final String? lessonClass;
  final int? ageMin;
  final int? ageMax;
  final List<String> objectives;
  final List<_ParsedScripture> scriptures;
  final List<_ParsedAttachment> attachments;
  final List<_ParsedQuiz> quizzes;
  final String? contentHtml;
  final String? teacherNotes;
  final String? sourceUrl;
  final String? cohortId;
}

class _ParsedScripture {
  const _ParsedScripture({
    required this.reference,
    this.translationId,
  });

  final String reference;
  final String? translationId;
}

class _ParsedAttachment {
  const _ParsedAttachment({
    required this.type,
    required this.url,
    this.title,
  });

  final String type;
  final String url;
  final String? title;
}

class _ParsedQuiz {
  const _ParsedQuiz({
    required this.id,
    required this.type,
    required this.prompt,
    required this.options,
    required this.answers,
  });

  final String id;
  final String type;
  final String prompt;
  final List<_ParsedQuizOption> options;
  final List<String> answers;

  String get answerJson => json.encode(answers);
}

class _ParsedQuizOption {
  const _ParsedQuizOption({
    required this.label,
    required this.isCorrect,
  });

  final String label;
  final bool isCorrect;
}
