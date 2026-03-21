import 'package:afc_studymate/data/models/lesson.dart';
import 'package:afc_studymate/data/repositories/lesson_repository.dart';
import 'package:afc_studymate/data/services/analytics_service.dart';
import 'package:afc_studymate/features/sunday_school/widgets/sunday_school_lesson_view.dart';
import 'package:afc_studymate/widgets/design_system_widgets.dart';
import 'package:afc_studymate/widgets/lesson_display_options.dart';
import 'package:afc_studymate/widgets/retry_error_card.dart';
import 'package:afc_studymate/widgets/skeleton_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
    final fontScale = ref.watch(lessonReadingFontScaleProvider);
    final fontStyle = ref.watch(lessonReadingFontStyleProvider);

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
                    icon: const Icon(Icons.text_fields_rounded),
                    tooltip: 'Reading controls',
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        builder: (sheetContext) {
                          return LessonDisplayOptionsSheet(
                            fontScale: fontScale,
                            onFontScaleChanged: (value) {
                              ref
                                      .read(
                                        lessonReadingFontScaleProvider.notifier,
                                      )
                                      .state =
                                  value;
                            },
                            fontStyle: fontStyle,
                            onFontStyleChanged: (value) {
                              ref
                                      .read(
                                        lessonReadingFontStyleProvider.notifier,
                                      )
                                      .state =
                                  value;
                            },
                          );
                        },
                      );
                    },
                  ),
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
                ],
              ),
              SliverToBoxAdapter(
                child: LessonReadingScope(
                  preferences: LessonReadingPreferences(
                    fontScale: fontScale,
                    fontStyle: fontStyle,
                  ),
                  child: SundaySchoolLessonView(lesson: lesson),
                ),
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
