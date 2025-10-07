import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../drift/app_database.dart';
import '../models/memory_verse.dart';

final memoryVerseServiceProvider = Provider<MemoryVerseService>((ref) {
  return MemoryVerseService(database: ref.read(appDatabaseProvider));
});

class MemoryVerseService {
  MemoryVerseService({required this.database});

  final AppDatabase database;

  Future<MemoryVerse> scheduleNext(MemoryVerse verse, {bool successful = true}) async {
    final ease = successful ? verse.easiness + 0.1 : max(1.3, verse.easiness - 0.2);
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
}
