import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/models/lesson.dart';

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

    return ListView(
      padding: const EdgeInsets.all(24),
      children: <Widget>[
        Text(widget.lesson.title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Text(payload['keyVerse'] as String? ?? 'Key verse forthcoming.'),
        const SizedBox(height: 24),
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
                  Text(question['prompt'] as String? ?? 'Reflect on this question'),
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
            final content = _responses.entries.map((entry) => '${entry.key}: ${entry.value.text}').join('\n');
            Share.share('Search lesson reflections:\n$content');
          },
          icon: const Icon(Icons.ios_share),
          label: const Text('Export answers'),
        ),
      ],
    );
  }
}
