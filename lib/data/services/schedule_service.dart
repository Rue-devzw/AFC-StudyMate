import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/enums.dart';

final scheduleServiceProvider = Provider<ScheduleService>((ref) {
  return ScheduleService();
});

class ScheduleService {
  DateTime get today => DateTime.now();

  int get currentSundayWeekIndex => weekIndexForTrack(Track.beginners);

  int get discoveryWeekIndex {
    return _weekIndexFromAnchor(DateTime(2023, 10, 5));
  }

  int get daybreakIndex {
    final anchor = DateTime(2026, 2, 21);
    final normalizedToday = DateTime(today.year, today.month, today.day);
    return max(0, normalizedToday.difference(anchor).inDays);
  }

  Track trackForRole(Track preferred) => preferred;

  int weekIndexForTrack(Track track) {
    switch (track) {
      case Track.search:
      case Track.primaryPals:
        return _weekIndexFromAnchor(DateTime(2024, 8, 25));
      default:
        final anchor = DateTime(today.year, 1, 1);
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
