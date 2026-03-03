import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/services/schedule_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeScheduleService extends ScheduleService {
  _FakeScheduleService(this._date);

  final DateTime _date;

  @override
  DateTime get today => _date;
}

void main() {
  group('ScheduleService weekly rollover', () {
    test('beginners planner anchor aligns current live schedule', () {
      final beforeAnchorWeek =
          _FakeScheduleService(DateTime(2025, 11, 1, 23, 59));
      final firstPlannerSunday = _FakeScheduleService(DateTime(2025, 11, 2));
      final followingMonday = _FakeScheduleService(DateTime(2025, 11, 3));

      expect(beforeAnchorWeek.weekIndexForTrack(Track.beginners), 0);
      expect(firstPlannerSunday.weekIndexForTrack(Track.beginners), 0);
      expect(followingMonday.weekIndexForTrack(Track.beginners), 1);
    });

    test('week index changes at Monday midnight for Sunday School tracks', () {
      final sunday = _FakeScheduleService(DateTime(2026, 3, 8, 23, 59));
      final monday = _FakeScheduleService(DateTime(2026, 3, 9));

      final sundayIndex = sunday.weekIndexForTrack(Track.search);
      final mondayIndex = monday.weekIndexForTrack(Track.search);

      expect(mondayIndex, sundayIndex + 1);
    });

    test('discovery week index changes at Monday midnight', () {
      final sunday = _FakeScheduleService(DateTime(2026, 3, 8, 23, 59));
      final monday = _FakeScheduleService(DateTime(2026, 3, 9));

      final sundayIndex = sunday.discoveryWeekIndex;
      final mondayIndex = monday.discoveryWeekIndex;

      expect(mondayIndex, sundayIndex + 1);
    });
  });
}
