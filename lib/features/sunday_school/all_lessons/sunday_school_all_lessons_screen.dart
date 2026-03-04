import 'package:afc_studymate/data/models/bible_ref.dart';
import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/lesson.dart';
import 'package:afc_studymate/data/providers/progress_providers.dart';
import 'package:afc_studymate/data/repositories/lesson_repository.dart';
import 'package:afc_studymate/features/sunday_school/all_lessons/sunday_school_lesson_detail_screen.dart';
import 'package:afc_studymate/widgets/design_system_widgets.dart';
import 'package:afc_studymate/widgets/linked_verse.dart';
import 'package:afc_studymate/widgets/retry_error_card.dart';
import 'package:afc_studymate/widgets/skeleton_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

class SundaySchoolAllLessonsScreen extends HookConsumerWidget {
  const SundaySchoolAllLessonsScreen({super.key});

  static const String routeName = 'sundaySchoolAllLessons';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncLessons = ref.watch(_allSundayLessonsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('All Sunday School Lessons')),
      body: asyncLessons.when(
        data: (value) {
          if (value.values.every((lessons) => lessons.isEmpty)) {
            return const Center(child: Text('Lessons will appear here soon.'));
          }
          return _LessonsExplorer(lessonsByTrack: value);
        },
        loading: () => ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            8,
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
          onRetry: () => ref.invalidate(_allSundayLessonsProvider),
        ),
      ),
    );
  }
}

const List<Track> _sundaySchoolTracks = <Track>[
  Track.beginners,
  Track.primaryPals,
  Track.answer,
  Track.search,
  Track.discovery,
];

final _allSundayLessonsProvider = FutureProvider<Map<Track, List<Lesson>>>((
  ref,
) async {
  final repository = ref.read(lessonRepositoryProvider);
  final entries = await Future.wait(
    _sundaySchoolTracks.map((track) async {
      final lessons = await repository.getLessonsForTrack(track);
      return MapEntry(track, lessons);
    }),
  );
  return Map<Track, List<Lesson>>.fromEntries(entries);
});

class _LessonsExplorer extends HookConsumerWidget {
  const _LessonsExplorer({required this.lessonsByTrack});

  final Map<Track, List<Lesson>> lessonsByTrack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final searchQuery = useState('');
    final selectedTrack = useState<Track?>(null);
    final selectedQuarter = useState<int?>(null);
    final selectedTopic = useState<String?>(null);

    useEffect(() {
      void listener() => searchQuery.value = searchController.text;
      searchController.addListener(listener);
      return () => searchController.removeListener(listener);
    }, <Object?>[searchController]);

    final allLessons = useMemoized(
      () => _sundaySchoolTracks
          .expand((track) => lessonsByTrack[track] ?? <Lesson>[])
          .toList(growable: false),
      <Object?>[lessonsByTrack],
    );

    final quarters = useMemoized(
      () {
        final values = <int>{};
        for (final lesson in allLessons) {
          final quarter = _quarterForLesson(lesson);
          if (quarter != null) {
            values.add(quarter);
          }
        }
        final list = values.toList()..sort();
        return list;
      },
      <Object?>[allLessons],
    );

    final topics = useMemoized(
      () {
        final values = <String>{};
        for (final lesson in allLessons) {
          final topic = _topicForLesson(lesson);
          if (topic != null && topic.isNotEmpty) {
            values.add(topic);
          }
        }
        final list = values.toList()
          ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
        return list;
      },
      <Object?>[allLessons],
    );

    final filteredLessons = useMemoized(
      () {
        final query = searchQuery.value.trim().toLowerCase();
        return allLessons.where((lesson) {
          if (selectedTrack.value != null &&
              lesson.track != selectedTrack.value) {
            return false;
          }
          final quarter = _quarterForLesson(lesson);
          if (selectedQuarter.value != null &&
              quarter != selectedQuarter.value) {
            return false;
          }
          final topic = _topicForLesson(lesson);
          if (selectedTopic.value != null && topic != selectedTopic.value) {
            return false;
          }
          if (query.isEmpty) {
            return true;
          }
          final summary = _lessonSummary(lesson) ?? '';
          final topicText = topic ?? '';
          final referenceText = lesson.bibleReferences
              .map((ref) => ref.displayText)
              .join(' ');
          final haystack = '${lesson.title} $summary $topicText $referenceText'
              .toLowerCase();
          return haystack.contains(query);
        }).toList();
      },
      <Object?>[
        allLessons,
        searchQuery.value,
        selectedTrack.value,
        selectedQuarter.value,
        selectedTopic.value,
      ],
    );

    filteredLessons.sort((a, b) {
      final trackComparison = _sundaySchoolTracks
          .indexOf(a.track)
          .compareTo(
            _sundaySchoolTracks.indexOf(b.track),
          );
      if (trackComparison != 0) {
        return trackComparison;
      }
      final weekA = a.weekIndex ?? 0;
      final weekB = b.weekIndex ?? 0;
      return weekA.compareTo(weekB);
    });

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search by title, topic, or scripture',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: <Widget>[
              ChoiceChip(
                label: const Text('All tracks'),
                selected: selectedTrack.value == null,
                onSelected: (_) => selectedTrack.value = null,
              ),
              const SizedBox(width: 8),
              ..._sundaySchoolTracks.map(
                (track) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(_trackLabel(track)),
                    selected: selectedTrack.value == track,
                    onSelected: (_) => selectedTrack.value =
                        selectedTrack.value == track ? null : track,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Wrap(
            spacing: 16,
            runSpacing: 12,
            children: <Widget>[
              if (quarters.isNotEmpty)
                SizedBox(
                  width: 200,
                  child: DropdownButtonFormField<int?>(
                    initialValue: selectedQuarter.value,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Quarter',
                    ),
                    items: <DropdownMenuItem<int?>>[
                      const DropdownMenuItem<int?>(
                        child: Text('All quarters'),
                      ),
                      ...quarters.map(
                        (quarter) => DropdownMenuItem<int?>(
                          value: quarter,
                          child: Text('Quarter $quarter'),
                        ),
                      ),
                    ],
                    onChanged: (value) => selectedQuarter.value = value,
                  ),
                ),
              if (topics.isNotEmpty)
                SizedBox(
                  width: 240,
                  child: DropdownButtonFormField<String?>(
                    initialValue: selectedTopic.value,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Topic',
                    ),
                    items: <DropdownMenuItem<String?>>[
                      const DropdownMenuItem<String?>(
                        child: Text('All topics'),
                      ),
                      ...topics.map(
                        (topic) => DropdownMenuItem<String?>(
                          value: topic,
                          child: Text(topic),
                        ),
                      ),
                    ],
                    onChanged: (value) => selectedTopic.value = value,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: filteredLessons.isEmpty
              ? const Center(child: Text('No lessons match your filters yet.'))
              : ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    8,
                    16,
                    standardBottomContentPadding(context),
                  ), // Clear floating bottom bar
                  itemCount: filteredLessons.length,
                  itemBuilder: (context, index) {
                    final lesson = filteredLessons[index];
                    return _LessonCard(
                      lesson: lesson,
                      onTap: () {
                        context.pushNamed(
                          SundaySchoolLessonDetailScreen.routeName,
                          pathParameters: <String, String>{
                            'lessonId': lesson.id,
                          },
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _LessonCard extends ConsumerWidget {
  const _LessonCard({required this.lesson, required this.onTap});

  final Lesson lesson;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isCompleted = ref.watch(isLessonCompletedProvider(lesson.id));
    final subtitle = _lessonSubtitle(lesson);
    final summary = _lessonSummary(lesson);
    final topic = _topicForLesson(lesson);

    final lessonNumber = lesson.displayNumber ?? ((lesson.weekIndex ?? 0) + 1);
    final chips = <Widget>[
      Chip(label: Text(_trackLabel(lesson.track))),
      Chip(label: Text('Lesson $lessonNumber')),
      ...lesson.bibleReferences
          .take(3)
          .map(
            (ref) => _BibleRefChip(reference: ref),
          ),
      if ((lesson.bibleReferences.length) > 3)
        Chip(label: Text('+${lesson.bibleReferences.length - 3} refs')),
      if (topic != null && topic.isNotEmpty) Chip(label: Text(topic)),
    ];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    foregroundColor: theme.colorScheme.onPrimaryContainer,
                    child: const Icon(Icons.menu_book_outlined),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          lesson.title,
                          style: theme.textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subtitle != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              subtitle,
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Share lesson',
                    icon: const Icon(Icons.share_outlined, size: 20),
                    onPressed: () {
                      Share.share(
                        '${lesson.title}\n'
                        '${_trackLabel(lesson.track)}\n'
                        '${lesson.bibleReferences.map((e) => e.displayText).join(", ")}',
                      );
                    },
                  ),
                  if (isCompleted.valueOrNull ?? false)
                    const Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 22,
                      ),
                    ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              if (summary != null && summary.isNotEmpty) ...<Widget>[
                const SizedBox(height: 12),
                Text(
                  summary,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (chips.isNotEmpty) ...<Widget>[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: chips,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

String? _lessonSubtitle(Lesson lesson) {
  final parts = <String>[
    'Lesson ${lesson.displayNumber ?? ((lesson.weekIndex ?? 0) + 1)}',
    if (lesson.bibleReferences.isNotEmpty)
      lesson.bibleReferences.map((ref) => ref.displayText).join(' • '),
  ].where((element) => element.isNotEmpty).toList();

  if (parts.isEmpty) {
    return null;
  }
  return parts.join(' • ');
}

String? _lessonSummary(Lesson lesson) {
  final payload = lesson.payload;
  final keyVerse = payload['keyVerse'] as String?;
  if (keyVerse != null && keyVerse.trim().isNotEmpty) {
    return keyVerse.trim();
  }

  final sections = payload['sections'] as List<dynamic>?;
  if (sections != null && sections.isNotEmpty) {
    final first = sections.first;
    if (first is Map<String, dynamic>) {
      final content = first['sectionContent'] as String?;
      if (content != null && content.trim().isNotEmpty) {
        return content.trim();
      }
    }
  }

  final story = payload['story'] as List<dynamic>?;
  if (story != null && story.isNotEmpty) {
    final first = story.first;
    if (first is String && first.trim().isNotEmpty) {
      return first.trim();
    }
  }

  final parentGuide = payload['parentGuide'] as Map<String, dynamic>?;
  if (parentGuide != null) {
    final parentsCorner = parentGuide['parentsCorner'] as String?;
    if (parentsCorner != null && parentsCorner.trim().isNotEmpty) {
      return parentsCorner.trim();
    }
  }

  return null;
}

String? _topicForLesson(Lesson lesson) {
  final payload = lesson.payload;
  final topic = payload['topic'] as String?;
  if (topic != null && topic.trim().isNotEmpty) {
    return topic.trim();
  }

  final ageCategory = payload['ageCategory'] as String?;
  if (ageCategory != null && ageCategory.trim().isNotEmpty) {
    return ageCategory.trim();
  }

  final resource = payload['resourceMaterial'] as String?;
  if (resource != null && resource.trim().isNotEmpty) {
    return resource.trim();
  }

  if (lesson.title.contains(':')) {
    return lesson.title.split(':').first.trim();
  }
  if (lesson.bibleReferences.isNotEmpty) {
    return lesson.bibleReferences.first.book;
  }
  return null;
}

int? _quarterForLesson(Lesson lesson) {
  final week = lesson.weekIndex;
  if (week == null || week <= 0) {
    return null;
  }
  return ((week - 1) ~/ 13) + 1;
}

String _trackLabel(Track track) {
  switch (track) {
    case Track.beginners:
      return 'Beginners (Ages 2–5)';
    case Track.primaryPals:
      return 'Primary Pals (1st–3rd)';
    case Track.answer:
      return 'Answer (4th–8th)';
    case Track.search:
      return 'Search (High School–Adults)';
    case Track.discovery:
      return 'Discovery';
    default:
      final name = track.name;
      return name[0].toUpperCase() + name.substring(1);
  }
}

/// A chip-styled widget that wraps a [LinkedVerse].
/// [LinkedVerse] already handles the tap → verse-preview-sheet flow natively,
/// so we just need to provide a chip-like appearance around it.
class _BibleRefChip extends StatelessWidget {
  const _BibleRefChip({required this.reference});

  final BibleRef reference;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 14,
              color: colorScheme.onSecondaryContainer,
            ),
            const SizedBox(width: 6),
            LinkedVerse(
              reference: reference,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
