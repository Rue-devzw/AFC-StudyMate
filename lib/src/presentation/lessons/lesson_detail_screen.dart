import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../domain/lessons/entities.dart';

class LessonDetailScreen extends StatelessWidget {
  const LessonDetailScreen({super.key, required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lesson.lessonClass,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            if (lesson.contentHtml != null)
              Html(data: lesson.contentHtml)
            else
              const Text('This lesson does not have content yet.'),
            const SizedBox(height: 24),
            if (lesson.teacherNotes != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Teacher Notes',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Html(data: lesson.teacherNotes),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
