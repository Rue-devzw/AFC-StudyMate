import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/enums.dart';
import '../../data/models/lesson.dart';
import '../../data/repositories/lesson_repository.dart';
import '../../widgets/completion_banner.dart';
import 'beginners/beginners_lesson_view.dart';
import 'primary_pals/primary_pals_lesson_view.dart';
import 'search/search_lesson_view.dart';

class SundaySchoolScreen extends HookConsumerWidget {
  const SundaySchoolScreen({super.key});

  static const String routeName = 'sundaySchool';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncLesson = ref.watch(_currentLessonProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sunday School')),
      body: asyncLesson.when(
        data: (value) {
          if (value == null) {
            return const Center(child: Text('Your lesson will appear here soon.'));
          }
          return _LessonSwitcher(lesson: value);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Something went wrong: $error')),
      ),
    );
  }
}

final _currentLessonProvider = FutureProvider<Lesson?>((ref) {
  final repository = ref.read(lessonRepositoryProvider);
  return repository.getCurrentSundayLesson(Track.beginners);
});

class _LessonSwitcher extends StatelessWidget {
  const _LessonSwitcher({required this.lesson});

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
