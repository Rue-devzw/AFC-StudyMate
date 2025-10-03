import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/lessons/entities.dart';
import '../../domain/lessons/services/lesson_quiz_grader.dart';
import '../../domain/lessons/services/lesson_timer_service.dart';
import '../providers.dart';

class LessonDetailScreen extends ConsumerStatefulWidget {
  const LessonDetailScreen({super.key, required this.lesson});

  final Lesson lesson;

  @override
  ConsumerState<LessonDetailScreen> createState() =>
      _LessonDetailScreenState();
}

class _LessonDetailScreenState extends ConsumerState<LessonDetailScreen> {
  LessonProgress? _progress;
  late LessonTimerService _timerService;
  StreamSubscription<int>? _timerSub;
  int _sessionSeconds = 0;
  Map<String, LessonQuizSubmission> _responses = const {};
  double? _lastQuizScore;
  bool _isPersisting = false;
  String? _userId;
  ProviderSubscription<AsyncValue<LessonProgress?>>? _progressSubscription;

  @override
  void initState() {
    super.initState();
    _timerService =
        ref.read(lessonTimerServiceProvider(widget.lesson.id));
    _timerSub = _timerService.ticks.listen((seconds) {
      if (!mounted) {
        return;
      }
      setState(() {
        _sessionSeconds = seconds;
      });
    });
    ref.listen<String?>(
      activeUserIdProvider,
      (previous, next) {
        if (!mounted) {
          return;
        }
        if (next == null || next.isEmpty) {
          setState(() {
            _userId = null;
            _progress = null;
          });
          _progressSubscription?.close();
          _progressSubscription = null;
          return;
        }
        if (next != _userId) {
          _userId = next;
          _subscribeToProgress(next);
        }
      },
      fireImmediately: true,
    );
  }

  @override
  void dispose() {
    _timerSub?.cancel();
    _progressSubscription?.close();
    super.dispose();
  }

  void _subscribeToProgress(String userId) {
    _progressSubscription?.close();
    _progressSubscription = ref.listen<AsyncValue<LessonProgress?>>(
      lessonProgressProvider(
        LessonProgressRequest(
          userId: userId,
          lessonId: widget.lesson.id,
        ),
      ),
      (previous, next) {
        next.whenData((value) {
          if (!mounted) {
            return;
          }
          setState(() {
            _progress = value;
          });
        });
      },
      fireImmediately: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(activeUserIdProvider);
    if (userId == null || userId.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final theme = Theme.of(context);
    final ageLabel = widget.lesson.ageRange != null
        ? '${widget.lesson.ageRange!.min}-${widget.lesson.ageRange!.max} years'
        : 'All ages';
    final progressAsync = ref.watch(
      lessonProgressProvider(
        LessonProgressRequest(
          userId: userId,
          lessonId: widget.lesson.id,
        ),
      ),
    );
    final progress = progressAsync.maybeWhen(
      data: (value) => value,
      orElse: () => _progress,
    );
    final status = progress?.status ?? 'not_started';
    final totalSeconds = (progress?.timeSpentSeconds ?? 0) +
        (_timerService.isRunning ? _sessionSeconds : 0);
    final quizScore = progress?.quizScore ?? _lastQuizScore;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.lesson.lessonClass,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              ageLabel,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            _ProgressOverviewCard(
              status: status,
              totalSeconds: totalSeconds,
              startedAt: progress?.startedAt,
              completedAt: progress?.completedAt,
              updatedAt: progress?.updatedAt,
              quizScore: quizScore,
              isTimerRunning: _timerService.isRunning,
              sessionSeconds: _sessionSeconds,
              onStart: _isPersisting || _timerService.isRunning
                  ? null
                  : () =>
                      _handleStart(clearCompletion: status == 'completed'),
              onPause: _isPersisting || !_timerService.isRunning
                  ? null
                  : _handlePause,
              onComplete: _isPersisting || status == 'completed'
                  ? null
                  : _handleComplete,
            ),
            if (widget.lesson.objectives.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('Objectives', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              ...widget.lesson.objectives.map(
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
            if (widget.lesson.scriptures.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('Scriptures', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: widget.lesson.scriptures
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
            const SizedBox(height: 24),
            if (widget.lesson.contentHtml != null &&
                widget.lesson.contentHtml!.trim().isNotEmpty)
              Html(data: widget.lesson.contentHtml)
            else
              const Text('This lesson does not have content yet.'),
            if (widget.lesson.teacherNotes != null &&
                widget.lesson.teacherNotes!.trim().isNotEmpty) ...[
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Teacher Notes',
                          style: theme.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Html(data: widget.lesson.teacherNotes),
                    ],
                  ),
                ),
              ),
            ],
            if (widget.lesson.attachments.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('Attachments', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              ...widget.lesson.attachments.map(
                (attachment) => Card(
                  child: ListTile(
                    leading: Icon(_iconForAttachment(attachment.type)),
                    title: Text(attachment.title ?? attachment.url),
                    subtitle: Text(
                      attachment.localPath == null
                          ? attachment.url
                          : 'Available offline · ${attachment.url}',
                    ),
                    trailing: attachment.localPath == null
                        ? null
                        : const Icon(Icons.offline_pin, size: 18),
                    onTap: () {
                      // Attachments currently open externally; integration can be added later.
                    },
                  ),
                ),
              ),
            ],
            if (widget.lesson.quizzes.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('Quizzes', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              ...widget.lesson.quizzes.map(
                (quiz) => _InteractiveQuizCard(
                  quiz: quiz,
                  submission: _responses[quiz.id] ??
                      const LessonQuizSubmission(),
                  onOptionsChanged: (options) {
                    setState(() {
                      _responses = {
                        ..._responses,
                        quiz.id: LessonQuizSubmission(
                          selectedOptions: options,
                          shortAnswer:
                              _responses[quiz.id]?.shortAnswer,
                        ),
                      };
                    });
                  },
                  onShortAnswerChanged: (value) {
                    setState(() {
                      _responses = {
                        ..._responses,
                        quiz.id: LessonQuizSubmission(
                          selectedOptions:
                              _responses[quiz.id]?.selectedOptions ??
                                  const <String>{},
                          shortAnswer: value,
                        ),
                      };
                    });
                  },
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  onPressed:
                      _isPersisting || _responses.isEmpty ? null : _submitQuiz,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Submit quiz'),
                ),
              ),
              if (_lastQuizScore != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Latest quiz score: ${(_lastQuizScore! * 100).toStringAsFixed(0)}%',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
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
  Future<void> _handleStart({required bool clearCompletion}) async {
    if (_timerService.isRunning) {
      return;
    }
    _timerService.start();
    await _persistProgress(
      status: 'in_progress',
      consumeTimer: false,
      markStart: true,
      clearCompletion: clearCompletion,
    );
  }

  Future<void> _handlePause() async {
    if (!_timerService.isRunning) {
      return;
    }
    await _persistProgress(
      status: 'in_progress',
      consumeTimer: true,
      markStart: true,
    );
  }

  Future<void> _handleComplete() async {
    final score = _responses.isEmpty
        ? _progress?.quizScore
        : _computeQuizScore();
    await _persistProgress(
      status: 'completed',
      consumeTimer: true,
      markStart: true,
      markCompletion: true,
      quizScore: score,
    );
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lesson marked as completed.')),
    );
  }

  Future<void> _submitQuiz() async {
    final score = _computeQuizScore();
    await _persistProgress(
      status: _progress?.status ?? 'in_progress',
      consumeTimer: false,
      markStart: _progress?.status == null,
      quizScore: score,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _lastQuizScore = score;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Quiz graded: ${(score * 100).toStringAsFixed(0)}%',
        ),
      ),
    );
  }

  double _computeQuizScore() {
    final grader = ref.read(lessonQuizGraderProvider);
    final score = grader.grade(widget.lesson.quizzes, _responses);
    setState(() {
      _lastQuizScore = score;
    });
    return score;
  }

  Future<void> _persistProgress({
    required String status,
    required bool consumeTimer,
    required bool markStart,
    bool markCompletion = false,
    bool clearCompletion = false,
    double? quizScore,
  }) async {
    if (_isPersisting) {
      return;
    }
    setState(() {
      _isPersisting = true;
    });
    final userId = _userId;
    if (userId == null || userId.isEmpty) {
      setState(() {
        _isPersisting = false;
      });
      return;
    }
    final elapsedSeconds = consumeTimer ? _timerService.consume() : 0;
    final now = DateTime.now();
    final existing = _progress;
    final startedAt = markStart
        ? (existing?.startedAt ?? now)
        : existing?.startedAt;
    final completedAt = markCompletion
        ? now
        : (clearCompletion ? null : existing?.completedAt);
    final progress = LessonProgress(
      id: existing?.id ?? '${userId}_${widget.lesson.id}',
      userId: userId,
      lessonId: widget.lesson.id,
      status: status,
      quizScore: quizScore ?? existing?.quizScore,
      timeSpentSeconds:
          (existing?.timeSpentSeconds ?? 0) + elapsedSeconds,
      updatedAt: now,
      startedAt: startedAt,
      completedAt: completedAt,
    );
    final update = ref.read(updateProgressUseCaseProvider);
    await update(progress);
    if (mounted) {
      setState(() {
        _isPersisting = false;
      });
    }
  }
}

class _ProgressOverviewCard extends StatelessWidget {
  const _ProgressOverviewCard({
    required this.status,
    required this.totalSeconds,
    required this.startedAt,
    required this.completedAt,
    required this.updatedAt,
    required this.quizScore,
    required this.isTimerRunning,
    required this.sessionSeconds,
    required this.onStart,
    required this.onPause,
    required this.onComplete,
  });

  final String status;
  final int totalSeconds;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? updatedAt;
  final double? quizScore;
  final bool isTimerRunning;
  final int sessionSeconds;
  final VoidCallback? onStart;
  final VoidCallback? onPause;
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusLabel = _statusLabel(status);
    final totalDuration = _formatDuration(totalSeconds);
    final sessionDuration = _formatDuration(sessionSeconds);
    final quizLabel = quizScore == null
        ? 'Not graded'
        : '${(quizScore! * 100).toStringAsFixed(0)}%';
    final startLabel = status == 'completed'
        ? 'Restart'
        : (isTimerRunning ? 'Resume' : 'Start');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Progress', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _InfoChip(label: 'Status', value: statusLabel),
                _InfoChip(label: 'Total time', value: totalDuration),
                if (isTimerRunning)
                  _InfoChip(label: 'Current session', value: sessionDuration),
                if (startedAt != null)
                  _InfoChip(
                    label: 'Started',
                    value: _formatDate(startedAt!),
                  ),
                if (completedAt != null)
                  _InfoChip(
                    label: 'Completed',
                    value: _formatDate(completedAt!),
                  ),
                if (updatedAt != null)
                  _InfoChip(
                    label: 'Updated',
                    value: _formatDate(updatedAt!),
                  ),
                _InfoChip(label: 'Quiz score', value: quizLabel),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: onStart,
                  icon: Icon(isTimerRunning ? Icons.timer : Icons.play_arrow),
                  label: Text(startLabel),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: onPause,
                  icon: const Icon(Icons.pause_circle_outline),
                  label: const Text('Pause'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: onComplete,
                  icon: const Icon(Icons.flag_outlined),
                  label: const Text('Complete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _statusLabel(String status) {
    switch (status) {
      case 'completed':
        return 'Completed';
      case 'in_progress':
        return 'In progress';
      default:
        return 'Not started';
    }
  }

  static String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final secs = duration.inSeconds % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    if (minutes > 0) {
      return '${minutes}m ${secs}s';
    }
    return '${secs}s';
  }

  static String _formatDate(DateTime dateTime) {
    final local = dateTime.toLocal();
    final twoDigits = (int n) => n.toString().padLeft(2, '0');
    final year = local.year.toString().padLeft(4, '0');
    final month = twoDigits(local.month);
    final day = twoDigits(local.day);
    final hour = twoDigits(local.hour);
    final minute = twoDigits(local.minute);
    return '$year-$month-$day $hour:$minute';
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Chip(
      label: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: theme.textTheme.labelSmall),
          Text(value, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _InteractiveQuizCard extends StatelessWidget {
  const _InteractiveQuizCard({
    required this.quiz,
    required this.submission,
    required this.onOptionsChanged,
    required this.onShortAnswerChanged,
  });

  final LessonQuiz quiz;
  final LessonQuizSubmission submission;
  final ValueChanged<Set<String>> onOptionsChanged;
  final ValueChanged<String> onShortAnswerChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasOptions = quiz.options.isNotEmpty;
    final allowMultiple = quiz.answers.length > 1;
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
              ...quiz.options.map((option) {
                if (allowMultiple) {
                  return CheckboxListTile(
                    value: submission.selectedOptions.contains(option),
                    onChanged: (selected) {
                      final updated = <String>{
                        ...submission.selectedOptions,
                      };
                      if (selected ?? false) {
                        updated.add(option);
                      } else {
                        updated.remove(option);
                      }
                      onOptionsChanged(updated);
                    },
                    title: Text(option),
                  );
                }
                final groupValue =
                    submission.selectedOptions.isEmpty
                        ? null
                        : submission.selectedOptions.first;
                return RadioListTile<String>(
                  value: option,
                  groupValue: groupValue,
                  onChanged: (_) {
                    onOptionsChanged({option});
                  },
                  title: Text(option),
                );
              })
            else
              TextFormField(
                initialValue: submission.shortAnswer,
                decoration:
                    const InputDecoration(labelText: 'Your answer'),
                onChanged: onShortAnswerChanged,
              ),
          ],
        ),
      ),
    );
  }
}
