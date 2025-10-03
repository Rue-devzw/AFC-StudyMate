import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/lessons/progress_dashboard.dart';
import '../providers.dart';

class LessonProgressDashboardScreen extends ConsumerWidget {
  const LessonProgressDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(lessonProgressDashboardProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress dashboard'),
        actions: [
          dashboardAsync.maybeWhen(
            data: (data) => IconButton(
              icon: const Icon(Icons.ios_share),
              tooltip: 'Export CSV',
              onPressed: () => _export(context, data),
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: dashboardAsync.when(
        data: (data) => _DashboardBody(data: data),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Failed to load dashboard: $error'),
          ),
        ),
      ),
    );
  }

  Future<void> _export(
    BuildContext context,
    LessonProgressDashboardData data,
  ) async {
    final csv = _buildCsv(data);
    await Share.share(
      csv,
      subject: 'Lesson progress export',
    );
  }

  String _buildCsv(LessonProgressDashboardData data) {
    final buffer = StringBuffer()
      ..writeln(
        'Lesson,Class,Status,TimeSpentSeconds,QuizScore,StartedAt,CompletedAt,UpdatedAt',
      );
    for (final snapshot in data.snapshots) {
      final progress = snapshot.progress;
      final status = progress?.status ?? 'not_started';
      final timeSpent = progress?.timeSpentSeconds ?? 0;
      final quizScore = progress?.quizScore ?? 0.0;
      final startedAt = progress?.startedAt?.toIso8601String() ?? '';
      final completedAt = progress?.completedAt?.toIso8601String() ?? '';
      final updatedAt = progress?.updatedAt.toIso8601String() ?? '';
      buffer.writeln(
        '"${snapshot.lesson.title}",' // lesson title quoted
        '"${snapshot.lesson.lessonClass}",' // class
        '$status,'
        '$timeSpent,'
        '${quizScore.toStringAsFixed(2)},'
        '$startedAt,'
        '$completedAt,'
        '$updatedAt',
      );
    }
    return buffer.toString();
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.data});

  final LessonProgressDashboardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final totalLessons = data.totalLessons;
    final completionRate = data.completionRate * 100;
    final totalTime = _formatDuration(data.totalTimeSpentSeconds);
    final averageScore = (data.averageQuizScore * 100).toStringAsFixed(0);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _SummaryTile(
              label: 'Total lessons',
              value: '$totalLessons',
              color: colorScheme.primaryContainer,
            ),
            _SummaryTile(
              label: 'Completed',
              value: '${data.completedCount}',
              color: colorScheme.secondaryContainer,
            ),
            _SummaryTile(
              label: 'In progress',
              value: '${data.inProgressCount}',
              color: colorScheme.tertiaryContainer,
            ),
            _SummaryTile(
              label: 'Completion rate',
              value: '${completionRate.toStringAsFixed(0)}%',
              color: colorScheme.surfaceVariant,
            ),
            _SummaryTile(
              label: 'Time spent',
              value: totalTime,
              color: colorScheme.primaryContainer.withOpacity(0.7),
            ),
            _SummaryTile(
              label: 'Avg quiz score',
              value: '$averageScore%',
              color: colorScheme.secondaryContainer.withOpacity(0.7),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text('Class breakdown', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        if (data.classSummaries.isEmpty)
          const Text('No tracked progress yet.')
        else
          ...data.classSummaries.map(
            (summary) => Card(
              child: ListTile(
                title: Text(summary.lessonClass),
                subtitle: Text(
                  'Completed ${summary.completedLessons}/${summary.totalLessons} · '
                  'In progress ${summary.inProgressLessons} · '
                  'Not started ${summary.notStartedLessons}',
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Time ${_formatDuration(summary.totalTimeSpentSeconds)}'),
                    Text('Avg score ${(summary.averageQuizScore * 100).toStringAsFixed(0)}%'),
                  ],
                ),
              ),
            ),
          ),
        const SizedBox(height: 24),
        Text('Completion trend', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        if (data.completionsByDay.isEmpty)
          const Text('No completions recorded yet.')
        else
          ...[
            for (final entry
                in data.completionsByDay.entries.toList()
                  ..sort((a, b) => a.key.compareTo(b.key)))
              ListTile(
                leading: const Icon(Icons.event_available_outlined),
                title: Text(_formatDate(entry.key)),
                trailing: Text('${entry.value} completed'),
              ),
          ],
      ],
    );
  }

  static String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    if (minutes > 0) {
      return '${minutes}m';
    }
    return '${duration.inSeconds}s';
  }

  static String _formatDate(DateTime date) {
    final local = date.toLocal();
    final twoDigits = (int n) => n.toString().padLeft(2, '0');
    return '${local.year}-${twoDigits(local.month)}-${twoDigits(local.day)}';
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelSmall),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
