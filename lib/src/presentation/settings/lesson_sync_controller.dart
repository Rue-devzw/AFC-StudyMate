import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../infrastructure/db/app_database.dart';
import '../../infrastructure/lessons/lesson_source_registry.dart';
import '../../infrastructure/lessons/lesson_sync_service.dart';

class LessonSyncState {
  const LessonSyncState({
    this.isSyncing = false,
    this.lastRun,
    this.lastError,
    this.sources = const [],
  });

  final bool isSyncing;
  final DateTime? lastRun;
  final String? lastError;
  final List<LessonSourceStatus> sources;

  LessonSyncState copyWith({
    bool? isSyncing,
    DateTime? lastRun,
    String? lastError,
    bool lastErrorSet = false,
    List<LessonSourceStatus>? sources,
  }) {
    return LessonSyncState(
      isSyncing: isSyncing ?? this.isSyncing,
      lastRun: lastRun ?? this.lastRun,
      lastError: lastErrorSet ? lastError : this.lastError,
      sources: sources ?? this.sources,
    );
  }
}

class LessonSourceStatus {
  LessonSourceStatus({
    required this.id,
    required this.type,
    required this.location,
    required this.enabled,
    required this.isBundled,
    this.label,
    this.cohort,
    this.lessonClass,
    this.checksum,
    this.lessonCount,
    this.lastSyncedAt,
    this.lastAttemptedAt,
    this.lastCheckedAt,
    this.lastError,
    this.attachmentBytes = 0,
    this.quotaBytes,
  });

  final String id;
  final String type;
  final String location;
  final bool enabled;
  final bool isBundled;
  final String? label;
  final String? cohort;
  final String? lessonClass;
  final String? checksum;
  final int? lessonCount;
  final DateTime? lastSyncedAt;
  final DateTime? lastAttemptedAt;
  final DateTime? lastCheckedAt;
  final String? lastError;
  final int attachmentBytes;
  final int? quotaBytes;

  String get displayName => label ?? cohort ?? id;
}

class LessonSyncController extends StateNotifier<LessonSyncState> {
  LessonSyncController(this._registry, this._service)
      : super(const LessonSyncState()) {
    _subscription = _registry.watchSources().listen(_onSources);
    _loadInitial();
  }

  final LessonSourceRegistry _registry;
  final LessonSyncService _service;
  StreamSubscription<List<LessonSourceRow>>? _subscription;

  Future<void> _loadInitial() async {
    final rows = await _registry.getAllSources();
    state = state.copyWith(sources: rows.map(_mapRow).toList());
  }

  void _onSources(List<LessonSourceRow> rows) {
    state = state.copyWith(sources: rows.map(_mapRow).toList());
  }

  LessonSourceStatus _mapRow(LessonSourceRow row) {
    DateTime? convert(int? millis) {
      if (millis == null) return null;
      return DateTime.fromMillisecondsSinceEpoch(millis);
    }

    return LessonSourceStatus(
      id: row.id,
      type: row.type,
      location: row.location,
      enabled: row.enabled,
      isBundled: row.isBundled,
      label: row.label,
      cohort: row.cohort,
      lessonClass: row.lessonClass,
      checksum: row.checksum,
      lessonCount: row.lessonCount,
      lastSyncedAt: convert(row.lastSyncedAt),
      lastAttemptedAt: convert(row.lastAttemptedAt),
      lastCheckedAt: convert(row.lastCheckedAt),
      lastError: row.lastError,
      attachmentBytes: row.attachmentBytes,
      quotaBytes: row.quotaBytes,
    );
  }

  Future<void> syncNow() async {
    if (state.isSyncing) {
      return;
    }
    state = state.copyWith(isSyncing: true, lastError: null, lastErrorSet: true);
    try {
      final summary = await _service.syncAll(force: true);
      final error = summary.failureCount > 0
          ? '${summary.failureCount} source(s) failed to sync'
          : null;
      state = state.copyWith(
        isSyncing: false,
        lastRun: DateTime.now(),
        lastError: error,
        lastErrorSet: true,
      );
    } catch (error) {
      state = state.copyWith(
        isSyncing: false,
        lastRun: DateTime.now(),
        lastError: error.toString(),
        lastErrorSet: true,
      );
    }
  }

  Future<void> toggleSource(String id, bool enabled) {
    return _registry.setEnabled(id, enabled);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
