import 'dart:async';

import 'lesson_sync_service.dart';

class LessonCacheInvalidator {
  LessonCacheInvalidator(
    this._service, {
    Duration interval = const Duration(hours: 6),
  }) : _interval = interval;

  final LessonSyncService _service;
  final Duration _interval;

  Timer? _timer;
  bool _started = false;

  void start() {
    if (_started) {
      return;
    }
    _started = true;
    _timer ??= Timer.periodic(_interval, (_) {
      _service.syncAll();
    });
    scheduleMicrotask(() async {
      await _service.ensureBackgroundScheduled();
      await _service.syncAll();
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}
