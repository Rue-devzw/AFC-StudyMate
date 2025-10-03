import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

import '../db/app_database.dart';
import 'lesson_sync_constants.dart';

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
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();

    final effectiveEnabled = existing == null
        ? (isBundled ? true : enabled)
        : (existing.isBundled ? true : existing.enabled);
    final effectivePriority = priority ?? existing?.priority ?? 0;
    final effectiveQuota = quotaBytes ?? existing?.quotaBytes;
    final effectiveIsBundled = existing?.isBundled ?? isBundled;

    await _db.into(_db.lessonSources).insertOnConflictUpdate(
          LessonSourcesCompanion(
            id: Value(id),
            type: Value(type),
            location: Value(location),
            label: Value(label ?? existing?.label),
            cohort: Value(cohort ?? existing?.cohort),
            lessonClass: Value(lessonClass ?? existing?.lessonClass),
            enabled: Value(effectiveEnabled),
            isBundled: Value(effectiveIsBundled),
            priority: Value(effectivePriority),
            quotaBytes: Value(effectiveQuota),
          ),
        );
  }

  Future<List<LessonSourceRow>> getEnabledSources() async {
    final query = _db.select(_db.lessonSources)
      ..where((tbl) => tbl.enabled.equals(true))
      ..orderBy([(tbl) => OrderingTerm(expression: tbl.priority)]);
    return query.get();
  }

  Future<List<LessonSourceRow>> getAllSources() {
    final query = _db.select(_db.lessonSources)
      ..orderBy([(tbl) => OrderingTerm(expression: tbl.priority)]);
    return query.get();
  }

  Stream<List<LessonSourceRow>> watchSources() {
    final query = _db.select(_db.lessonSources)
      ..orderBy([(tbl) => OrderingTerm(expression: tbl.priority)]);
    return query.watch();
  }

  Future<void> markAttempt(String id) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await (_db.update(_db.lessonSources)
          ..where((tbl) => tbl.id.equals(id)))
        .write(
          LessonSourcesCompanion(
            lastAttemptedAt: Value(now),
            lastError: const Value(null),
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
          ..where((tbl) => tbl.id.equals(id)))
        .write(
          LessonSourcesCompanion(
            lastCheckedAt: Value(now),
            etag: Value(etag),
            lastModified: Value(lastModified?.millisecondsSinceEpoch),
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
          ..where((tbl) => tbl.id.equals(id)))
        .write(
          LessonSourcesCompanion(
            checksum: Value(checksum),
            lessonCount: Value(lessonCount ?? 0),
            lastSyncedAt: Value(now),
            lastCheckedAt: Value(now),
            lastError: const Value(null),
            etag: Value(etag),
            lastModified: Value(lastModified?.millisecondsSinceEpoch),
          ),
        );
  }

  Future<void> updateAttachmentUsage(String id, int bytes) async {
    await (_db.update(_db.lessonSources)
          ..where((tbl) => tbl.id.equals(id)))
        .write(
          LessonSourcesCompanion(
            attachmentBytes: Value(bytes),
          ),
        );
  }

  Future<void> updateError(String id, String message) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await (_db.update(_db.lessonSources)
          ..where((tbl) => tbl.id.equals(id)))
        .write(
          LessonSourcesCompanion(
            lastAttemptedAt: Value(now),
            lastError: Value(message),
          ),
        );
  }

  Future<void> setEnabled(String id, bool enabled) async {
    await (_db.update(_db.lessonSources)
          ..where((tbl) => tbl.id.equals(id)))
        .write(
          LessonSourcesCompanion(
            enabled: Value(enabled),
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
