import 'package:afc_studymate/data/drift/app_database.dart';
import 'package:afc_studymate/data/models/attendance_record.dart';
import 'package:afc_studymate/data/models/attendance_session_summary.dart';
import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/lesson.dart';
import 'package:afc_studymate/data/models/student.dart';
import 'package:afc_studymate/data/providers/app_refresh_providers.dart';
import 'package:afc_studymate/data/repositories/lesson_pdf_repository.dart';
import 'package:afc_studymate/data/repositories/lesson_repository.dart';
import 'package:afc_studymate/data/services/analytics_service.dart';
import 'package:afc_studymate/widgets/design_system_widgets.dart';
import 'package:afc_studymate/widgets/pdf_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final _rosterRefreshProvider = StateProvider<int>((ref) => 0);

final _studentsProvider = FutureProvider<List<Student>>((ref) async {
  ref.watch(_rosterRefreshProvider);
  ref.watch(appDataRefreshTickProvider);
  return ref.read(appDatabaseProvider).getStudents();
});

class ClassRosterScreen extends ConsumerStatefulWidget {
  const ClassRosterScreen({super.key});

  static const routeName = 'classRoster';

  @override
  ConsumerState<ClassRosterScreen> createState() => _ClassRosterScreenState();
}

class _ClassRosterScreenState extends ConsumerState<ClassRosterScreen> {
  Track _selectedTrack = Track.search;
  DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(_studentsProvider);

    return PremiumScaffold(
      backgroundAsset: 'assets/images/bg_sunday_school.png',
      backgroundSlot: PremiumBackgroundSlots.classRoster,
      appBar: AppBar(
        title: const Text(
          'Class Roster',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _addStudent,
            icon: const Icon(Icons.person_add, color: Colors.white),
            tooltip: 'Add student',
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<Track>(
                      initialValue: _selectedTrack,
                      dropdownColor: const Color(0xFF1C1C1E),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Track',
                      ),
                      items: Track.values
                          .where(
                            (t) => t != Track.daybreak && t != Track.discovery,
                          )
                          .map(
                            (track) => DropdownMenuItem(
                              value: track,
                              child: Text(track.label),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _selectedTrack = value);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(DateFormat.MMMd().format(_date)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: studentsAsync.when(
                data: (students) => _RosterList(
                  students: students,
                  track: _selectedTrack,
                  date: _date,
                  onSessionDateSelected: (date) {
                    setState(() => _date = date);
                  },
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                error: (error, stackTrace) => Center(
                  child: Text(
                    'Could not load roster: $error',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addStudent,
        label: const Text('Add Student'),
        icon: const Icon(Icons.person_add_alt_1),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _addStudent() async {
    final controller = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Student'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Student name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              await ref
                  .read(appDatabaseProvider)
                  .upsertStudent(
                    Student(
                      id: const Uuid().v4(),
                      name: name,
                      createdAt: DateTime.now(),
                    ),
                  );
              ref.read(_rosterRefreshProvider.notifier).state++;
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _RosterList extends ConsumerStatefulWidget {
  const _RosterList({
    required this.students,
    required this.track,
    required this.date,
    required this.onSessionDateSelected,
  });

  final List<Student> students;
  final Track track;
  final DateTime date;
  final ValueChanged<DateTime> onSessionDateSelected;

  @override
  ConsumerState<_RosterList> createState() => _RosterListState();
}

class _RosterListState extends ConsumerState<_RosterList> {
  String? _lastSaveMessage;
  DateTime? _lastSavedAt;

  @override
  Widget build(BuildContext context) {
    if (widget.students.isEmpty) {
      return const Center(
        child: Text(
          'No students yet. Add your class roster to start attendance.',
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.center,
        ),
      );
    }

    return FutureBuilder(
      future: ref
          .read(lessonRepositoryProvider)
          .getSundayLessonForDate(
            widget.track,
            widget.date,
          ),
      builder: (context, lessonSnapshot) {
        final lessonId =
            lessonSnapshot.data?.id ??
            '${widget.track.name}_${DateFormat('yyyy_MM_dd').format(widget.date)}';
        final dateKey = DateFormat('yyyy-MM-dd').format(widget.date);
        final lesson = lessonSnapshot.data;

        return FutureBuilder<Map<String, AttendanceRecord>>(
          future: ref
              .read(appDatabaseProvider)
              .getAttendanceForSession(
                lessonId: lessonId,
                dateKey: dateKey,
              ),
          builder: (context, attendanceSnapshot) {
            final attendance = attendanceSnapshot.data ?? {};
            final attendanceByStudent = {
              for (final record in attendance.values) record.studentId: record,
            };
            final presentCount = attendanceByStudent.values
                .where((record) => record.present)
                .length;
            final markedCount = attendanceByStudent.length;
            final absentCount = markedCount - presentCount;
            final unmarkedCount = widget.students.length - markedCount;
            final guide = lesson == null
                ? null
                : ref
                      .read(lessonPdfRepositoryProvider)
                      .teacherGuideForLesson(lesson);

            return ListView.builder(
              padding: EdgeInsets.fromLTRB(
                16,
                8,
                16,
                standardBottomContentPadding(context),
              ),
              itemCount: widget.students.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: PremiumGlassCard(
                      borderRadius: BorderRadius.circular(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.track.label,
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: Colors.white70,
                                  letterSpacing: 1.1,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            lesson?.title ?? 'Planned session',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Attendance for ${DateFormat.yMMMMd().format(widget.date)}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _SummaryChip(
                                label: 'Students ${widget.students.length}',
                                icon: Icons.people_outline,
                              ),
                              _SummaryChip(
                                label: 'Present $presentCount',
                                icon: Icons.check_circle_outline,
                              ),
                              _SummaryChip(
                                label: 'Absent $absentCount',
                                icon: Icons.cancel_outlined,
                              ),
                              _SummaryChip(
                                label: 'Unmarked $unmarkedCount',
                                icon: Icons.pending_outlined,
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          FutureBuilder<_AttendanceInsightSummary>(
                            future: _loadAttendanceInsights(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const SizedBox.shrink();
                              }
                              final insights = snapshot.data!;
                              return Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.06),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.08),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Attendance Insights',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      insights.caption,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        _InsightChip(
                                          label: 'Recent Avg',
                                          value: insights.recentAverageLabel,
                                          icon: Icons.timeline_rounded,
                                        ),
                                        _InsightChip(
                                          label: 'Best Turnout',
                                          value: insights.bestTurnoutLabel,
                                          icon: Icons.emoji_events_outlined,
                                        ),
                                        _InsightChip(
                                          label: 'Trend',
                                          value: insights.trendLabel,
                                          icon: Icons.insights_rounded,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            child: _lastSavedAt == null
                                ? const SizedBox.shrink()
                                : Padding(
                                    key: ValueKey(_lastSavedAt),
                                    padding: const EdgeInsets.only(top: 14),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.14),
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: Colors.green.withOpacity(0.22),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.check_circle_outline,
                                            color: Color(0xFFB8F5C1),
                                            size: 18,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              '${_lastSaveMessage ?? 'Attendance saved'} at ${DateFormat.jm().format(_lastSavedAt!)}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 14),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _HeaderActionButton(
                                  icon: Icons.history_rounded,
                                  label: 'Recent History',
                                  onPressed: _showAttendanceHistory,
                                ),
                                const SizedBox(width: 10),
                                _HeaderActionButton(
                                  icon: Icons.menu_book_rounded,
                                  label: 'Open Lesson',
                                  onPressed: lesson == null
                                      ? null
                                      : () {
                                          context.pushNamed(
                                            'sundaySchoolLessonDetail',
                                            pathParameters: {
                                              'lessonId': lesson.id,
                                            },
                                          );
                                        },
                                ),
                                const SizedBox(width: 10),
                                _HeaderActionButton(
                                  icon: Icons.school_rounded,
                                  label: 'Teacher Guide',
                                  onPressed: guide == null
                                      ? null
                                      : () {
                                          context.pushNamed(
                                            PdfViewerScreen.routeName,
                                            queryParameters: {
                                              'path': guide.path,
                                              'title': guide.title,
                                              if (guide.initialPage != null)
                                                'page': guide.initialPage
                                                    .toString(),
                                            },
                                          );
                                        },
                                ),
                                const SizedBox(width: 10),
                                _HeaderActionButton(
                                  icon: Icons.done_all,
                                  label: 'Mark All Present',
                                  onPressed: () async {
                                    await _markAllStudents(
                                      students: widget.students,
                                      lessonId: lessonId,
                                      dateKey: dateKey,
                                      present: true,
                                    );
                                  },
                                ),
                                const SizedBox(width: 10),
                                _HeaderActionButton(
                                  icon: Icons.remove_done,
                                  label: 'Mark All Absent',
                                  onPressed: () async {
                                    await _markAllStudents(
                                      students: widget.students,
                                      lessonId: lessonId,
                                      dateKey: dateKey,
                                      present: false,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final student = widget.students[index - 1];
                final existing = attendanceByStudent[student.id];
                final isPresent = existing?.present ?? false;
                final wasMarked = existing != null;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Dismissible(
                    key: ValueKey(student.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 24),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) async {
                      await ref
                          .read(appDatabaseProvider)
                          .deleteStudent(student.id);
                      ref.read(_rosterRefreshProvider.notifier).state++;
                    },
                    child: PremiumGlassCard(
                      borderRadius: BorderRadius.circular(16),
                      child: SwitchListTile.adaptive(
                        value: isPresent,
                        onChanged: (value) async {
                          await _saveAttendanceForStudent(
                            student: student,
                            lessonId: lessonId,
                            dateKey: dateKey,
                            present: value,
                          );
                        },
                        title: Text(
                          student.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          valueLabel(isPresent, wasMarked: wasMarked),
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _saveAttendanceForStudent({
    required Student student,
    required String lessonId,
    required String dateKey,
    required bool present,
  }) async {
    final id = '$lessonId|$dateKey|${student.id}';
    await ref
        .read(appDatabaseProvider)
        .upsertAttendance(
          AttendanceRecord(
            id: id,
            studentId: student.id,
            lessonId: lessonId,
            dateKey: dateKey,
            present: present,
            updatedAt: DateTime.now(),
          ),
        );
    await ref
        .read(analyticsServiceProvider)
        .logTeacherAttendanceMarked(
          studentId: student.id,
          present: present,
          lessonId: lessonId,
          dateKey: dateKey,
        );
    ref.read(_rosterRefreshProvider.notifier).state++;
    _showSaveFeedback(
      '${student.name} marked ${present ? 'present' : 'absent'}',
    );
  }

  Future<void> _markAllStudents({
    required List<Student> students,
    required String lessonId,
    required String dateKey,
    required bool present,
  }) async {
    for (final student in students) {
      final id = '$lessonId|$dateKey|${student.id}';
      await ref
          .read(appDatabaseProvider)
          .upsertAttendance(
            AttendanceRecord(
              id: id,
              studentId: student.id,
              lessonId: lessonId,
              dateKey: dateKey,
              present: present,
              updatedAt: DateTime.now(),
            ),
          );
      await ref
          .read(analyticsServiceProvider)
          .logTeacherAttendanceMarked(
            studentId: student.id,
            present: present,
            lessonId: lessonId,
            dateKey: dateKey,
          );
    }
    ref.read(_rosterRefreshProvider.notifier).state++;
    _showSaveFeedback(
      'Saved ${students.length} attendance marks as ${present ? 'present' : 'absent'}',
    );
  }

  String valueLabel(bool present, {required bool wasMarked}) {
    if (!wasMarked) {
      return 'Not marked yet';
    }
    return present ? 'Present' : 'Absent';
  }

  Future<_AttendanceHistoryData> _loadAttendanceHistory() async {
    final summaries = await ref
        .read(appDatabaseProvider)
        .getAttendanceSessionHistory(track: widget.track);
    final lessons = await ref
        .read(lessonRepositoryProvider)
        .getLessonsForTrack(widget.track);
    return _AttendanceHistoryData(
      summaries: summaries,
      lessonsById: {for (final lesson in lessons) lesson.id: lesson},
    );
  }

  Future<_AttendanceInsightSummary> _loadAttendanceInsights() async {
    final summaries = await ref
        .read(appDatabaseProvider)
        .getAttendanceSessionHistory(track: widget.track, limit: 4);
    return _AttendanceInsightSummary.fromSummaries(
      summaries: summaries,
      rosterSize: widget.students.length,
    );
  }

  Future<void> _showAttendanceHistory() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: const Color(0xFF111315),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: FutureBuilder<_AttendanceHistoryData>(
              future: _loadAttendanceHistory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const SizedBox(
                    height: 260,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return SizedBox(
                    height: 260,
                    child: Center(
                      child: Text(
                        'Could not load attendance history.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }

                final history = snapshot.data!;
                if (history.summaries.isEmpty) {
                  return SizedBox(
                    height: 260,
                    child: Center(
                      child: Text(
                        'No attendance sessions have been saved for ${widget.track.label} yet.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  );
                }

                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.72,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.track.label} Attendance History',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Recent saved sessions with quick counts so teachers can verify what was marked.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.separated(
                          itemCount: history.summaries.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final summary = history.summaries[index];
                            final lesson =
                                history.lessonsById[summary.lessonId];
                            return PremiumGlassCard(
                              borderRadius: BorderRadius.circular(18),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(18),
                                onTap: () => _openHistorySession(summary),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _historyLessonTitle(
                                              lesson,
                                              summary.lessonId,
                                            ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.white54,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      DateFormat.yMMMMd().format(
                                        DateTime.parse(summary.dateKey),
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        _SummaryChip(
                                          label:
                                              'Present ${summary.presentCount}',
                                          icon: Icons.check_circle_outline,
                                        ),
                                        _SummaryChip(
                                          label:
                                              'Absent ${summary.absentCount}',
                                          icon: Icons.cancel_outlined,
                                        ),
                                        _SummaryChip(
                                          label:
                                              'Marked ${summary.markedCount}',
                                          icon: Icons.fact_check_outlined,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Open this saved session • Last updated ${DateFormat.jm().format(summary.updatedAt)}',
                                      style: const TextStyle(
                                        color: Colors.white60,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  String _historyLessonTitle(Lesson? lesson, String lessonId) {
    if (lesson == null) {
      return 'Saved Session';
    }

    final suffix = switch (lesson.track) {
      Track.primaryPals => lesson.id.toUpperCase(),
      _ when lesson.displayNumber != null => 'Lesson ${lesson.displayNumber}',
      _ => null,
    };

    if (suffix == null) {
      return lesson.title;
    }
    return '$suffix • ${lesson.title}';
  }

  void _openHistorySession(AttendanceSessionSummary summary) {
    final selectedDate = DateTime.parse(summary.dateKey);
    Navigator.of(context).pop();
    widget.onSessionDateSelected(selectedDate);
    _showSaveFeedback(
      'Opened saved session for ${DateFormat.yMMMMd().format(selectedDate)}',
    );
  }

  void _showSaveFeedback(String message) {
    final savedAt = DateTime.now();
    if (mounted) {
      setState(() {
        _lastSaveMessage = message;
        _lastSavedAt = savedAt;
      });
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(message),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(milliseconds: 1400),
          ),
        );
    }
  }
}

class _AttendanceHistoryData {
  const _AttendanceHistoryData({
    required this.summaries,
    required this.lessonsById,
  });

  final List<AttendanceSessionSummary> summaries;
  final Map<String, Lesson> lessonsById;
}

class _AttendanceInsightSummary {
  const _AttendanceInsightSummary({
    required this.caption,
    required this.recentAverageLabel,
    required this.bestTurnoutLabel,
    required this.trendLabel,
  });

  factory _AttendanceInsightSummary.fromSummaries({
    required List<AttendanceSessionSummary> summaries,
    required int rosterSize,
  }) {
    if (summaries.isEmpty || rosterSize == 0) {
      return const _AttendanceInsightSummary(
        caption: 'Save a few sessions to start seeing turnout patterns here.',
        recentAverageLabel: 'No data',
        bestTurnoutLabel: 'No data',
        trendLabel: 'No data',
      );
    }

    final averagePresent =
        summaries
            .map((summary) => summary.presentCount)
            .reduce((a, b) => a + b) /
        summaries.length;
    final bestPresent = summaries
        .map((summary) => summary.presentCount)
        .reduce((a, b) => a > b ? a : b);
    final mostRecent = summaries.first;
    final previous = summaries.length > 1 ? summaries[1] : null;
    final trendLabel = previous == null
        ? 'First saved session'
        : _trendLabel(mostRecent.presentCount - previous.presentCount);

    return _AttendanceInsightSummary(
      caption:
          'Based on the last ${summaries.length} saved ${summaries.length == 1 ? 'session' : 'sessions'} for ${DateFormat.MMMd().format(DateTime.parse(mostRecent.dateKey))}.',
      recentAverageLabel: '${averagePresent.toStringAsFixed(1)}/$rosterSize',
      bestTurnoutLabel: '$bestPresent/$rosterSize',
      trendLabel: trendLabel,
    );
  }

  final String caption;
  final String recentAverageLabel;
  final String bestTurnoutLabel;
  final String trendLabel;

  static String _trendLabel(int delta) {
    if (delta == 0) {
      return 'Flat vs last';
    }
    if (delta > 0) {
      return '+$delta vs last';
    }
    return '$delta vs last';
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightChip extends StatelessWidget {
  const _InsightChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.16),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 16),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  const _HeaderActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.white.withOpacity(0.12),
        disabledForegroundColor: Colors.white38,
        disabledBackgroundColor: Colors.white.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
