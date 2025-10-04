// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../db/app_database.dart';
import 'lesson_sync_constants.dart';

Insertable<LessonSourceRow> _lessonSourceInsertable(
        LessonSourcesCompanion companion) =>
    companion;

class LessonSourceType {
  const LessonSourceType._();

  static const String asset = 'asset';
  static const String remote = 'remote';
}

class LessonSourceRegistry {
  LessonSourceRegistry(this._db);

  final AppDatabase _db;

  Future<void> registerBundledSources(AssetBundle bundle) async {
    final jsonString = await _safeLoad(bundle, 'assets/lessons/index.json');
    if (jsonString == null || jsonString.trim().isEmpty) {
      return;
    }

    Map<String, dynamic> data;
    try {
      data = json.decode(jsonString) as Map<String, dynamic>;
    } on FormatException {
      return;
    }

    final feeds = (data['feeds'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();

    for (final feed in feeds) {
      final assetPath = feed['assetPath'] as String?;
      if (assetPath == null) {
        continue;
      }
      final id = feed['id'] as String? ?? 'asset:$assetPath';
      await upsertSource(
        id: id,
        type: LessonSourceType.asset,
        location: 'asset:$assetPath',
        label: feed['title'] as String?,
        cohort: feed['title'] as String?,
        lessonClass: feed['class'] as String?,
        isBundled: true,
        quotaBytes: kDefaultLessonAttachmentQuotaBytes,
      );
    }
  }

  Future<void> upsertSource({
    required String id,
    required String type,
    required String location,
    String? label,
    String? cohort,
    String? lessonClass,
    bool isBundled = false,
    bool enabled = true,
    int? priority,
    int? quotaBytes,
  }) async {
    final existing = await (_db.select(_db.lessonSources)
          ..where((tbl) => (tbl as dynamic).id.equals(id)))
        .getSingleOrNull();
    final typedExisting = existing is LessonSourceRow ? existing : null;

    final effectiveEnabled = typedExisting == null
        ? (isBundled ? true : enabled)
        : (typedExisting.isBundled ? true : typedExisting.enabled);
    final effectivePriority = priority ?? typedExisting?.priority ?? 0;
    final effectiveQuota = quotaBytes ?? typedExisting?.quotaBytes;
    final effectiveIsBundled = typedExisting?.isBundled ?? isBundled;

    await _db.into(_db.lessonSources).insertOnConflictUpdate(
          _lessonSourceInsertable(
            LessonSourcesCompanion(
              id: Value(id),
              type: Value(type),
              location: Value(location),
              label: Value(label ?? typedExisting?.label),
              cohort: Value(cohort ?? typedExisting?.cohort),
              lessonClass: Value(lessonClass ?? typedExisting?.lessonClass),
              enabled: Value(effectiveEnabled),
              isBundled: Value(effectiveIsBundled),
              priority: Value(effectivePriority),
              quotaBytes: Value(effectiveQuota),
            ),
          ),
        );
  }

  Future<List<LessonSourceRow>> getEnabledSources() async {
    final query = _db.select(_db.lessonSources)
      ..where((tbl) => (tbl as dynamic).enabled.equals(true))
      ..orderBy([
        (tbl) => OrderingTerm(expression: (tbl as dynamic).priority),
      ]);
    final results = await query.get();
    return results.cast<LessonSourceRow>();
  }

  Future<List<LessonSourceRow>> getAllSources() {
    final query = _db.select(_db.lessonSources)
      ..orderBy([
        (tbl) => OrderingTerm(expression: (tbl as dynamic).priority),
      ]);
    return query.get().then((rows) => rows.cast<LessonSourceRow>());
  }

  Stream<List<LessonSourceRow>> watchSources() {
    final query = _db.select(_db.lessonSources)
      ..orderBy([
        (tbl) => OrderingTerm(expression: (tbl as dynamic).priority),
      ]);
    return query.watch().map((rows) => rows.cast<LessonSourceRow>());
  }

  Future<void> markAttempt(String id) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await (_db.update(_db.lessonSources)
          ..where((tbl) => (tbl as dynamic).id.equals(id)))
        .write(
          _lessonSourceInsertable(
            LessonSourcesCompanion(
              lastAttemptedAt: Value(now),
              lastError: const Value(null),
            ),
          ),
        );
  }

  Future<void> markChecked(
    String id, {
    String? etag,
    DateTime? lastModified,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await (_db.update(_db.lessonSources)
          ..where((tbl) => (tbl as dynamic).id.equals(id)))
        .write(
          _lessonSourceInsertable(
            LessonSourcesCompanion(
              lastCheckedAt: Value(now),
              etag: Value(etag),
              lastModified: Value(lastModified?.millisecondsSinceEpoch),
            ),
          ),
        );
  }

  Future<void> updateSuccess(
    String id, {
    required String checksum,
    int? lessonCount,
    String? etag,
    DateTime? lastModified,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await (_db.update(_db.lessonSources)
          ..where((tbl) => (tbl as dynamic).id.equals(id)))
        .write(
          _lessonSourceInsertable(
            LessonSourcesCompanion(
              checksum: Value(checksum),
              lessonCount: Value(lessonCount ?? 0),
              lastSyncedAt: Value(now),
              lastCheckedAt: Value(now),
              lastError: const Value(null),
              etag: Value(etag),
              lastModified: Value(lastModified?.millisecondsSinceEpoch),
            ),
          ),
        );
  }

  Future<void> updateAttachmentUsage(String id, int bytes) async {
    await (_db.update(_db.lessonSources)
          ..where((tbl) => (tbl as dynamic).id.equals(id)))
        .write(
          _lessonSourceInsertable(
            LessonSourcesCompanion(
              attachmentBytes: Value(bytes),
            ),
          ),
        );
  }

  Future<void> updateError(String id, String message) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await (_db.update(_db.lessonSources)
          ..where((tbl) => (tbl as dynamic).id.equals(id)))
        .write(
          _lessonSourceInsertable(
            LessonSourcesCompanion(
              lastAttemptedAt: Value(now),
              lastError: Value(message),
            ),
          ),
        );
  }

  Future<void> setEnabled(String id, bool enabled) async {
    await (_db.update(_db.lessonSources)
          ..where((tbl) => (tbl as dynamic).id.equals(id)))
        .write(
          _lessonSourceInsertable(
            LessonSourcesCompanion(
              enabled: Value(enabled),
            ),
          ),
        );
  }

  Future<String?> _safeLoad(AssetBundle bundle, String assetPath) async {
    try {
      return await bundle.loadString(assetPath);
    } on FlutterError {
      return null;
    }
  }
}
