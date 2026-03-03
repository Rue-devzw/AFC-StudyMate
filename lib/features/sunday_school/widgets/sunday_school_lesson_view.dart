import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/lesson.dart';
import 'package:afc_studymate/features/sunday_school/answer/answer_lesson_view.dart';
import 'package:afc_studymate/features/sunday_school/beginners/beginners_lesson_view.dart';
import 'package:afc_studymate/features/sunday_school/discovery/discovery_lesson_view.dart';
import 'package:afc_studymate/features/sunday_school/primary_pals/primary_pals_lesson_view.dart';
import 'package:afc_studymate/features/sunday_school/search/search_lesson_view.dart';
import 'package:flutter/material.dart';

class SundaySchoolLessonView extends StatelessWidget {
  const SundaySchoolLessonView({required this.lesson, super.key});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    return switch (lesson.track) {
      Track.beginners => BeginnersLessonView(lesson: lesson),
      Track.primaryPals => PrimaryPalsLessonView(lesson: lesson),
      Track.answer => AnswerLessonView(lesson: lesson),
      Track.search => SearchLessonView(lesson: lesson),
      Track.discovery => DiscoveryLessonView(lesson: lesson),
      _ => _ComingSoonPlaceholder(lesson: lesson),
    };
  }
}

class _ComingSoonPlaceholder extends StatelessWidget {
  const _ComingSoonPlaceholder({required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
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
