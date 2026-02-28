import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/drift/app_database.dart';
import '../../data/models/bible_ref.dart';
import '../../data/models/enums.dart';
import '../../data/models/journal_entry.dart';
import '../../data/models/lesson.dart';
import '../../data/repositories/lesson_repository.dart';
import '../../widgets/design_system_widgets.dart';
import '../../widgets/linked_verse.dart';
import '../../widgets/verse_card.dart';

class DaybreakScreen extends HookConsumerWidget {
  const DaybreakScreen({required this.date, super.key});

  static const String routeName = 'daybreak';
  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonAsync = ref.watch(_daybreakLessonProvider);

    return Scaffold(
      body: lessonAsync.when(
        data: (lesson) => _DaybreakContent(lesson: lesson),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  "Unable to load today's devotion",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(error.toString(), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

final _daybreakLessonProvider = FutureProvider<Lesson?>((ref) {
  return ref.read(lessonRepositoryProvider).getDaybreakLesson();
});

class _DaybreakContent extends StatelessWidget {
  const _DaybreakContent({required this.lesson});

  final Lesson? lesson;

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Divider(
          thickness: 1,
          color: theme.colorScheme.outline.withOpacity(0.3),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (lesson == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Daybreak')),
        body: const Center(child: Text('No devotion scheduled for today.')),
      );
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: const Text('Daybreak'),
          stretch: true,
          surfaceTintColor: theme.colorScheme.surface,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Daybreak Header Block
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF2C2C2E)
                      : const Color(0xFFE5E5EA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DAYBREAK',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lesson!.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (lesson!.bibleReferences.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: VerseCard(
                    ref: lesson!.bibleReferences.first,
                    translationLabel: 'Parallel (KJV/Shona)',
                  ),
                ),
              Builder(
                builder: (context) {
                  final text =
                      lesson!.payload['devotion'] as String? ??
                      'Spend time in prayer and reflection today.';
                  final paragraphs = text
                      .split('\n\n')
                      .where((p) => p.trim().isNotEmpty)
                      .toList();
                  if (paragraphs.isEmpty) return const SizedBox.shrink();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppDropCapText(text: paragraphs.first),
                      for (int i = 1; i < paragraphs.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: _LinkedText(
                            text: paragraphs[i],
                            style: theme.textTheme.bodyMedium?.copyWith(
                              height: 1.6,
                              fontSize: 18,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              if ((lesson!.payload['background'] as String?)?.isNotEmpty ==
                  true) ...[
                const SizedBox(height: 32),
                _buildSectionHeader(context, 'Background'),
                _LinkedText(
                  text: lesson!.payload['background'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    fontSize: 16,
                  ),
                ),
              ],
              if ((lesson!.payload['amplifiedOutline'] as String?)
                      ?.isNotEmpty ==
                  true) ...[
                const SizedBox(height: 32),
                _buildSectionHeader(context, 'Amplified Outline'),
                _LinkedText(
                  text: lesson!.payload['amplifiedOutline'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    fontSize: 16,
                  ),
                ),
              ],
              if ((lesson!.payload['aCloserLook'] as List?)?.isNotEmpty ==
                  true) ...[
                const SizedBox(height: 32),
                _buildSectionHeader(context, 'A Closer Look'),
                for (
                  int i = 0;
                  i < (lesson!.payload['aCloserLook'] as List).length;
                  i++
                )
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${i + 1}. ',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: _LinkedText(
                                text:
                                    (lesson!.payload['aCloserLook'] as List)[i]
                                        .toString(),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  height: 1.5,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _DaybreakJournalInput(
                          lessonId: lesson!.id,
                          questionId: 'a_closer_look_$i',
                          prompt: (lesson!.payload['aCloserLook'] as List)[i]
                              .toString(),
                        ),
                      ],
                    ),
                  ),
              ],
              if ((lesson!.payload['conclusion'] as String?)?.isNotEmpty ==
                  true) ...[
                const SizedBox(height: 32),
                _buildSectionHeader(context, 'Conclusion'),
                _LinkedText(
                  text: lesson!.payload['conclusion'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    fontSize: 16,
                  ),
                ),
              ],
              const SizedBox(height: 48),
              _JournalingSection(lesson: lesson!),
              const SizedBox(height: 40),
              AppButton(
                label: 'Mark as Complete',
                icon: Icons.check_circle_outline,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Marked as read. Great consistency!'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 60),
            ]),
          ),
        ),
      ],
    );
  }
}

class _LinkedText extends StatelessWidget {
  const _LinkedText({required this.text, this.style});
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    // Basic regex for Bible verses, e.g., "Genesis 11:1-9"
    final regex = RegExp(r'([1-3]?\s?[A-Za-z]+)\s(\d+):(\d+)(-\d+)?');
    final matches = regex.allMatches(text);

    if (matches.isEmpty) {
      return Text(text, style: style);
    }

    final spans = <InlineSpan>[];
    var lastMatchEnd = 0;

    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: text.substring(lastMatchEnd, match.start)));
      }

      final verseText = match.group(0)!;
      final book = match.group(1)!;
      final chapter = int.tryParse(match.group(2)!);
      final verseString = match.group(3); // Start verse
      final endVerseRaw = match.group(4); // e.g. "-9"

      int? verseStart;
      int? verseEnd;
      if (verseString != null) {
        verseStart = int.tryParse(verseString);
      }
      if (endVerseRaw != null) {
        verseEnd = int.tryParse(endVerseRaw.replaceAll('-', ''));
      }

      if (chapter != null) {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: LinkedVerse(
              reference: BibleRef(
                book: book,
                chapter: chapter,
                verseStart: verseStart,
                verseEnd: verseEnd,
              ),
              label: verseText,
              style: style?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        );
      } else {
        spans.add(TextSpan(text: verseText));
      }

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    return Text.rich(TextSpan(children: spans, style: style));
  }
}

class _JournalingSection extends HookConsumerWidget {
  const _JournalingSection({required this.lesson});
  final Lesson lesson;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Personal Reflections',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _DaybreakJournalInput(
          lessonId: lesson.id,
          questionId: 'personal_reflection',
          prompt: 'What is God speaking to you today?',
        ),
      ],
    );
  }
}

class _DaybreakJournalInput extends StatefulHookConsumerWidget {
  const _DaybreakJournalInput({
    required this.lessonId,
    required this.questionId,
    required this.prompt,
  });

  final String lessonId;
  final String questionId;
  final String prompt;

  @override
  ConsumerState<_DaybreakJournalInput> createState() =>
      _DaybreakJournalInputState();
}

class _DaybreakJournalInputState extends ConsumerState<_DaybreakJournalInput> {
  final TextEditingController _controller = TextEditingController();
  bool _hasAttemptedLoad = false;
  bool _isSaving = false;
  bool _saved = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!_hasAttemptedLoad) {
      _hasAttemptedLoad = true;
      Future.microtask(() async {
        final db = ref.read(appDatabaseProvider);
        final entries = await db.getJournalEntries(
          'local_user',
          track: Track.daybreak,
        );
        final myEntry = entries.firstWhere(
          (e) =>
              e.relatedLessonId == widget.lessonId && e.prompt == widget.prompt,
          orElse: () => throw StateError('Not found'),
        );
        _controller.text = myEntry.response;
      }).catchError((_) {});
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          maxLines: null,
          minLines: 3,
          decoration: InputDecoration(
            hintText: 'Capture your thoughts here',
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.3,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (_) {
            if (_saved) setState(() => _saved = false);
          },
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: _isSaving
                ? null
                : () async {
                    if (_controller.text.trim().isEmpty) return;

                    setState(() {
                      _isSaving = true;
                    });

                    final db = ref.read(appDatabaseProvider);
                    final uuid = const Uuid().v4();

                    String entryId = uuid;
                    DateTime createdAt = DateTime.now();

                    try {
                      final entries = await db.getJournalEntries(
                        'local_user',
                        track: Track.daybreak,
                      );
                      final existing = entries.firstWhere(
                        (e) =>
                            e.relatedLessonId == widget.lessonId &&
                            e.prompt == widget.prompt,
                      );
                      entryId = existing.id;
                      createdAt = existing.createdAt;
                    } catch (_) {}

                    await db.upsertJournalEntry(
                      JournalEntry(
                        id: entryId,
                        userId: 'local_user',
                        relatedLessonId: widget.lessonId,
                        sourceTrack: Track.daybreak,
                        prompt: widget.prompt,
                        response: _controller.text.trim(),
                        createdAt: createdAt,
                        updatedAt: DateTime.now(),
                      ),
                    );

                    if (mounted) {
                      setState(() {
                        _isSaving = false;
                        _saved = true;
                      });

                      Future.delayed(const Duration(seconds: 2), () {
                        if (mounted) {
                          setState(() {
                            _saved = false;
                          });
                        }
                      });
                    }
                  },
            icon: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(_saved ? Icons.check_circle : Icons.save),
            label: Text(_saved ? 'Saved' : 'Save'),
          ),
        ),
      ],
    );
  }
}
