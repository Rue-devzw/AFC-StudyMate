import 'package:flutter/material.dart';

import '../../../data/models/enums.dart';
import '../../../data/models/lesson.dart';
import '../beginners/beginners_lesson_view.dart';
import '../primary_pals/primary_pals_lesson_view.dart';
import '../search/search_lesson_view.dart';

class SundaySchoolLessonView extends StatelessWidget {
  const SundaySchoolLessonView({required this.lesson, super.key});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    switch (lesson.track) {
      case Track.beginners:
        return BeginnersLessonView(lesson: lesson);
      case Track.primaryPals:
        return PrimaryPalsLessonView(lesson: lesson);
      case Track.search:
        return SearchLessonView(lesson: lesson);
      default:
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(lesson.title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              const Text('Lesson format coming soon.'),
            ],
          ),
        );
    }
  }
}
