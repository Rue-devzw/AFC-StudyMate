import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/lesson.dart';
import 'package:afc_studymate/data/providers/app_refresh_providers.dart';
import 'package:afc_studymate/data/repositories/lesson_pdf_repository.dart';
import 'package:afc_studymate/data/repositories/lesson_repository.dart';
import 'package:afc_studymate/widgets/design_system_widgets.dart';
import 'package:afc_studymate/widgets/pdf_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _teacherGuidesLessonsProvider = FutureProvider<Map<Track, Lesson?>>((
  ref,
) async {
  ref.watch(appDataRefreshTickProvider);
  final repository = ref.read(lessonRepositoryProvider);
  const tracks = [
    Track.beginners,
    Track.primaryPals,
    Track.answer,
    Track.search,
    Track.discovery,
  ];
  final entries = await Future.wait(
    tracks.map((track) async {
      final lesson = track == Track.discovery
          ? await repository.getDiscoveryLesson()
          : await repository.getCurrentSundayLesson(track);
      return MapEntry(track, lesson);
    }),
  );
  return Map<Track, Lesson?>.fromEntries(entries);
});

class TeacherGuidesScreen extends HookConsumerWidget {
  const TeacherGuidesScreen({super.key});

  static const String routeName = 'teacherGuides';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncLessons = ref.watch(_teacherGuidesLessonsProvider);
    final theme = Theme.of(context);

    return PremiumScaffold(
      backgroundAsset: 'assets/images/bg_sunday_school.png',
      backgroundSlot: PremiumBackgroundSlots.teacherGuides,
      appBar: AppBar(
        title: const Text(
          "Teacher's Guides",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        top: false,
        child: asyncLessons.when(
          data: (lessons) {
            const tracks = [
              Track.beginners,
              Track.primaryPals,
              Track.answer,
              Track.search,
              Track.discovery,
            ];

            return ListView(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                standardBottomContentPadding(context),
              ),
              children: [
                Text(
                  'CURRENT LESSONS',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white70,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                PremiumGlassCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Answer and Search use the same teacher guide set. Each card still jumps to its own lesson section.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ...tracks.map((track) {
                  final lesson = lessons[track];
                  return _GuideCard(track: track, lesson: lesson);
                }),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
          error: (error, _) => Center(
            child: Text(
              'Something went wrong: $error',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class _GuideCard extends ConsumerWidget {
  const _GuideCard({required this.track, this.lesson});

  final Track track;
  final Lesson? lesson;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final lessonLabel = lesson == null ? null : _lessonLabel(lesson!);
    final guideNote = lesson == null ? null : _guideNoteForTrack(track);

    if (lesson == null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: PremiumGlassCard(
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: track.color.withOpacity(0.2),
                child: Icon(_trackIcon(track), color: track.color, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'No lesson available currently.',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: PremiumGlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: track.color.withOpacity(0.2),
                  child: Icon(_trackIcon(track), color: track.color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.label,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: track.color,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (lessonLabel != null) ...[
                        Text(
                          lessonLabel,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.white70,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 6),
                      ],
                      Text(
                        lesson!.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (guideNote != null) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            guideNote,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _GuideAction(lesson: lesson!),
          ],
        ),
      ),
    );
  }
}

class _GuideAction extends ConsumerWidget {
  const _GuideAction({required this.lesson});
  final Lesson lesson;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guide = ref
        .read(lessonPdfRepositoryProvider)
        .teacherGuideForLesson(lesson);

    return _GuideButton(
      isAvailable: guide != null,
      isSharedGuide:
          lesson.track == Track.answer || lesson.track == Track.search,
      onTap: () {
        if (guide == null) {
          return;
        }
        context.pushNamed(
          PdfViewerScreen.routeName,
          queryParameters: {
            'path': guide.path,
            'title': guide.title,
            if (guide.initialPage != null) 'page': guide.initialPage.toString(),
          },
        );
      },
    );
  }
}

class _GuideButton extends StatelessWidget {
  const _GuideButton({
    required this.isAvailable,
    required this.isSharedGuide,
    required this.onTap,
  });

  final bool isAvailable;
  final bool isSharedGuide;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (!isAvailable) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: const Text(
          'Guide not available',
          style: TextStyle(color: Colors.white54, fontWeight: FontWeight.w500),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.school_rounded),
        label: Text(
          isSharedGuide
              ? "Open Shared Teacher's Guide"
              : "Open Teacher's Guide",
        ),
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

IconData _trackIcon(Track track) {
  switch (track) {
    case Track.beginners:
      return Icons.auto_awesome;
    case Track.primaryPals:
      return Icons.palette_outlined;
    case Track.answer:
      return Icons.auto_stories_outlined;
    case Track.search:
      return Icons.travel_explore_outlined;
    case Track.discovery:
      return Icons.explore_outlined;
    default:
      return Icons.menu_book_outlined;
  }
}

String _lessonLabel(Lesson lesson) {
  switch (lesson.track) {
    case Track.primaryPals:
      return 'Lesson ${lesson.id}';
    case Track.discovery:
      return 'Lesson ${lesson.displayNumber ?? ((lesson.weekIndex ?? 0) + 1)}';
    default:
      final number = lesson.displayNumber ?? ((lesson.weekIndex ?? 0) + 1);
      return 'Lesson $number';
  }
}

String? _guideNoteForTrack(Track track) {
  switch (track) {
    case Track.answer:
      return 'Shares guide PDFs with Search';
    case Track.search:
      return 'Shares guide PDFs with Answer';
    case Track.discovery:
      return 'Opens directly to the current lesson section';
    case Track.primaryPals:
      return 'Opens directly to the current unit section';
    default:
      return null;
  }
}
