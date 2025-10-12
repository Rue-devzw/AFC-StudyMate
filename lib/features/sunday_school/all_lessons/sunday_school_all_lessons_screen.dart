import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/models/enums.dart';
import '../../../data/models/lesson.dart';
import '../../../data/repositories/lesson_repository.dart';
import 'sunday_school_lesson_detail_screen.dart';

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
          return _AllLessonsList(lessonsByTrack: value);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Something went wrong: $error')),
      ),
    );
  }
}

const List<Track> _sundaySchoolTracks = <Track>[
  Track.beginners,
  Track.primaryPals,
  Track.search,
];

final _allSundayLessonsProvider = FutureProvider<Map<Track, List<Lesson>>>((ref) async {
  final repository = ref.read(lessonRepositoryProvider);
  final entries = await Future.wait(
    _sundaySchoolTracks.map((Track track) async {
      final lessons = await repository.getLessonsForTrack(track);
      return MapEntry(track, lessons);
    }),
  );
  return Map<Track, List<Lesson>>.fromEntries(entries);
});

class _AllLessonsList extends StatelessWidget {
  const _AllLessonsList({required this.lessonsByTrack});

  final Map<Track, List<Lesson>> lessonsByTrack;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _sundaySchoolTracks.length,
      itemBuilder: (BuildContext context, int index) {
        final track = _sundaySchoolTracks[index];
        final lessons = lessonsByTrack[track] ?? <Lesson>[];
        return _TrackSection(track: track, lessons: lessons);
      },
    );
  }
}

class _TrackSection extends StatelessWidget {
  const _TrackSection({required this.track, required this.lessons});

  final Track track;
  final List<Lesson> lessons;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(_trackLabel(track), style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            if (lessons.isEmpty)
              Text('Lessons coming soon.', style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor))
            else
              ...lessons.map((lesson) => _LessonListTile(lesson: lesson)),
          ],
        ),
      ),
    );
  }
}

class _LessonListTile extends StatelessWidget {
  const _LessonListTile({required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final subtitle = <String?>[
      if (lesson.weekIndex != null) 'Week ${lesson.weekIndex}',
      if (lesson.bibleReferences.isNotEmpty)
        lesson.bibleReferences.map((ref) => ref.displayText).join('; '),
    ].whereType<String>().join(' • ');

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(lesson.title),
      subtitle: subtitle.isEmpty ? null : Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        context.pushNamed(
          SundaySchoolLessonDetailScreen.routeName,
          pathParameters: <String, String>{'lessonId': lesson.id},
        );
      },
    );
  }
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
    default:
      final name = track.name;
      return name[0].toUpperCase() + name.substring(1);
  }
}
