import 'package:afc_studymate/data/drift/app_database.dart';
import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/lesson.dart';
import 'package:afc_studymate/data/providers/user_providers.dart';
import 'package:afc_studymate/data/repositories/lesson_repository.dart';
import 'package:afc_studymate/data/services/analytics_service.dart';
import 'package:afc_studymate/features/sunday_school/widgets/sunday_school_lesson_view.dart';
import 'package:afc_studymate/widgets/design_system_widgets.dart';
import 'package:afc_studymate/widgets/retry_error_card.dart';
import 'package:afc_studymate/widgets/skeleton_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

class SundaySchoolLessonDetailScreen extends HookConsumerWidget {
  const SundaySchoolLessonDetailScreen({required this.lessonId, super.key});

  static const String routeName = 'sundaySchoolLessonDetail';

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncLesson = ref.watch(_lessonProvider(lessonId));
    final lesson = asyncLesson.valueOrNull;
    final theme = Theme.of(context);

    useEffect(() {
      if (lesson == null) {
        return null;
      }
      Future<void>.microtask(() async {
        await ref
            .read(analyticsServiceProvider)
            .logLessonOpened(
              lessonId: lesson.id,
              track: lesson.track,
              source: 'sunday_school_detail',
            );
      });
      return null;
    }, [lesson?.id]);

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
                  IconButton(
                    icon: const Icon(Icons.share),
                    tooltip: 'Share lesson',
                    onPressed: () {
                      final refs = lesson.bibleReferences
                          .map((ref) => ref.displayText)
                          .join(', ');
                      Share.share(
                        '${lesson.title}\n${refs.isEmpty ? '' : '$refs\n'}',
                      );
                    },
                  ),
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
                                      'title': '${lesson.title} Guide',
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
              SliverToBoxAdapter(
                child: SizedBox(height: standardBottomContentPadding(context)),
              ),
            ],
          );
        },
        loading: () => ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            standardBottomContentPadding(context),
          ),
          children: const [
            SkeletonCard(),
            SizedBox(height: 12),
            SkeletonCard(),
            SizedBox(height: 12),
            SkeletonCard(),
          ],
        ),
        error: (error, stackTrace) => RetryErrorCard(
          message: '$error',
          onRetry: () => ref.invalidate(_lessonProvider(lessonId)),
        ),
      ),
    );
  }
}

final FutureProviderFamily<Lesson?, String> _lessonProvider =
    FutureProvider.family<Lesson?, String>((ref, lessonId) {
      final repository = ref.read(lessonRepositoryProvider);
      return repository.getLessonById(lessonId);
    });
