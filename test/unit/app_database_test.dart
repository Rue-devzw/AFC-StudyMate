import 'dart:io';

import 'package:afc_studymate/data/drift/app_database.dart';
import 'package:afc_studymate/data/models/enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppDatabase Discovery title resolution', () {
    test('uses canonical titles for question-only Discovery lessons', () async {
      final database = AppDatabase();
      final discoveryJson = await File(
        '/Users/Strive/Projects/AFC-StudyMate/assets/data/discovery_lessons.json',
      ).readAsString();

      await database.importLessonsFromAsset(
        'assets/data/discovery_lessons.json',
        Track.discovery,
        textLoader: (assetPath) async => discoveryJson,
      );

      final lessons = await database.getLessonsByTrack(Track.discovery);
      final lessonsById = <String, String>{
        for (final lesson in lessons) lesson.id: lesson.title,
      };

      expect(lessonsById['discovery_2'], 'Kings of Israel and Judah');
      expect(
        lessonsById['discovery_32'],
        'Inserted Lesson: Old Testament Prophecies Fulfilled in Christ',
      );
      expect(
        lessonsById['discovery_67'],
        'The Prophetic Consolation',
      );
      expect(
        lessonsById['discovery_139'],
        'Paul’s Second Letter to the Thessalonians',
      );

      expect(
        lessons.where((lesson) => lesson.title.startsWith('Study Questions')),
        isEmpty,
      );
    });
  });
}
