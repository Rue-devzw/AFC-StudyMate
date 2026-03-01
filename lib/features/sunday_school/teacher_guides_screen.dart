import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/drift/app_database.dart';
import '../../data/models/enums.dart';
import '../../data/models/lesson.dart';
import '../../data/repositories/discovery_guide_repository.dart';
import '../../data/repositories/lesson_repository.dart';
import '../../widgets/design_system_widgets.dart';
import '../../widgets/pdf_viewer_screen.dart';

final _teacherGuidesLessonsProvider = FutureProvider<Map<Track, Lesson?>>((
  ref,
) async {
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
      appBar: AppBar(
        title: const Text(
          'Teacher\'s Guides',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
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

    final isDiscovery = track == Track.discovery;

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
                      Text(
                        lesson!.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isDiscovery)
              _DiscoveryGuideAction(lesson: lesson!)
            else
              _DatabaseGuideAction(lesson: lesson!),
          ],
        ),
      ),
    );
  }
}

class _DiscoveryGuideAction extends ConsumerWidget {
  const _DiscoveryGuideAction({required this.lesson});
  final Lesson lesson;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guide = ref
        .read(discoveryGuideRepositoryProvider)
        .getGuideForLesson(lesson.id);

    return _GuideButton(
      isAvailable: guide != null,
      onTap: () {
        if (guide != null) {
          context.pushNamed(
            PdfViewerScreen.routeName,
            queryParameters: {
              'path': guide.pdfPath,
              'title': 'Teacher\'s Guide: ${lesson.title}',
              'page': guide.startPage.toString(),
            },
          );
        }
      },
    );
  }
}

class _DatabaseGuideAction extends ConsumerWidget {
  const _DatabaseGuideAction({required this.lesson});
  final Lesson lesson;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(appDatabaseProvider).getTeacherGuide(lesson.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final guide = snapshot.data;
        return _GuideButton(
          isAvailable: guide != null,
          onTap: () {
            if (guide != null) {
              context.pushNamed(
                'teacher-guide',
                extra: guide,
                queryParameters: {'title': '${lesson.title} Guide'},
              );
            }
          },
        );
      },
    );
  }
}

class _GuideButton extends StatelessWidget {
  const _GuideButton({required this.isAvailable, required this.onTap});

  final bool isAvailable;
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
        label: const Text('Open Teacher\'s Guide'),
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
