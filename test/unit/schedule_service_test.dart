import 'package:flutter_test/flutter_test.dart';

import 'package:afc_studymate/data/services/schedule_service.dart';

void main() {
  test('calculates Sunday week index consistently', () {
    final service = ScheduleService();
    final index = service.currentSundayWeekIndex;
    expect(index, greaterThanOrEqualTo(0));
  });

  test('calculates discovery week index', () {
    final service = ScheduleService();
    final index = service.discoveryWeekIndex;
    expect(index, greaterThanOrEqualTo(0));
  });
}
