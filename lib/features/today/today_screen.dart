import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/lesson.dart';
import '../../data/repositories/lesson_repository.dart';
import '../../widgets/design_system_widgets.dart';
import '../../widgets/verse_card.dart';

class TodayScreen extends HookConsumerWidget {
  const TodayScreen({super.key});

  static const String routeName = 'today';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonAsync = ref.watch(_daybreakLessonProvider);

    return Scaffold(
      body: lessonAsync.when(
        data: (lesson) => _TodayContent(lesson: lesson),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  "Unable to load today's devotion",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(error.toString(), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
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

    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: const Text('Today'),
          stretch: true,
          surfaceTintColor: theme.colorScheme.surface,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              AppSectionTitle(title: lesson!.title),
              const SizedBox(height: 8),
              if (lesson!.bibleReferences.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: VerseCard(
                    ref: lesson!.bibleReferences.first,
                    translationLabel: 'Parallel (KJV/Shona)',
                  ),
                ),
              AppCard(
                child: Text(
                  lesson!.payload['devotion'] as String? ??
                      'Spend time in prayer and reflection today.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              AppButton(
                label: 'Mark as Complete',
                icon: Icons.check_circle_outline,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Marked as read. Great consistency!'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 60),
            ]),
          ),
        ),
      ],
    );
  }
}
