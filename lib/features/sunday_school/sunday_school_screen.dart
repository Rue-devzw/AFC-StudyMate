import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/bible_ref.dart';
import '../../data/models/enums.dart';
import '../../data/models/lesson.dart';
import '../../data/repositories/lesson_repository.dart';
import '../../widgets/linked_verse.dart';
import 'all_lessons/sunday_school_all_lessons_screen.dart';
import 'all_lessons/sunday_school_lesson_detail_screen.dart';

class SundaySchoolScreen extends HookConsumerWidget {
  const SundaySchoolScreen({super.key});

  static const String routeName = 'sundaySchool';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncLessons = ref.watch(_currentLessonsProvider);

    void openAllLessons() => context.pushNamed(SundaySchoolAllLessonsScreen.routeName);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sunday School'),
        actions: <Widget>[
          IconButton(
            tooltip: 'View all lessons',
            icon: const Icon(Icons.library_books_outlined),
            onPressed: openAllLessons,
          ),
        ],
      ),
      body: SafeArea(
        child: asyncLessons.when(
          data: (lessons) {
            final hasLesson = _sundaySchoolTracks.any((track) => lessons[track] != null);
            if (!hasLesson) {
              return const Center(child: Text('Weekly lessons will appear here soon.'));
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              children: <Widget>[
                Text(
                  'This week\'s Sunday School snapshot',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                ..._sundaySchoolTracks.map(
                  (track) => _LessonPreviewCard(
                    track: track,
                    lesson: lessons[track],
                    onOpen: lessons[track] == null
                        ? null
                        : () {
                            context.pushNamed(
                              SundaySchoolLessonDetailScreen.routeName,
                              pathParameters: <String, String>{
                                'lessonId': lessons[track]!.id,
                              },
                            );
                          },
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: openAllLessons,
                  icon: const Icon(Icons.library_books_outlined),
                  label: const Text('View all lessons'),
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Something went wrong: $error')),
        ),
      ),
    );
  }
}

const List<Track> _sundaySchoolTracks = <Track>[
  Track.beginners,
  Track.primaryPals,
  Track.search,
];

final _currentLessonsProvider = FutureProvider<Map<Track, Lesson?>>((ref) async {
  final repository = ref.read(lessonRepositoryProvider);
  final entries = await Future.wait(
    _sundaySchoolTracks.map((track) async {
      final lesson = await repository.getCurrentSundayLesson(track);
      return MapEntry(track, lesson);
    }),
  );
  return Map<Track, Lesson?>.fromEntries(entries);
});

class _LessonPreviewCard extends StatelessWidget {
  const _LessonPreviewCard({required this.track, this.lesson, this.onOpen});

  final Track track;
  final Lesson? lesson;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700);
    final background = theme.colorScheme.surfaceVariant.withOpacity(0.4);

    if (lesson == null) {
      return Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _TrackChip(track: track),
              const SizedBox(height: 12),
              Text(
                'We\'re preparing this week\'s lesson.',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    final lessonNumber = (lesson!.weekIndex ?? 0) + 1;
    final snippet = _lessonPreviewSnippet(lesson!);
    final references = lesson!.bibleReferences;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  radius: 24,
                  backgroundColor: background,
                  child: Icon(_trackIcon(track), color: theme.colorScheme.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _TrackChip(track: track),
                      const SizedBox(height: 8),
                      Text('Lesson $lessonNumber', style: theme.textTheme.labelLarge),
                      const SizedBox(height: 4),
                      Text(lesson!.title, style: titleStyle),
                    ],
                  ),
                ),
              ],
            ),
            if (references.isNotEmpty) ...<Widget>[
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: references
                    .map(
                      (BibleRef ref) => Chip(
                        label: LinkedVerse(
                          reference: ref,
                          style: theme.textTheme.bodySmall,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    )
                    .toList(),
              ),
            ],
            if (snippet.isNotEmpty) ...<Widget>[
              const SizedBox(height: 12),
              Text(
                snippet,
                style: theme.textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: onOpen,
                icon: const Icon(Icons.menu_book_rounded),
                label: const Text('Open full lesson'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackChip extends StatelessWidget {
  const _TrackChip({required this.track});

  final Track track;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(
        _trackLabel(track),
        style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary),
      ),
    );
  }
}

String _lessonPreviewSnippet(Lesson lesson) {
  final payload = lesson.payload;
  String? raw;
  switch (lesson.track) {
    case Track.beginners:
      final sections = (payload['sections'] as List<dynamic>? ?? <dynamic>[])
          .whereType<Map<String, dynamic>>();
      raw = sections
          .map((section) => section['sectionContent'] as String? ?? '')
          .firstWhereOrNull((value) => value.trim().isNotEmpty);
      break;
    case Track.primaryPals:
      final story = (payload['story'] as List<dynamic>? ?? <dynamic>[]).cast<String>();
      raw = story.firstWhereOrNull((paragraph) => paragraph.trim().isNotEmpty);
      break;
    case Track.search:
      final exposition = (payload['exposition'] as List<dynamic>? ?? <dynamic>[]).cast<String>();
      raw = exposition.firstWhereOrNull((paragraph) => paragraph.trim().isNotEmpty);
      break;
    default:
      raw = null;
      break;
  }

  if (raw == null) {
    return '';
  }

  final collapsed = raw.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (collapsed.length <= 220) {
    return collapsed;
  }
  return '${collapsed.substring(0, 217).trimRight()}…';
}

String _trackLabel(Track track) {
  switch (track) {
    case Track.beginners:
      return 'Beginners';
    case Track.primaryPals:
      return 'Primary Pals';
    case Track.search:
      return 'Search';
    default:
      return track.name;
  }
}

IconData _trackIcon(Track track) {
  switch (track) {
    case Track.beginners:
      return Icons.auto_awesome;
    case Track.primaryPals:
      return Icons.palette_outlined;
    case Track.search:
      return Icons.travel_explore_outlined;
    default:
      return Icons.menu_book_outlined;
  }
}
