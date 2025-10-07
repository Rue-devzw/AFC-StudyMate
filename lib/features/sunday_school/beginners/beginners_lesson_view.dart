import 'package:flutter/material.dart';

import '../../../data/models/lesson.dart';

class BeginnersLessonView extends StatelessWidget {
  const BeginnersLessonView({required this.lesson, super.key});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final sections = (lesson.payload['sections'] as List<dynamic>? ?? <dynamic>[])
        .map((dynamic e) => e as Map<String, dynamic>)
        .toList();

    return PageView.builder(
      itemCount: sections.length,
      itemBuilder: (BuildContext context, int index) {
        final section = sections[index];
        final type = section['sectionType'] as String? ?? 'text';
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                section['sectionTitle'] as String? ?? 'Story moment',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      section['sectionContent'] as String? ?? 'Content coming soon.',
                      textScaler: TextScaler.linear(1.2),
                    ),
                  ),
                ),
              ),
              if (type == 'question')
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.record_voice_over),
                    label: const Text('Read aloud'),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
