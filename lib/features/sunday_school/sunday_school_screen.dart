import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/lesson.dart';
import 'package:afc_studymate/data/repositories/lesson_repository.dart';
import 'package:afc_studymate/features/sunday_school/all_lessons/sunday_school_all_lessons_screen.dart';
import 'package:afc_studymate/features/sunday_school/widgets/sunday_school_lesson_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

class SundaySchoolScreen extends HookConsumerWidget {
  const SundaySchoolScreen({super.key});

  static const String routeName = 'sundaySchool';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncLesson = ref.watch(_currentLessonProvider);

    void openAllLessons() => context.pushNamed(SundaySchoolAllLessonsScreen.routeName);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sunday School'),
        actions: <Widget>[
          IconButton(
            tooltip: 'View all lessons',
            icon: const Icon(Icons.library_books_outlined),
            onPressed: openAllLessons,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: asyncLesson.when(
                data: (value) {
                  if (value == null) {
                    return const Center(child: Text('Your lesson will appear here soon.'));
                  }
                  return SundaySchoolLessonView(lesson: value);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(child: Text('Something went wrong: $error')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: FilledButton.icon(
                onPressed: openAllLessons,
                icon: const Icon(Icons.library_books_outlined),
                label: const Text('View all lessons'),
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final _currentLessonProvider = FutureProvider<Lesson?>((ref) {
  final repository = ref.read(lessonRepositoryProvider);
  return repository.getCurrentSundayLesson(Track.beginners);
});
