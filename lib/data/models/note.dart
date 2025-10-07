import 'package:meta/meta.dart';

import 'bible_ref.dart';

@immutable
class Note {
  const Note({
    required this.id,
    required this.userId,
    required this.ref,
    required this.text,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final BibleRef ref;
  final String text;
  final DateTime createdAt;

  Note copyWith({
    String? id,
    String? userId,
    BibleRef? ref,
    String? text,
    DateTime? createdAt,
  }) {
    return Note(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      ref: ref ?? this.ref,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'userId': userId,
        'ref': ref.toJson(),
        'text': text,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      userId: json['userId'] as String,
      ref: BibleRef.fromJson(json['ref'] as Map<String, dynamic>),
      text: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  int get hashCode => Object.hash(id, userId, ref, text, createdAt);

  @override
  bool operator ==(Object other) {
    return other is Note &&
        other.id == id &&
        other.userId == userId &&
        other.ref == ref &&
        other.text == text &&
        other.createdAt == createdAt;
  }
}
