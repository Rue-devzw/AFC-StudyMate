import 'package:afc_studymate/features/sunday_school/beginners/beginners_lesson_view.dart';
import 'package:afc_studymate/data/models/lesson.dart';
import 'package:afc_studymate/data/models/bible_ref.dart';
import 'package:afc_studymate/data/models/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  testGoldens('beginners lesson renders section', (tester) async {
    final lesson = Lesson(
      id: 'b1',
      track: Track.beginners,
      title: 'God Made the World',
      bibleReferences: const <BibleRef>[BibleRef(book: 'Genesis', chapter: 1, verseStart: 1, verseEnd: 5)],
      payload: <String, dynamic>{
        'sections': <Map<String, dynamic>>[
          <String, dynamic>{
            'sectionTitle': 'In the beginning',
            'sectionContent': 'God created the heavens and the earth.',
            'sectionType': 'text',
          },
        ],
      },
    );

    await tester.pumpWidgetBuilder(
      MaterialApp(home: BeginnersLessonView(lesson: lesson)),
      surfaceSize: const Size(1, 1),
    );
    await screenMatchesGolden(tester, 'beginners_lesson_view');
  });
}
