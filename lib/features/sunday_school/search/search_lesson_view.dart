import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/models/lesson.dart';
import '../../../data/services/progress_service.dart';
import '../../../utils/scripture_reference_parser.dart';
import '../../../widgets/design_system_widgets.dart';
import '../../../widgets/linked_verse.dart';

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

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (keyVerse.isNotEmpty) ...<Widget>[
            _KeyVerseBlock(text: keyVerse),
            const SizedBox(height: 32),
          ],
          AppSectionTitle(title: 'Lesson Exposition'),
          const SizedBox(height: 12),
          ..._buildExposition(context, exposition),
          if (supplementalScripture.isNotEmpty) ...<Widget>[
            const SizedBox(height: 32),
            AppSectionTitle(title: 'Supplemental Scriptures'),
            const SizedBox(height: 12),
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
            const SizedBox(height: 32),
            AppSectionTitle(title: 'Resource Material'),
            const SizedBox(height: 12),
            AppCard(
              child: Text(resourceMaterial, style: textTheme.bodyLarge),
            ),
          ],
          if (questions.isNotEmpty) ...<Widget>[
            const SizedBox(height: 48),
            AppSectionTitle(
              title: 'Interactive Reflection',
              trailing: IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: _shareReflections,
              ),
            ),
            const SizedBox(height: 12),
            ...questions.map((question) {
              final id = question['id'] as String? ?? 'q';
              final controller = _responses.putIfAbsent(
                id,
                () => TextEditingController(),
              );
              return AppCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _LinkedText(
                      question['prompt'] as String? ??
                          'Reflect on this question',
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: controller,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Capture your thoughts here',
                        filled: true,
                        fillColor: theme.colorScheme.surfaceVariant.withOpacity(
                          0.3,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 32),
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
