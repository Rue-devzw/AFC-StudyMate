import 'package:meta/meta.dart';

@immutable
class AttendanceSessionSummary {
  const AttendanceSessionSummary({
    required this.lessonId,
    required this.dateKey,
    required this.presentCount,
    required this.absentCount,
    required this.markedCount,
    required this.updatedAt,
  });

  final String lessonId;
  final String dateKey;
  final int presentCount;
  final int absentCount;
  final int markedCount;
  final DateTime updatedAt;
}
