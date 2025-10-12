import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/models/lesson.dart';
import '../../../utils/scripture_reference_parser.dart';
import '../../../widgets/linked_verse.dart';

class SearchLessonView extends StatefulWidget {
  const SearchLessonView({required this.lesson, super.key});

  final Lesson lesson;

  @override
  State<SearchLessonView> createState() => _SearchLessonViewState();
}

class _SearchLessonViewState extends State<SearchLessonView> {
  final Map<String, TextEditingController> _responses = <String, TextEditingController>{};

  @override
  void dispose() {
    for (final controller in _responses.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final payload = widget.lesson.payload;
    final questions = (payload['questions'] as List<dynamic>? ?? <dynamic>[])
        .map((dynamic e) => e as Map<String, dynamic>)
        .toList();
    final exposition = (payload['exposition'] as List<dynamic>? ?? <dynamic>[]).cast<String>();
    final keyVerse = (payload['keyVerse'] as String? ?? '').trim();
    final supplementalScripture = ScriptureReferenceParser.parseReferenceList(
      payload['supplementalScripture'] as String?,
    );
    final resourceMaterial = (payload['resourceMaterial'] as String? ?? '').trim();

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: <Widget>[
        Text(widget.lesson.title, style: textTheme.headlineSmall),
        if (widget.lesson.weekIndex != null) ...<Widget>[
          const SizedBox(height: 4),
          Text(
            'Lesson ${widget.lesson.weekIndex}',
            style: textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        const SizedBox(height: 24),
        if (keyVerse.isNotEmpty) ...<Widget>[
          _KeyVerseBlock(text: keyVerse),
          const SizedBox(height: 24),
        ],
        if (exposition.isNotEmpty) ...<Widget>[..._buildExposition(context, exposition)],
        if (supplementalScripture.isNotEmpty) ...<Widget>[
          const SizedBox(height: 24),
          Text('Supplemental Scriptures', style: textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: supplementalScripture
                .map((ref) => LinkedVerse(reference: ref, style: textTheme.bodyMedium))
                .toList(),
          ),
        ],
        if (resourceMaterial.isNotEmpty) ...<Widget>[
          const SizedBox(height: 24),
          Text('Resource Material', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(resourceMaterial, style: textTheme.bodyMedium),
        ],
        if (questions.isNotEmpty) ...<Widget>[
          const SizedBox(height: 32),
          Text('Interactive Questions', style: textTheme.titleMedium),
          const SizedBox(height: 12),
        ],
        ...questions.map((question) {
          final id = question['id'] as String? ?? 'q';
          final controller = _responses.putIfAbsent(id, () => TextEditingController());
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _LinkedText(question['prompt'] as String? ?? 'Reflect on this question'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Capture your thoughts here',
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {
            final content = _responses.entries
                .map((entry) => '${entry.key}: ${entry.value.text}')
                .join('\n');
            Share.share('Search lesson reflections:\n$content');
          },
          icon: const Icon(Icons.ios_share),
          label: const Text('Export answers'),
        ),
      ],
    );
  }

  Iterable<Widget> _buildExposition(BuildContext context, List<String> exposition) {
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
              children: ScriptureReferenceParser.buildLinkedTextSpans(context, paragraph, style),
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
    final style = theme.textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: theme.colorScheme.primary, width: 4)),
      ),
      padding: const EdgeInsets.all(20),
      child: RichText(
        text: TextSpan(
          style: style,
          children: ScriptureReferenceParser.buildLinkedTextSpans(context, text, style),
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
        children: ScriptureReferenceParser.buildLinkedTextSpans(context, text, style),
      ),
    );
  }
}
