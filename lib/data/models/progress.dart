import 'package:meta/meta.dart';

@immutable
class Progress {
  const Progress({
    required this.userId,
    required this.lessonId,
    required this.completedAt,
    this.score,
    this.streakCount,
  });

  final String userId;
  final String lessonId;
  final DateTime completedAt;
  final double? score;
  final int? streakCount;

  Progress copyWith({
    String? userId,
    String? lessonId,
    DateTime? completedAt,
    double? score,
    int? streakCount,
  }) {
    return Progress(
      userId: userId ?? this.userId,
      lessonId: lessonId ?? this.lessonId,
      completedAt: completedAt ?? this.completedAt,
      score: score ?? this.score,
      streakCount: streakCount ?? this.streakCount,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'userId': userId,
        'lessonId': lessonId,
        'completedAt': completedAt.toIso8601String(),
        'score': score,
        'streakCount': streakCount,
      };

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      userId: json['userId'] as String,
      lessonId: json['lessonId'] as String,
      completedAt: DateTime.parse(json['completedAt'] as String),
      score: (json['score'] as num?)?.toDouble(),
      streakCount: json['streakCount'] as int?,
    );
  }

  @override
  int get hashCode => Object.hash(userId, lessonId, completedAt, score, streakCount);

  @override
  bool operator ==(Object other) {
    return other is Progress &&
        other.userId == userId &&
        other.lessonId == lessonId &&
        other.completedAt == completedAt &&
        other.score == score &&
        other.streakCount == streakCount;
  }
}
