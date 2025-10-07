import 'package:meta/meta.dart';

import 'bible_ref.dart';
import 'enums.dart';

@immutable
class MemoryVerse {
  const MemoryVerse({
    required this.id,
    required this.ref,
    required this.translation,
    this.dueDate,
    this.repetitions = 0,
    this.easiness = 2.5,
    this.intervalDays = 0,
  });

  final String id;
  final BibleRef ref;
  final Translation translation;
  final DateTime? dueDate;
  final int repetitions;
  final double easiness;
  final int intervalDays;

  MemoryVerse copyWith({
    String? id,
    BibleRef? ref,
    Translation? translation,
    DateTime? dueDate,
    int? repetitions,
    double? easiness,
    int? intervalDays,
  }) {
    return MemoryVerse(
      id: id ?? this.id,
      ref: ref ?? this.ref,
      translation: translation ?? this.translation,
      dueDate: dueDate ?? this.dueDate,
      repetitions: repetitions ?? this.repetitions,
      easiness: easiness ?? this.easiness,
      intervalDays: intervalDays ?? this.intervalDays,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'ref': ref.toJson(),
        'translation': translation.name,
        'dueDate': dueDate?.toIso8601String(),
        'repetitions': repetitions,
        'easiness': easiness,
        'intervalDays': intervalDays,
      };

  factory MemoryVerse.fromJson(Map<String, dynamic> json) {
    return MemoryVerse(
      id: json['id'] as String,
      ref: BibleRef.fromJson(json['ref'] as Map<String, dynamic>),
      translation: Translation.values.firstWhere((value) => value.name == json['translation']),
      dueDate: (json['dueDate'] as String?) == null ? null : DateTime.parse(json['dueDate'] as String),
      repetitions: json['repetitions'] as int? ?? 0,
      easiness: (json['easiness'] as num?)?.toDouble() ?? 2.5,
      intervalDays: json['intervalDays'] as int? ?? 0,
    );
  }

  @override
  int get hashCode => Object.hash(id, ref, translation, dueDate, repetitions, easiness, intervalDays);

  @override
  bool operator ==(Object other) {
    return other is MemoryVerse &&
        other.id == id &&
        other.ref == ref &&
        other.translation == translation &&
        other.dueDate == dueDate &&
        other.repetitions == repetitions &&
        other.easiness == easiness &&
        other.intervalDays == intervalDays;
  }
}
