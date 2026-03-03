import 'package:afc_studymate/data/models/enums.dart';
import 'package:meta/meta.dart';

@immutable
class JournalEntry {
  const JournalEntry({
    required this.id,
    required this.userId,
    required this.relatedLessonId,
    required this.sourceTrack,
    required this.prompt,
    required this.response,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'] as String,
      userId: json['userId'] as String,
      relatedLessonId: json['relatedLessonId'] as String,
      sourceTrack: Track.values.firstWhere(
        (value) => value.name == json['sourceTrack'],
      ),
      prompt: json['prompt'] as String,
      response: json['response'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  final String id;
  final String userId;
  final String relatedLessonId;
  final Track sourceTrack;
  final String prompt;
  final String response;
  final DateTime createdAt;
  final DateTime updatedAt;

  JournalEntry copyWith({
    String? id,
    String? userId,
    String? relatedLessonId,
    Track? sourceTrack,
    String? prompt,
    String? response,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      relatedLessonId: relatedLessonId ?? this.relatedLessonId,
      sourceTrack: sourceTrack ?? this.sourceTrack,
      prompt: prompt ?? this.prompt,
      response: response ?? this.response,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'userId': userId,
    'relatedLessonId': relatedLessonId,
    'sourceTrack': sourceTrack.name,
    'prompt': prompt,
    'response': response,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    relatedLessonId,
    sourceTrack,
    prompt,
    response,
    createdAt,
    updatedAt,
  );

  @override
  bool operator ==(Object other) {
    return other is JournalEntry &&
        other.id == id &&
        other.userId == userId &&
        other.relatedLessonId == relatedLessonId &&
        other.sourceTrack == sourceTrack &&
        other.prompt == prompt &&
        other.response == response &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }
}
