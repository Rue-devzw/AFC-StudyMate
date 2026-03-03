import 'dart:math';

import 'package:afc_studymate/data/models/enums.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final scheduleServiceProvider = Provider<ScheduleService>((ref) {
  return ScheduleService();
});

class ScheduleService {
  DateTime get today => DateTime.now();

  int get currentSundayWeekIndex => weekIndexForTrack(Track.beginners);

  int get discoveryWeekIndex {
    // Anchored so the current cycle aligns with live Discovery planning.
    return _weekIndexFromAnchor(DateTime(2026, 2, 23));
  }

  int get daybreakIndex {
    return daybreakIndexForDate(today);
  }

  int daybreakIndexForDate(DateTime date) {
    final anchor = DateTime(2026, 2, 21);
    final normalized = DateTime(date.year, date.month, date.day);
    return max(0, normalized.difference(anchor).inDays);
  }

  Track trackForRole(Track preferred) => preferred;

  int weekIndexForTrack(Track track) {
    switch (track) {
      case Track.beginners:
        // Adjusted to align current live planner position.
        return _weekIndexFromAnchor(DateTime(2025, 11, 2));
      case Track.search:
      case Track.primaryPals:
        return _weekIndexFromAnchor(DateTime(2024, 8, 25));
      default:
        final anchor = DateTime(today.year);
        return _weekIndexFromAnchor(anchor);
    }
  }

  int _weekIndexFromAnchor(DateTime anchor) {
    final startOfCurrentWeek = _startOfWeek(today);
    final startOfAnchorWeek = _startOfWeek(anchor);
    final diffDays = startOfCurrentWeek.difference(startOfAnchorWeek).inDays;
    final weeks = diffDays ~/ DateTime.daysPerWeek;
    return max(0, weeks);
  }

  DateTime _startOfWeek(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    final daysFromMonday = (normalized.weekday + 6) % DateTime.daysPerWeek;
    return normalized.subtract(Duration(days: daysFromMonday));
  }
}
