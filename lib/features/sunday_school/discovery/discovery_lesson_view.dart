import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/lesson.dart';
import '../../../widgets/design_system_widgets.dart';
import '../../../widgets/verse_card.dart';

class DiscoveryLessonView extends ConsumerWidget {
  const DiscoveryLessonView({required this.lesson, super.key});

  final Lesson lesson;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final keyVerse = lesson.payload['keyVerse'] as String? ?? '';
    final background = lesson.payload['background'] as String? ?? '';
    final conclusion = lesson.payload['conclusion'] as String? ?? '';
    final questions = (lesson.payload['questions'] as List<dynamic>? ?? [])
        .cast<String>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Lesson ${lesson.displayNumber ?? ""}',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (lesson.bibleReferences.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: VerseCard(
              ref: lesson.bibleReferences.first,
              translationLabel: 'Bible Reading',
            ),
          ),
        const SizedBox(height: 24),
        if (keyVerse.isNotEmpty)
          _Section(
            title: 'Key Verse',
            child: PremiumGlassCard(
              child: Text(
                keyVerse,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        if (background.isNotEmpty)
          _Section(
            title: 'Background',
            child: Text(
              background,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
            ),
          ),
        if (questions.isNotEmpty)
          _Section(
            title: 'Questions for Discussion',
            child: Column(
              children: [
                for (int i = 0; i < questions.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: Text(
                            '${i + 1}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            questions[i],
                            style: theme.textTheme.bodyMedium?.copyWith(
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        if (conclusion.isNotEmpty)
          _Section(
            title: 'Conclusion',
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer.withAlpha(30),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.secondary.withAlpha(50),
                ),
              ),
              child: Text(
                conclusion,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
