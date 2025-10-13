import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/enums.dart';

final scheduleServiceProvider = Provider<ScheduleService>((ref) {
  return ScheduleService();
});

class ScheduleService {
  DateTime get today => DateTime.now();

  int get currentSundayWeekIndex => weekIndexForTrack(Track.beginners);

  int get discoveryWeekIndex {
    final now = today;
    final weekday = now.weekday;
    final wednesday = now.subtract(Duration(days: (weekday - DateTime.wednesday) % DateTime.daysPerWeek));
    final startOfYear = DateTime(now.year, 1, 1);
    final diff = wednesday.difference(startOfYear).inDays;
    return diff ~/ DateTime.daysPerWeek;
  }

  int get daybreakIndex => int.parse(DateFormat('yyyyDDD').format(today));

  Track trackForRole(Track preferred) => preferred;

  int weekIndexForTrack(Track track) {
    switch (track) {
      case Track.search:
      case Track.primaryPals:
        return _weekIndexFromAnchor(DateTime(2024, 9, 1));
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
