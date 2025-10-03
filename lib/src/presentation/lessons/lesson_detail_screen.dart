import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/accounts/entities.dart';
import '../../domain/lessons/entities.dart';
import '../../domain/lessons/services/lesson_quiz_grader.dart';
import '../../domain/lessons/services/lesson_timer_service.dart';
import '../../domain/meetings/entities.dart';
import '../providers.dart';
import '../chat/chat_room_screen.dart';

class LessonDetailScreen extends ConsumerStatefulWidget {
  const LessonDetailScreen({super.key, required this.lesson});

  final Lesson lesson;

  @override
  ConsumerState<LessonDetailScreen> createState() => _LessonDetailScreenState();
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
  List<LessonAttachment> _extraAttachments = const [];
  bool _isUploadingRecording = false;

  @override
  void initState() {
    super.initState();
    _timerService = ref.read(lessonTimerServiceProvider(widget.lesson.id));
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

  bool _canHostLesson(LocalAccount? account) {
    if (account == null) {
      return false;
    }
    final roles = account.roles.map((role) => role.toLowerCase()).toSet();
    return roles.contains('teacher') ||
        roles.contains('facilitator') ||
        roles.contains('admin');
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
    final accountAsync = ref.watch(activeAccountProvider);
    final account = accountAsync.maybeWhen(
      data: (value) => value,
      orElse: () => null,
    );
    final meetingLinksAsync = ref.watch(
      meetingLinksProvider(
        MeetingLinkQuery(
          contextType: MeetingContextType.lesson,
          contextId: widget.lesson.id,
        ),
      ),
    );
    final meetingLinks = meetingLinksAsync.maybeWhen(
      data: (links) => links,
      orElse: () => const <MeetingLink>[],
    );
    final hostLink = meetingLinks.latestForRole(MeetingRole.host);
    final attendeeLink = meetingLinks.latestForRole(MeetingRole.participant);
    final recordingLinks = meetingLinks.recordings().toList();
    final canHostLesson = _canHostLesson(account);
    final chatClassId = normaliseClassId(widget.lesson.lessonClass);
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

    final attachments = _composeAttachments(recordingLinks);

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
                  : () => _handleStart(clearCompletion: status == 'completed'),
              onPause: _isPersisting || !_timerService.isRunning
                  ? null
                  : _handlePause,
              onComplete: _isPersisting || status == 'completed'
                  ? null
                  : _handleComplete,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.forum_outlined),
                label: const Text('Open class chat'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatRoomScreen(
                        classId: chatClassId,
                        className: widget.lesson.lessonClass,
                      ),
                    ),
                  );
                },
              ),
            ),
            if (canHostLesson || hostLink != null || attendeeLink != null) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (canHostLesson)
                    FilledButton.icon(
                      onPressed: () => _startLessonMeeting(hostLink),
                      icon: const Icon(Icons.video_call),
                      label: Text(
                        hostLink == null
                            ? 'Start live lesson'
                            : 'Resume live lesson',
                      ),
                    ),
                  if (canHostLesson && hostLink != null)
                    OutlinedButton.icon(
                      onPressed: () =>
                          _joinLessonMeeting(MeetingRole.host, hostLink),
                      icon: const Icon(Icons.meeting_room_outlined),
                      label: const Text('Join as host'),
                    ),
                  if (!canHostLesson &&
                      (attendeeLink != null || hostLink != null))
                    OutlinedButton.icon(
                      onPressed: () => _joinLessonMeeting(
                        MeetingRole.participant,
                        attendeeLink ?? hostLink,
                      ),
                      icon: const Icon(Icons.meeting_room_outlined),
                      label: const Text('Join live lesson'),
                    ),
                  if (canHostLesson)
                    OutlinedButton.icon(
                      onPressed:
                          _isUploadingRecording ? null : _uploadRecording,
                      icon: _isUploadingRecording
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.upload_file),
                      label: Text(
                        _isUploadingRecording
                            ? 'Uploading...'
                            : 'Upload recording',
                      ),
                    ),
                ],
              ),
            ],
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
                      Text('Teacher Notes', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Html(data: widget.lesson.teacherNotes),
                    ],
                  ),
                ),
              ),
            ],
            if (attachments.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('Attachments', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              ...attachments.map(
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
                  submission:
                      _responses[quiz.id] ?? const LessonQuizSubmission(),
                  onOptionsChanged: (options) {
                    setState(() {
                      _responses = {
                        ..._responses,
                        quiz.id: LessonQuizSubmission(
                          selectedOptions: options,
                          shortAnswer: _responses[quiz.id]?.shortAnswer,
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

  List<LessonAttachment> _composeAttachments(
    List<MeetingLink> recordingLinks,
  ) {
    final attachments = <LessonAttachment>[];
    final seen = <String>{};

    void addAttachment(LessonAttachment attachment) {
      if (seen.add(attachment.url)) {
        attachments.add(attachment);
      }
    }

    for (final attachment in widget.lesson.attachments) {
      addAttachment(attachment);
    }
    for (final attachment in _extraAttachments) {
      addAttachment(attachment);
    }

    var nextPosition = attachments.isEmpty
        ? 0
        : attachments.map((a) => a.position).fold<int>(
                  0,
                  (previousValue, element) =>
                      element > previousValue ? element : previousValue,
                ) +
            1;

    for (final link in recordingLinks) {
      final url = link.recordingUrl?.toString();
      if (url == null || seen.contains(url)) {
        continue;
      }
      final label = link.recordingIndexedAt == null
          ? '${link.title} recording'
          : '${link.title} (${link.recordingIndexedAt!.toLocal()})';
      addAttachment(
        LessonAttachment(
          type: LessonAttachmentType.recording,
          url: url,
          position: nextPosition++,
          title: label,
        ),
      );
    }
    attachments.sort((a, b) => a.position.compareTo(b.position));
    return attachments;
  }

  Future<void> _startLessonMeeting(MeetingLink? existingHostLink) async {
    final launcher = ref.read(meetingLauncherProvider);
    final account = ref.read(activeAccountProvider).asData?.value;
    final result = await launcher.launch(
      MeetingLaunchRequest(
        contextType: MeetingContextType.lesson,
        contextId: widget.lesson.id,
        title: widget.lesson.title,
        role: MeetingRole.host,
        roomName: existingHostLink?.roomName,
        displayName: account?.displayName,
        scheduledStart: existingHostLink?.scheduledStart ?? DateTime.now(),
        createParticipantLink: true,
      ),
    );
    if (!mounted) {
      return;
    }
    final message = result.wasLaunched
        ? 'Live lesson started.'
        : 'Offline - meeting link saved for later.';
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _joinLessonMeeting(MeetingRole role, MeetingLink? link) async {
    final launcher = ref.read(meetingLauncherProvider);
    final account = ref.read(activeAccountProvider).asData?.value;
    final result = await launcher.launch(
      MeetingLaunchRequest(
        contextType: MeetingContextType.lesson,
        contextId: widget.lesson.id,
        title: widget.lesson.title,
        role: role,
        roomName: link?.roomName,
        displayName: account?.displayName,
        scheduledStart: link?.scheduledStart ?? DateTime.now(),
      ),
    );
    if (!mounted) {
      return;
    }
    final message = result.wasLaunched
        ? (role == MeetingRole.host
            ? 'Joined live lesson as host.'
            : 'Joining live lesson.')
        : 'Offline - meeting link saved for later.';
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _uploadRecording() async {
    if (_isUploadingRecording) {
      return;
    }
    final account = ref.read(activeAccountProvider).asData?.value;
    if (!_canHostLesson(account)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Only hosts can upload recordings.')),
      );
      return;
    }
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['mp4', 'mov', 'mkv', 'webm'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) {
      return;
    }
    final picked = result.files.single;
    setState(() {
      _isUploadingRecording = true;
    });
    try {
      final storage = ref.read(firebaseStorageProvider);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final storagePath =
          'lesson_recordings/${widget.lesson.id}/$timestamp-${picked.name}';
      final bytes = picked.bytes;
      if (bytes == null) {
        throw Exception('No file data available for upload.');
      }
      final uploadTask = storage.ref(storagePath).putData(bytes);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      final savedAttachment =
          await ref.read(lessonRepositoryProvider).addAttachment(
                widget.lesson.id,
                LessonAttachment(
                  type: LessonAttachmentType.recording,
                  url: downloadUrl,
                  position: 0,
                  title: picked.name,
                ),
              );
      setState(() {
        _extraAttachments = [..._extraAttachments, savedAttachment];
      });
      await ref.read(meetingRepositoryProvider).saveRecording(
            MeetingContextType.lesson,
            widget.lesson.id,
            recordingUrl: Uri.parse(downloadUrl),
            storagePath: storagePath,
            indexedAt: DateTime.now(),
          );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recording uploaded and indexed.')),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload recording: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingRecording = false;
        });
      }
    }
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
      case LessonAttachmentType.recording:
        return Icons.play_circle_outline;
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
    final score =
        _responses.isEmpty ? _progress?.quizScore : _computeQuizScore();
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
    final startedAt =
        markStart ? (existing?.startedAt ?? now) : existing?.startedAt;
    final completedAt =
        markCompletion ? now : (clearCompletion ? null : existing?.completedAt);
    final progress = LessonProgress(
      id: existing?.id ?? '${userId}_${widget.lesson.id}',
      userId: userId,
      lessonId: widget.lesson.id,
      status: status,
      quizScore: quizScore ?? existing?.quizScore,
      timeSpentSeconds: (existing?.timeSpentSeconds ?? 0) + elapsedSeconds,
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
                final groupValue = submission.selectedOptions.isEmpty
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
                decoration: const InputDecoration(labelText: 'Your answer'),
                onChanged: onShortAnswerChanged,
              ),
          ],
        ),
      ),
    );
  }
}
