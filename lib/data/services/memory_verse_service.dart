import 'dart:math';

import 'package:afc_studymate/data/drift/app_database.dart';
import 'package:afc_studymate/data/models/memory_verse.dart';
import 'package:afc_studymate/data/services/analytics_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final memoryVerseServiceProvider = Provider<MemoryVerseService>((ref) {
  return MemoryVerseService(
    analyticsService: ref.read(analyticsServiceProvider),
    database: ref.read(appDatabaseProvider),
  );
});

enum MemoryVerseReviewAction { again, hard, good, easy }

class MemoryVerseService {
  MemoryVerseService({required this.analyticsService, required this.database});

  final AnalyticsService analyticsService;
  final AppDatabase database;

  Future<MemoryVerse> scheduleNext(
    MemoryVerse verse, {
    bool successful = true,
  }) async {
    final ease = successful
        ? verse.easiness + 0.1
        : max(1.3, verse.easiness - 0.2);
    final repetitions = successful ? verse.repetitions + 1 : 0;
    final interval = _calculateInterval(repetitions, verse.intervalDays);
    final nextDue = DateTime.now().add(Duration(days: interval));
    final updated = verse.copyWith(
      easiness: ease,
      repetitions: repetitions,
      intervalDays: interval,
      dueDate: nextDue,
    );
    await database.upsertMemoryVerse(updated);
    return updated;
  }

  int _calculateInterval(int repetitions, int currentInterval) {
    if (repetitions <= 1) return 1;
    if (repetitions == 2) return 6;
    return (currentInterval * 1.5).round().clamp(1, 60);
  }

  Future<List<MemoryVerse>> getQueue() => database.getMemoryVerses();

  Future<List<MemoryVerse>> getDueQueue() async {
    final now = DateTime.now();
    final queue = await database.getMemoryVerses();
    final due =
        queue.where((verse) {
          final dueDate = verse.dueDate;
          if (dueDate == null) {
            return true;
          }
          return !dueDate.isAfter(now);
        }).toList()..sort((a, b) {
          final aDate = a.dueDate;
          final bDate = b.dueDate;
          if (aDate == null && bDate == null) return 0;
          if (aDate == null) return -1;
          if (bDate == null) return 1;
          return aDate.compareTo(bDate);
        });
    return due;
  }

  Future<MemoryVerse> reviewVerse(
    MemoryVerse verse,
    MemoryVerseReviewAction action,
  ) async {
    MemoryVerse updated;
    switch (action) {
      case MemoryVerseReviewAction.again:
        updated = await scheduleNext(verse, successful: false);
      case MemoryVerseReviewAction.hard:
        updated = verse.copyWith(
          easiness: max(1.3, verse.easiness - 0.15),
          repetitions: verse.repetitions + 1,
          intervalDays: 1,
          dueDate: DateTime.now().add(const Duration(days: 1)),
        );
        await database.upsertMemoryVerse(updated);
      case MemoryVerseReviewAction.good:
        updated = await scheduleNext(verse);
      case MemoryVerseReviewAction.easy:
        final interval = max(2, verse.intervalDays + 4);
        updated = verse.copyWith(
          easiness: verse.easiness + 0.2,
          repetitions: verse.repetitions + 1,
          intervalDays: interval,
          dueDate: DateTime.now().add(Duration(days: interval)),
        );
        await database.upsertMemoryVerse(updated);
    }
    await analyticsService.logMemoryVerseReviewed(
      verseId: verse.id,
      action: action.name,
    );
    return updated;
  }

  Future<void> addVerse(MemoryVerse verse) async {
    await database.upsertMemoryVerse(verse);
  }
}
