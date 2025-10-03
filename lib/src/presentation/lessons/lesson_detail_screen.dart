import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../domain/lessons/entities.dart';

class LessonDetailScreen extends StatelessWidget {
  const LessonDetailScreen({super.key, required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ageLabel = lesson.ageRange != null
        ? '${lesson.ageRange!.min}-${lesson.ageRange!.max} years'
        : 'All ages';
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
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              ageLabel,
              style: theme.textTheme.bodySmall,
            ),
            if (lesson.objectives.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Objectives', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              ...lesson.objectives.map(
                (objective) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• '),
                      Expanded(child: Text(objective)),
                    ],
                  ),
                ),
              ),
            ],
            if (lesson.scriptures.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Scriptures', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: lesson.scriptures
                    .map(
                      (scripture) => Chip(
                        label: Text(scripture.reference),
                        avatar: scripture.translationId == null
                            ? null
                            : CircleAvatar(
                                child: Text(
                                  scripture.translationId!.toUpperCase(),
                                  style: theme.textTheme.labelSmall
                                      ?.copyWith(color: Colors.white),
                                ),
                              ),
                      ),
                    )
                    .toList(),
              ),
            ],
            const SizedBox(height: 16),
            if (lesson.contentHtml != null && lesson.contentHtml!.trim().isNotEmpty)
              Html(data: lesson.contentHtml)
            else
              const Text('This lesson does not have content yet.'),
            if (lesson.teacherNotes != null && lesson.teacherNotes!.trim().isNotEmpty) ...[
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Teacher Notes', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Html(data: lesson.teacherNotes),
                    ],
                  ),
                ),
              ),
            ],
            if (lesson.attachments.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('Attachments', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              ...lesson.attachments.map(
                (attachment) => Card(
                  child: ListTile(
                    leading: Icon(_iconForAttachment(attachment.type)),
                    title: Text(attachment.title ?? attachment.url),
                    subtitle: Text(attachment.url),
                    onTap: () {
                      // Attachments currently open externally; integration can be added later.
                    },
                  ),
                ),
              ),
            ],
            if (lesson.quizzes.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('Quizzes', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              ...lesson.quizzes.map((quiz) => _QuizCard(quiz: quiz)),
            ],
          ],
        ),
      ),
    );
  }

  static IconData _iconForAttachment(LessonAttachmentType type) {
    switch (type) {
      case LessonAttachmentType.image:
        return Icons.image_outlined;
      case LessonAttachmentType.audio:
        return Icons.audiotrack;
      case LessonAttachmentType.pdf:
        return Icons.picture_as_pdf;
      case LessonAttachmentType.video:
        return Icons.videocam_outlined;
      case LessonAttachmentType.link:
        return Icons.link_outlined;
    }
  }
}

class _QuizCard extends StatelessWidget {
  const _QuizCard({required this.quiz});

  final LessonQuiz quiz;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasOptions = quiz.options.isNotEmpty;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(quiz.prompt, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            if (hasOptions)
              ...quiz.options.map(
                (option) {
                  final isCorrect = quiz.answers.contains(option);
                  return Row(
                    children: [
                      Icon(
                        isCorrect
                            ? Icons.check_circle_outlined
                            : Icons.circle_outlined,
                        color: isCorrect ? theme.colorScheme.primary : null,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(option)),
                    ],
                  );
                },
              )
            else
              Text(
                quiz.answers.isEmpty
                    ? 'Short answer question'
                    : 'Expected answer: ${quiz.answers.join(", ")}',
                style: theme.textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }
}
