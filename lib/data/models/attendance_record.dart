import 'package:meta/meta.dart';

@immutable
class AttendanceRecord {
  const AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.lessonId,
    required this.dateKey,
    required this.present,
    required this.updatedAt,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      lessonId: json['lessonId'] as String,
      dateKey: json['dateKey'] as String,
      present: json['present'] as bool? ?? false,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  final String id;
  final String studentId;
  final String lessonId;
  final String dateKey;
  final bool present;
  final DateTime updatedAt;

  AttendanceRecord copyWith({
    String? id,
    String? studentId,
    String? lessonId,
    String? dateKey,
    bool? present,
    DateTime? updatedAt,
  }) {
    return AttendanceRecord(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      lessonId: lessonId ?? this.lessonId,
      dateKey: dateKey ?? this.dateKey,
      present: present ?? this.present,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'studentId': studentId,
        'lessonId': lessonId,
        'dateKey': dateKey,
        'present': present,
        'updatedAt': updatedAt.toIso8601String(),
      };
}
