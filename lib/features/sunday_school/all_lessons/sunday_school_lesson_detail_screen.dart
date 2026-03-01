import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/drift/app_database.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/lesson.dart';
import '../../../data/providers/user_providers.dart';
import '../../../data/repositories/lesson_repository.dart';
import '../widgets/sunday_school_lesson_view.dart';

class SundaySchoolLessonDetailScreen extends HookConsumerWidget {
  const SundaySchoolLessonDetailScreen({required this.lessonId, super.key});

  static const String routeName = 'sundaySchoolLessonDetail';

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncLesson = ref.watch(_lessonProvider(lessonId));
    final theme = Theme.of(context);

    return Scaffold(
      body: asyncLesson.when(
        data: (lesson) {
          if (lesson == null) {
            return const Center(child: Text('Lesson not found.'));
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar.medium(
                title: Text(lesson.title),
                stretch: true,
                surfaceTintColor: theme.colorScheme.surface,
                actions: [
                  ref
                      .watch(userProfileProvider)
                      .when(
                        data: (profile) {
                          if (profile.role != Role.teacher) {
                            return const SizedBox.shrink();
                          }
                          return FutureBuilder(
                            future: ref
                                .read(appDatabaseProvider)
                                .getTeacherGuide(lesson.id),
                            builder: (context, snapshot) {
                              final guide = snapshot.data;
                              if (guide == null) return const SizedBox.shrink();

                              return IconButton(
                                icon: const Icon(Icons.school_rounded),
                                tooltip: "Teacher's Guide",
                                onPressed: () {
                                  context.pushNamed(
                                    'teacher-guide',
                                    extra: guide,
                                    queryParameters: {
                                      'title': "${lesson.title} Guide",
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                ],
              ),
              SliverToBoxAdapter(
                child: SundaySchoolLessonView(lesson: lesson),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 120),
                sliver: const SliverToBoxAdapter(child: SizedBox.shrink()),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Something went wrong: $error')),
      ),
    );
  }
}

final _lessonProvider = FutureProvider.family<Lesson?, String>((ref, lessonId) {
  final repository = ref.read(lessonRepositoryProvider);
  return repository.getLessonById(lessonId);
});
