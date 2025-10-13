import 'package:flutter/material.dart';

import '../../../data/models/bible_ref.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/lesson.dart';
import '../../../widgets/linked_verse.dart';
import '../beginners/beginners_lesson_view.dart';
import '../primary_pals/primary_pals_lesson_view.dart';
import '../search/search_lesson_view.dart';

class SundaySchoolLessonView extends StatelessWidget {
  const SundaySchoolLessonView({required this.lesson, super.key});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final content = switch (lesson.track) {
      Track.beginners => BeginnersLessonView(lesson: lesson),
      Track.primaryPals => PrimaryPalsLessonView(lesson: lesson),
      Track.search => SearchLessonView(lesson: lesson),
      _ => _ComingSoonPlaceholder(lesson: lesson),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _LessonHeader(lesson: lesson),
        const Divider(height: 1),
        Expanded(child: content),
      ],
    );
  }
}

class _LessonHeader extends StatelessWidget {
  const _LessonHeader({required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lessonNumber = (lesson.weekIndex ?? 0) + 1;
    final references = lesson.bibleReferences;

    return Container(
      color: theme.colorScheme.surfaceVariant.withOpacity(0.25),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              _TrackPill(track: lesson.track),
              Chip(label: Text('Lesson $lessonNumber')),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            lesson.title,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          if (references.isNotEmpty) ...<Widget>[
            const SizedBox(height: 16),
            Text('Scripture focus', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: references
                  .map(
                    (BibleRef ref) => LinkedVerse(
                      reference: ref,
                      style: theme.textTheme.bodyMedium,
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _TrackPill extends StatelessWidget {
  const _TrackPill({required this.track});

  final Track track;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: theme.colorScheme.primary.withOpacity(0.12),
      ),
      child: Text(
        _trackLabel(track),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ComingSoonPlaceholder extends StatelessWidget {
  const _ComingSoonPlaceholder({required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(lesson.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          const Text('Lesson format coming soon.'),
        ],
      ),
    );
  }
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
