import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/lesson.dart';
import '../services/lesson_completion_service.dart';

class LessonDetailScreen extends StatefulWidget {
  final Lesson lesson;

  const LessonDetailScreen({super.key, required this.lesson});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  final LessonCompletionService _completionService = LessonCompletionService();
  bool _isCompleted = false;
  int? _selectedQuizOption;

  @override
  void initState() {
    super.initState();
    _loadCompletionStatus();
  }

  Future<void> _loadCompletionStatus() async {
    final completed = await _completionService.isLessonCompleted(widget.lesson.title);
    if (mounted) {
      setState(() {
        _isCompleted = completed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
        actions: [
          if (_isCompleted)
            const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(Icons.check_circle, color: Colors.green),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (!_isCompleted) {
            await _completionService.markLessonAsComplete(widget.lesson.title);
            if (!mounted) return;
            setState(() {
              _isCompleted = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Lesson marked as complete!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        label: Text(_isCompleted ? 'Completed' : 'Mark as Complete'),
        icon: Icon(_isCompleted ? Icons.check : Icons.check_box_outline_blank),
        backgroundColor: _isCompleted ? Colors.green : theme.colorScheme.secondary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0), // Add padding for FAB
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, 'Class: ${widget.lesson.className} (${widget.lesson.ageRange})'),
            const SizedBox(height: 16),
            _buildSectionTitle(context, 'Objectives'),
            ...widget.lesson.objectives.map((objective) => Text('• $objective')),
            const SizedBox(height: 16),
            _buildSectionTitle(context, 'Scriptures'),
            ...widget.lesson.scriptures.map((scripture) => Text('• ${scripture.book} ${scripture.chapter}:${scripture.verses.join(", ")}')),
            const SizedBox(height: 16),
            _buildSectionTitle(context, 'Content'),
            Html(
              data: widget.lesson.contentHtml,
              onLinkTap: (url, _, __) async {
                if (url != null) {
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                }
              },
            ),
            if (widget.lesson.teacherNotes != null) ...[
              const SizedBox(height: 16),
              _buildSectionTitle(context, 'Teacher Notes'),
              Text(widget.lesson.teacherNotes!),
            ],
            if (widget.lesson.attachments.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildSectionTitle(context, 'Attachments'),
              ...widget.lesson.attachments.map((attachment) => ListTile(
                    title: Text(attachment.type),
                    subtitle: Text(attachment.url),
                    onTap: () async {
                      final uri = Uri.parse(attachment.url);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      }
                    },
                  )),
            ],
            if (widget.lesson.quizzes.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildSectionTitle(context, 'Quiz'),
              ...widget.lesson.quizzes.map((quiz) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(quiz.question, style: theme.textTheme.titleMedium),
                      ...quiz.options.asMap().entries.map((entry) {
                        final index = entry.key;
                        final option = entry.value;
                        return RadioListTile<int>(
                          title: Text(option),
                          value: index,
                          groupValue: _selectedQuizOption,
                          onChanged: (int? value) {
                            setState(() {
                              _selectedQuizOption = value;
                            });
                          },
                        );
                      }),
                    ],
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
