import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/models/lesson.dart';
import '../../../data/repositories/lesson_repository.dart';
import '../widgets/sunday_school_lesson_view.dart';

class SundaySchoolLessonDetailScreen extends HookConsumerWidget {
  const SundaySchoolLessonDetailScreen({required this.lessonId, super.key});

  static const String routeName = 'sundaySchoolLessonDetail';

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncLesson = ref.watch(_lessonProvider(lessonId));
    final lessonTitle = asyncLesson.maybeWhen(
      data: (lesson) => lesson?.title,
      orElse: () => null,
    );

    return Scaffold(
      appBar: AppBar(title: Text(lessonTitle ?? 'Lesson details')),
      body: asyncLesson.when(
        data: (lesson) {
          if (lesson == null) {
            return const Center(child: Text('Lesson not found.'));
          }
          return SundaySchoolLessonView(lesson: lesson);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Something went wrong: $error')),
      ),
    );
  }
}

final _lessonProvider = FutureProvider.family<Lesson?, String>((ref, lessonId) {
  final repository = ref.read(lessonRepositoryProvider);
  return repository.getLessonById(lessonId);
});
