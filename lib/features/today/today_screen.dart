import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/lesson.dart';
import '../../data/repositories/lesson_repository.dart';
import '../../widgets/verse_card.dart';

class TodayScreen extends HookConsumerWidget {
  const TodayScreen({super.key});

  static const String routeName = 'today';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonAsync = ref.watch(_daybreakLessonProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Today')),
      body: lessonAsync.when(
        data: (lesson) => _TodayContent(lesson: lesson),
        error: (error, stackTrace) => Center(child: Text("Unable to load today's devotion: $error")),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

final _daybreakLessonProvider = FutureProvider<Lesson?>((ref) {
  return ref.read(lessonRepositoryProvider).getDaybreakLesson();
});

class _TodayContent extends StatelessWidget {
  const _TodayContent({required this.lesson});

  final Lesson? lesson;

  @override
  Widget build(BuildContext context) {
    if (lesson == null) {
      return const Center(child: Text('No devotion scheduled for today.'));
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: <Widget>[
        Text(
          lesson!.title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        if (lesson!.bibleReferences.isNotEmpty)
          VerseCard(ref: lesson!.bibleReferences.first, translationLabel: 'Parallel (KJV/Shona)'),
        const SizedBox(height: 16),
        Text(
          lesson!.payload['devotion'] as String? ?? 'Spend time in prayer and reflection today.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Marked as read. Great consistency!')),
            );
          },
          icon: const Icon(Icons.check),
          label: const Text('Mark complete'),
        ),
      ],
    );
  }
}
