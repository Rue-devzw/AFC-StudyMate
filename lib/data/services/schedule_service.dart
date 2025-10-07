import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/enums.dart';

final scheduleServiceProvider = Provider<ScheduleService>((ref) {
  return ScheduleService();
});

class ScheduleService {
  DateTime get today => DateTime.now();

  int get currentSundayWeekIndex {
    final now = today;
    final weekday = now.weekday % DateTime.daysPerWeek;
    final startOfWeek = now.subtract(Duration(days: weekday));
    final startOfYear = DateTime(now.year, 1, 1);
    final diff = startOfWeek.difference(startOfYear).inDays;
    return diff ~/ DateTime.daysPerWeek;
  }

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
}
