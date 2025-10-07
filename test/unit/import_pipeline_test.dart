import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:afc_studymate/data/drift/app_database.dart';
import 'package:afc_studymate/data/models/enums.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('imports lessons from asset bundle', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final database = AppDatabase();
    await database.seedFromAssets();
    final lessons = await database.getLessonsByTrack(Track.beginners);
    expect(lessons, isNotEmpty);
  });
}
