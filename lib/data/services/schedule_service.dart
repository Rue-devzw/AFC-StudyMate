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
    return discoveryWeekIndexForDate(today);
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
    return weekIndexForTrackAt(track, today);
  }

  int discoveryWeekIndexForDate(DateTime date) {
    // Anchored so the current cycle aligns with live Discovery planning.
    return _weekIndexFromAnchor(DateTime(2026, 2, 23), date);
  }

  int weekIndexForTrackAt(Track track, DateTime date) {
    switch (track) {
      case Track.beginners:
        // Adjusted to align current live planner position.
        return _weekIndexFromAnchor(DateTime(2025, 11, 2), date);
      case Track.answer:
      case Track.search:
      case Track.primaryPals:
        // Anchored so the current Sunday School cycle aligns with lesson 81
        // for Answer/Search and 19c for Primary Pals on March 20, 2026.
        return _weekIndexFromAnchor(DateTime(2024, 9, 2), date);
      default:
        final anchor = DateTime(date.year);
        return _weekIndexFromAnchor(anchor, date);
    }
  }

  int _weekIndexFromAnchor(DateTime anchor, DateTime date) {
    final startOfCurrentWeek = _startOfWeek(date);
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
