import 'package:afc_studymate/data/drift/app_database.dart';
import 'package:afc_studymate/data/models/attendance_record.dart';
import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/student.dart';
import 'package:afc_studymate/data/repositories/lesson_repository.dart';
import 'package:afc_studymate/data/services/analytics_service.dart';
import 'package:afc_studymate/widgets/design_system_widgets.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final _rosterRefreshProvider = StateProvider<int>((ref) => 0);

final _studentsProvider = FutureProvider<List<Student>>((ref) async {
  ref.watch(_rosterRefreshProvider);
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

class _RosterList extends ConsumerWidget {
  const _RosterList({
    required this.students,
    required this.track,
    required this.date,
  });

  final List<Student> students;
  final Track track;
  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (students.isEmpty) {
      return const Center(
        child: Text(
          'No students yet. Add your class roster to start attendance.',
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.center,
        ),
      );
    }

    return FutureBuilder(
      future: ref.read(lessonRepositoryProvider).getCurrentSundayLesson(track),
      builder: (context, lessonSnapshot) {
        final lessonId =
            lessonSnapshot.data?.id ??
            '${track.name}_${DateFormat('yyyy_MM_dd').format(date)}';
        final dateKey = DateFormat('yyyy-MM-dd').format(date);

        return FutureBuilder<Map<String, AttendanceRecord>>(
          future: ref
              .read(appDatabaseProvider)
              .getAttendanceForSession(
                lessonId: lessonId,
                dateKey: dateKey,
              ),
          builder: (context, attendanceSnapshot) {
            final attendance = attendanceSnapshot.data ?? {};

            return ListView.builder(
              padding: EdgeInsets.fromLTRB(
                16,
                8,
                16,
                standardBottomContentPadding(context),
              ),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                final existing = attendance.values.where(
                  (record) => record.studentId == student.id,
                );
                final isPresent = existing.isNotEmpty && existing.first.present;

                return Dismissible(
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
                        final id = '$lessonId|$dateKey|${student.id}';
                        await ref
                            .read(appDatabaseProvider)
                            .upsertAttendance(
                              AttendanceRecord(
                                id: id,
                                studentId: student.id,
                                lessonId: lessonId,
                                dateKey: dateKey,
                                present: value,
                                updatedAt: DateTime.now(),
                              ),
                            );
                        await ref
                            .read(analyticsServiceProvider)
                            .logTeacherAttendanceMarked(
                              studentId: student.id,
                              present: value,
                              lessonId: lessonId,
                              dateKey: dateKey,
                            );
                        ref.read(_rosterRefreshProvider.notifier).state++;
                      },
                      title: Text(
                        student.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        valueLabel(isPresent),
                        style: const TextStyle(color: Colors.white70),
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

  String valueLabel(bool present) => present ? 'Present' : 'Absent';
}
