import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/drift/app_database.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/models/lesson.dart';
import '../../../data/services/progress_service.dart';
import '../../../utils/scripture_reference_parser.dart';
import '../../../widgets/design_system_widgets.dart';
import '../../../widgets/linked_verse.dart';
import 'package:uuid/uuid.dart';

class SearchLessonView extends StatefulHookConsumerWidget {
  const SearchLessonView({required this.lesson, super.key});

  final Lesson lesson;

  @override
  ConsumerState<SearchLessonView> createState() => _SearchLessonViewState();
}

class _SearchLessonViewState extends ConsumerState<SearchLessonView> {
  final Map<String, TextEditingController> _responses =
      <String, TextEditingController>{};

  @override
  void dispose() {
    for (final controller in _responses.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const userId = 'local_user';
    final payload = widget.lesson.payload;
    final questions = (payload['questions'] as List<dynamic>? ?? <dynamic>[])
        .map((dynamic e) => e as Map<String, dynamic>)
        .toList();
    final exposition = (payload['exposition'] as List<dynamic>? ?? <dynamic>[])
        .cast<String>();
    final keyVerse = (payload['keyVerse'] as String? ?? '').trim();
    final supplementalScripture = ScriptureReferenceParser.parseReferenceList(
      payload['supplementalScripture'] as String?,
    );
    final resourceMaterial = (payload['resourceMaterial'] as String? ?? '')
        .trim();

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // Use the stored display number, or parse from ID as fallback
    final lessonNumber =
        widget.lesson.displayNumber?.toString() ??
        widget.lesson.id.replaceAll('lesson_', '');
    final unitTopic = (payload['unitTopic'] as String?)?.isNotEmpty == true
        ? payload['unitTopic'] as String
        : 'Search Unit';

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Unit Topic, Lesson Number & Lesson Topic
          Text(
            unitTopic.toUpperCase(),
            style: textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'LESSON $lessonNumber',
            style: textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.lesson.title,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 32),

          if (keyVerse.isNotEmpty) ...<Widget>[
            Text(
              'KEY VERSE',
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            _KeyVerseBlock(text: keyVerse),
            const SizedBox(height: 40),
          ],

          Text(
            'LESSON EXPOSITION',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Divider(
            thickness: 1,
            color: theme.colorScheme.outline.withOpacity(0.3),
          ),
          const SizedBox(height: 16),

          ..._buildExposition(context, exposition),

          if (supplementalScripture.isNotEmpty) ...<Widget>[
            const SizedBox(height: 40),
            Text(
              'SUPPLEMENTAL SCRIPTURES',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Divider(
              thickness: 1,
              color: theme.colorScheme.outline.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: supplementalScripture
                  .map(
                    (ref) => LinkedVerse(
                      reference: ref,
                      style: textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],

          if (resourceMaterial.isNotEmpty) ...<Widget>[
            const SizedBox(height: 40),
            Text(
              'RESOURCE MATERIAL',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Divider(
              thickness: 1,
              color: theme.colorScheme.outline.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Text(resourceMaterial, style: textTheme.bodyLarge),
            ),
          ],

          if (questions.isNotEmpty) ...<Widget>[
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'INTERACTIVE REFLECTION',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: _shareReflections,
                ),
              ],
            ),
            Divider(
              thickness: 1,
              color: theme.colorScheme.outline.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            ...questions.asMap().entries.map((entry) {
              final index = entry.key;
              final question = entry.value;
              final id = question['id'] as String? ?? 'q';
              final controller = _responses.putIfAbsent(
                id,
                () => TextEditingController(),
              );
              return Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: AppCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${index + 1}. ',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: _LinkedText(
                              question['prompt'] as String? ??
                                  'Reflect on this question',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _JournalQuestionInput(
                        lessonId: widget.lesson.id,
                        questionId: id,
                        prompt:
                            question['prompt'] as String? ??
                            'Reflect on this question',
                        controller: controller,
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            AppButton(
              label: 'Share My Reflections',
              isFullWidth: true,
              icon: Icons.ios_share,
              onPressed: _shareReflections,
            ),
          ],
          const SizedBox(height: 48),
          AppButton(
            label: 'Complete Lesson',
            icon: Icons.check_circle_outline,
            variant: AppButtonVariant.primary,
            onPressed: () async {
              await ref
                  .read(progressServiceProvider)
                  .recordCompletion(
                    userId: userId,
                    lessonId: widget.lesson.id,
                  );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lesson marked as completed!')),
                );
              }
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _shareReflections() {
    final content = _responses.entries
        .map((entry) => '${entry.key}: ${entry.value.text}')
        .join('\n');
    Share.share('Search lesson reflections:\n$content');
  }

  Iterable<Widget> _buildExposition(
    BuildContext context,
    List<String> exposition,
  ) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyLarge;
    final widgets = <Widget>[];
    for (final paragraph in exposition) {
      if (paragraph.trim().isEmpty) {
        continue;
      }
      widgets
        ..add(
          RichText(
            text: TextSpan(
              style: style,
              children: ScriptureReferenceParser.buildLinkedTextSpans(
                context,
                paragraph,
                style,
              ),
            ),
          ),
        )
        ..add(const SizedBox(height: 16));
    }
    if (widgets.isNotEmpty) {
      widgets.removeLast();
    }
    return widgets;
  }
}

class _KeyVerseBlock extends StatelessWidget {
  const _KeyVerseBlock({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyLarge?.copyWith(
      fontStyle: FontStyle.italic,
    );
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: theme.colorScheme.primary, width: 4),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: RichText(
        text: TextSpan(
          style: style,
          children: ScriptureReferenceParser.buildLinkedTextSpans(
            context,
            text,
            style,
          ),
        ),
      ),
    );
  }
}

class _LinkedText extends StatelessWidget {
  const _LinkedText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium;
    return RichText(
      text: TextSpan(
        style: style,
        children: ScriptureReferenceParser.buildLinkedTextSpans(
          context,
          text,
          style,
        ),
      ),
    );
  }
}

class _JournalQuestionInput extends StatefulHookConsumerWidget {
  const _JournalQuestionInput({
    required this.lessonId,
    required this.questionId,
    required this.prompt,
    required this.controller,
  });

  final String lessonId;
  final String questionId;
  final String prompt;
  final TextEditingController controller;

  @override
  ConsumerState<_JournalQuestionInput> createState() =>
      _JournalQuestionInputState();
}

class _JournalQuestionInputState extends ConsumerState<_JournalQuestionInput> {
  bool _hasAttemptedLoad = false;
  bool _isSaving = false;
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!_hasAttemptedLoad) {
      _hasAttemptedLoad = true;
      Future.microtask(() async {
        final db = ref.read(appDatabaseProvider);
        final entries = await db.getJournalEntries(
          'local_user',
          track: Track.search,
        );
        final myEntry = entries.firstWhere(
          (e) =>
              e.relatedLessonId == widget.lessonId &&
              e.prompt == widget.questionId,
          orElse: () => throw StateError('Not found'),
        );
        widget.controller.text = myEntry.response;
      }).catchError((_) {
        // No existing entry
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: widget.controller,
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
                    if (widget.controller.text.trim().isEmpty) return;

                    setState(() {
                      _isSaving = true;
                    });

                    final db = ref.read(appDatabaseProvider);
                    final uuid = const Uuid().v4();

                    // We try to find existing entry to keep the same ID and createdAt
                    String entryId = uuid;
                    DateTime createdAt = DateTime.now();

                    try {
                      final entries = await db.getJournalEntries(
                        'local_user',
                        track: Track.search,
                      );
                      final existing = entries.firstWhere(
                        (e) =>
                            e.relatedLessonId == widget.lessonId &&
                            e.prompt == widget.questionId,
                      );
                      entryId = existing.id;
                      createdAt = existing.createdAt;
                    } catch (_) {}

                    await db.upsertJournalEntry(
                      JournalEntry(
                        id: entryId,
                        userId: 'local_user',
                        relatedLessonId: widget.lessonId,
                        sourceTrack: Track.search,
                        prompt: widget.questionId,
                        response: widget.controller.text.trim(),
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
