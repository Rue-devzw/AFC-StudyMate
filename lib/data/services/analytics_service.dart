import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/services/feature_flags_service.dart';
import 'package:afc_studymate/data/services/firebase_runtime_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  final flags = ref.read(featureFlagsProvider);
  final logger = Logger();

  if (!flags.enableAnalytics) {
    return NoopAnalyticsService(logger: logger);
  }

  return FirebaseAnalyticsService(
    runtime: ref.read(firebaseRuntimeServiceProvider),
    logger: logger,
  );
});

abstract class AnalyticsService {
  Future<void> initialise();

  Future<void> logLessonOpened({
    required String lessonId,
    required Track track,
    String? source,
  });

  Future<void> logLessonCompleted({
    required String lessonId,
    required Track track,
  });

  Future<void> logDaybreakRead({required String lessonId});

  Future<void> logJournalSaved({
    required String source,
    Track? track,
    String? lessonId,
  });

  Future<void> logMemoryVerseReviewed({
    required String verseId,
    required String action,
  });

  Future<void> logTeacherAttendanceMarked({
    required String studentId,
    required bool present,
    required String lessonId,
    required String dateKey,
  });
}

class NoopAnalyticsService implements AnalyticsService {
  NoopAnalyticsService({required this.logger});

  final Logger logger;

  @override
  Future<void> initialise() async {
    logger.i('Analytics disabled; no-op adapter active.');
  }

  @override
  Future<void> logDaybreakRead({required String lessonId}) async {}

  @override
  Future<void> logJournalSaved({
    required String source,
    Track? track,
    String? lessonId,
  }) async {}

  @override
  Future<void> logLessonCompleted({
    required String lessonId,
    required Track track,
  }) async {}

  @override
  Future<void> logLessonOpened({
    required String lessonId,
    required Track track,
    String? source,
  }) async {}

  @override
  Future<void> logMemoryVerseReviewed({
    required String verseId,
    required String action,
  }) async {}

  @override
  Future<void> logTeacherAttendanceMarked({
    required String studentId,
    required bool present,
    required String lessonId,
    required String dateKey,
  }) async {}
}

class FirebaseAnalyticsService implements AnalyticsService {
  FirebaseAnalyticsService({required this.runtime, required this.logger});

  final FirebaseRuntimeService runtime;
  final Logger logger;

  FirebaseAnalytics? _analytics;

  @override
  Future<void> initialise() async {
    final ready = await runtime.ensureInitialised();
    if (!ready) {
      return;
    }
    _analytics ??= FirebaseAnalytics.instance;
  }

  @override
  Future<void> logLessonOpened({
    required String lessonId,
    required Track track,
    String? source,
  }) async {
    await _log(
      'lesson_opened',
      <String, Object?>{
        'lesson_id': lessonId,
        'track': track.name,
        'source': ?source,
      },
    );
  }

  @override
  Future<void> logLessonCompleted({
    required String lessonId,
    required Track track,
  }) async {
    await _log('lesson_completed', <String, Object?>{
      'lesson_id': lessonId,
      'track': track.name,
    });
  }

  @override
  Future<void> logDaybreakRead({required String lessonId}) async {
    await _log('daybreak_read', <String, Object?>{'lesson_id': lessonId});
  }

  @override
  Future<void> logJournalSaved({
    required String source,
    Track? track,
    String? lessonId,
  }) async {
    await _log('journal_saved', <String, Object?>{
      'source': source,
      if (track != null) 'track': track.name,
      'lesson_id': ?lessonId,
    });
  }

  @override
  Future<void> logMemoryVerseReviewed({
    required String verseId,
    required String action,
  }) async {
    await _log('memory_verse_reviewed', <String, Object?>{
      'verse_id': verseId,
      'action': action,
    });
  }

  @override
  Future<void> logTeacherAttendanceMarked({
    required String studentId,
    required bool present,
    required String lessonId,
    required String dateKey,
  }) async {
    await _log('teacher_attendance_marked', <String, Object?>{
      'student_id': studentId,
      'present': present,
      'lesson_id': lessonId,
      'date_key': dateKey,
    });
  }

  Future<void> _log(String eventName, Map<String, Object?> parameters) async {
    try {
      await initialise();
      final analytics = _analytics;
      if (analytics == null) {
        return;
      }
      final sanitized = <String, Object>{
        for (final entry in parameters.entries)
          if (entry.value != null) entry.key: entry.value!,
      };
      await analytics.logEvent(
        name: eventName,
        parameters: sanitized,
      );
    } catch (error, stackTrace) {
      logger.w(
        'Analytics event dropped: $eventName',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
