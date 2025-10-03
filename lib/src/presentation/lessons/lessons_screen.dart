import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/lessons/entities.dart';
import '../providers.dart';
import 'lesson_detail_screen.dart';
import 'lesson_progress_dashboard_screen.dart';

class LessonsScreen extends ConsumerWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(lessonFiltersProvider);
    final lessonsAsync = ref.watch(lessonsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lessons'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            tooltip: 'Progress dashboard',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LessonProgressDashboardScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _LessonFilterBar(
            state: filters,
            onClassChanged: (value) =>
                ref.read(lessonFiltersProvider.notifier).setClass(value),
            onAgeChanged: (value) =>
                ref.read(lessonFiltersProvider.notifier).setAge(value),
            onCompletionChanged: (value) =>
                ref.read(lessonFiltersProvider.notifier).setCompletion(value),
          ),
          Expanded(
            child: lessonsAsync.when(
              data: (lessons) {
                if (lessons.isEmpty) {
                  return const Center(
                    child: Text('No lessons match the selected filters.'),
                  );
                }
                return ListView.builder(
                  itemCount: lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = lessons[index];
                    final ageRange = lesson.ageRange != null
                        ? '${lesson.ageRange!.min}-${lesson.ageRange!.max} yrs'
                        : 'All ages';
                    final secondary = [
                      lesson.lessonClass,
                      ageRange,
                      if (lesson.attachments.isNotEmpty)
                        '${lesson.attachments.length} attachment${lesson.attachments.length == 1 ? '' : 's'}',
                      if (lesson.quizzes.isNotEmpty)
                        '${lesson.quizzes.length} quiz${lesson.quizzes.length == 1 ? '' : 'zes'}',
                    ].join(' · ');
                    return Semantics(
                      container: true,
                      label: 'Lesson ${lesson.title}',
                      hint: 'Opens lesson details',
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(lesson.title),
                          subtitle: Text(secondary),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LessonDetailScreen(lesson: lesson),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Failed to load lessons: $error'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonFilterBar extends StatelessWidget {
  const _LessonFilterBar({
    required this.state,
    required this.onClassChanged,
    required this.onAgeChanged,
    required this.onCompletionChanged,
  });

  final LessonFilterState state;
  final ValueChanged<String?> onClassChanged;
  final ValueChanged<int?> onAgeChanged;
  final ValueChanged<LessonCompletionFilter> onCompletionChanged;

  static const _classOptions = <String?>[
    null,
    'Beginners',
    'Primary Pals',
    'Answer',
    'Search',
    'Discovery',
  ];

  static const _ageOptions = <int?>[null, 4, 6, 8, 10, 12, 14, 16];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: FocusTraversalGroup(
        child: Wrap(
          spacing: 16,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Semantics(
              label: 'Filter by class',
              child: DropdownButton<String?>(
                value: state.selectedClass,
                hint: const Text('Class'),
                onChanged: onClassChanged,
                items: _classOptions
                    .map(
                      (option) => DropdownMenuItem<String?>(
                        value: option,
                        child: Text(option ?? 'All classes'),
                      ),
                    )
                    .toList(),
              ),
            ),
            Semantics(
              label: 'Filter by age',
              child: DropdownButton<int?>(
                value: state.age,
                hint: const Text('Age'),
                onChanged: onAgeChanged,
                items: _ageOptions
                    .map(
                      (option) => DropdownMenuItem<int?>(
                        value: option,
                        child: Text(option == null ? 'Any age' : '$option yrs'),
                      ),
                    )
                    .toList(),
              ),
            ),
            Semantics(
              label: 'Filter by completion status',
              child: DropdownButton<LessonCompletionFilter>(
                value: state.completion,
                onChanged: onCompletionChanged,
                items: LessonCompletionFilter.values
                    .map(
                      (value) => DropdownMenuItem<LessonCompletionFilter>(
                        value: value,
                        child: Text(_completionLabel(value)),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _completionLabel(LessonCompletionFilter filter) {
    switch (filter) {
      case LessonCompletionFilter.all:
        return 'All statuses';
      case LessonCompletionFilter.notStarted:
        return 'Not started';
      case LessonCompletionFilter.inProgress:
        return 'In progress';
      case LessonCompletionFilter.completed:
        return 'Completed';
    }
  }
}
