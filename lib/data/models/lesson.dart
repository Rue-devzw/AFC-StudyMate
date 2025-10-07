import 'package:meta/meta.dart';

import 'bible_ref.dart';
import 'enums.dart';

@immutable
class Lesson {
  const Lesson({
    required this.id,
    required this.track,
    required this.title,
    required this.bibleReferences,
    required this.payload,
    this.weekIndex,
    this.dayIndex,
  });

  final String id;
  final Track track;
  final String title;
  final List<BibleRef> bibleReferences;
  final Map<String, dynamic> payload;
  final int? weekIndex;
  final int? dayIndex;

  Lesson copyWith({
    String? id,
    Track? track,
    String? title,
    List<BibleRef>? bibleReferences,
    Map<String, dynamic>? payload,
    int? weekIndex,
    int? dayIndex,
  }) {
    return Lesson(
      id: id ?? this.id,
      track: track ?? this.track,
      title: title ?? this.title,
      bibleReferences: bibleReferences ?? this.bibleReferences,
      payload: payload ?? this.payload,
      weekIndex: weekIndex ?? this.weekIndex,
      dayIndex: dayIndex ?? this.dayIndex,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'track': track.name,
        'title': title,
        'bibleReferences': bibleReferences.map((ref) => ref.toJson()).toList(),
        'payload': payload,
        'weekIndex': weekIndex,
        'dayIndex': dayIndex,
      };

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String,
      track: Track.values.firstWhere((value) => value.name == json['track']),
      title: json['title'] as String,
      bibleReferences: (json['bibleReferences'] as List<dynamic>)
          .map((dynamic item) => BibleRef.fromJson(item as Map<String, dynamic>))
          .toList(),
      payload: Map<String, dynamic>.from(json['payload'] as Map),
      weekIndex: json['weekIndex'] as int?,
      dayIndex: json['dayIndex'] as int?,
    );
  }

  @override
  int get hashCode =>
      Object.hash(id, track, title, Object.hashAll(bibleReferences), Object.hashAll(payload.entries), weekIndex, dayIndex);

  @override
  bool operator ==(Object other) {
    return other is Lesson &&
        other.id == id &&
        other.track == track &&
        other.title == title &&
        _listEquals(other.bibleReferences, bibleReferences) &&
        _mapEquals(other.payload, payload) &&
        other.weekIndex == weekIndex &&
        other.dayIndex == dayIndex;
  }
}

bool _listEquals<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

bool _mapEquals<K, V>(Map<K, V> a, Map<K, V> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (final entry in a.entries) {
    if (!b.containsKey(entry.key) || b[entry.key] != entry.value) {
      return false;
    }
  }
  return true;
}

@immutable
class BeginnersSection {
  const BeginnersSection({
    required this.sectionTitle,
    required this.sectionContent,
    required this.sectionType,
    this.imagePath,
  });

  final String sectionTitle;
  final String sectionContent;
  final String sectionType;
  final String? imagePath;

  BeginnersSection copyWith({
    String? sectionTitle,
    String? sectionContent,
    String? sectionType,
    String? imagePath,
  }) {
    return BeginnersSection(
      sectionTitle: sectionTitle ?? this.sectionTitle,
      sectionContent: sectionContent ?? this.sectionContent,
      sectionType: sectionType ?? this.sectionType,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'sectionTitle': sectionTitle,
        'sectionContent': sectionContent,
        'sectionType': sectionType,
        'imagePath': imagePath,
      };

  factory BeginnersSection.fromJson(Map<String, dynamic> json) {
    return BeginnersSection(
      sectionTitle: json['sectionTitle'] as String,
      sectionContent: json['sectionContent'] as String,
      sectionType: json['sectionType'] as String,
      imagePath: json['imagePath'] as String?,
    );
  }
}

@immutable
class BeginnersLessonPayload {
  const BeginnersLessonPayload({required this.sections});

  final List<BeginnersSection> sections;

  BeginnersLessonPayload copyWith({List<BeginnersSection>? sections}) {
    return BeginnersLessonPayload(sections: sections ?? this.sections);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'sections': sections.map((section) => section.toJson()).toList(),
      };

  factory BeginnersLessonPayload.fromJson(Map<String, dynamic> json) {
    return BeginnersLessonPayload(
      sections: (json['sections'] as List<dynamic>)
          .map((dynamic item) => BeginnersSection.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

@immutable
class PrimaryPalsActivity {
  const PrimaryPalsActivity({
    required this.type,
    required this.instructions,
    this.data,
  });

  final String type;
  final String instructions;
  final Map<String, dynamic>? data;

  PrimaryPalsActivity copyWith({
    String? type,
    String? instructions,
    Map<String, dynamic>? data,
  }) {
    return PrimaryPalsActivity(
      type: type ?? this.type,
      instructions: instructions ?? this.instructions,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'type': type,
        'instructions': instructions,
        'data': data,
      };

  factory PrimaryPalsActivity.fromJson(Map<String, dynamic> json) {
    return PrimaryPalsActivity(
      type: json['type'] as String,
      instructions: json['instructions'] as String,
      data: (json['data'] as Map?)?.cast<String, dynamic>(),
    );
  }
}

@immutable
class FamilyDevotion {
  const FamilyDevotion({
    required this.day,
    required this.prompt,
    required this.reading,
  });

  final String day;
  final String prompt;
  final BibleRef reading;

  FamilyDevotion copyWith({String? day, String? prompt, BibleRef? reading}) {
    return FamilyDevotion(
      day: day ?? this.day,
      prompt: prompt ?? this.prompt,
      reading: reading ?? this.reading,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'day': day,
        'prompt': prompt,
        'reading': reading.toJson(),
      };

  factory FamilyDevotion.fromJson(Map<String, dynamic> json) {
    return FamilyDevotion(
      day: json['day'] as String,
      prompt: json['prompt'] as String,
      reading: BibleRef.fromJson(json['reading'] as Map<String, dynamic>),
    );
  }
}

@immutable
class PrimaryPalsParentGuide {
  const PrimaryPalsParentGuide({
    required this.parentsCorner,
    required this.familyDevotions,
    required this.bibleText,
    required this.memoryVerse,
  });

  final String parentsCorner;
  final List<FamilyDevotion> familyDevotions;
  final BibleRef bibleText;
  final BibleRef memoryVerse;

  PrimaryPalsParentGuide copyWith({
    String? parentsCorner,
    List<FamilyDevotion>? familyDevotions,
    BibleRef? bibleText,
    BibleRef? memoryVerse,
  }) {
    return PrimaryPalsParentGuide(
      parentsCorner: parentsCorner ?? this.parentsCorner,
      familyDevotions: familyDevotions ?? this.familyDevotions,
      bibleText: bibleText ?? this.bibleText,
      memoryVerse: memoryVerse ?? this.memoryVerse,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'parentsCorner': parentsCorner,
        'familyDevotions': familyDevotions.map((devotion) => devotion.toJson()).toList(),
        'bibleText': bibleText.toJson(),
        'memoryVerse': memoryVerse.toJson(),
      };

  factory PrimaryPalsParentGuide.fromJson(Map<String, dynamic> json) {
    return PrimaryPalsParentGuide(
      parentsCorner: json['parentsCorner'] as String,
      familyDevotions: (json['familyDevotions'] as List<dynamic>)
          .map((dynamic item) => FamilyDevotion.fromJson(item as Map<String, dynamic>))
          .toList(),
      bibleText: BibleRef.fromJson(json['bibleText'] as Map<String, dynamic>),
      memoryVerse: BibleRef.fromJson(json['memoryVerse'] as Map<String, dynamic>),
    );
  }
}

@immutable
class PrimaryPalsLessonPayload {
  const PrimaryPalsLessonPayload({
    required this.story,
    required this.activities,
    required this.parentGuide,
  });

  final List<String> story;
  final List<PrimaryPalsActivity> activities;
  final PrimaryPalsParentGuide parentGuide;

  PrimaryPalsLessonPayload copyWith({
    List<String>? story,
    List<PrimaryPalsActivity>? activities,
    PrimaryPalsParentGuide? parentGuide,
  }) {
    return PrimaryPalsLessonPayload(
      story: story ?? this.story,
      activities: activities ?? this.activities,
      parentGuide: parentGuide ?? this.parentGuide,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'story': story,
        'activities': activities.map((activity) => activity.toJson()).toList(),
        'parentGuide': parentGuide.toJson(),
      };

  factory PrimaryPalsLessonPayload.fromJson(Map<String, dynamic> json) {
    return PrimaryPalsLessonPayload(
      story: (json['story'] as List<dynamic>).cast<String>(),
      activities: (json['activities'] as List<dynamic>)
          .map((dynamic item) => PrimaryPalsActivity.fromJson(item as Map<String, dynamic>))
          .toList(),
      parentGuide: PrimaryPalsParentGuide.fromJson(json['parentGuide'] as Map<String, dynamic>),
    );
  }
}

@immutable
class PromptQuestion {
  const PromptQuestion({
    required this.id,
    required this.prompt,
  });

  final String id;
  final String prompt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'prompt': prompt,
      };

  factory PromptQuestion.fromJson(Map<String, dynamic> json) {
    return PromptQuestion(
      id: json['id'] as String,
      prompt: json['prompt'] as String,
    );
  }
}

@immutable
class SearchLessonPayload {
  const SearchLessonPayload({
    required this.keyVerse,
    required this.supplementalScripture,
    required this.exposition,
    required this.questions,
    this.conclusion,
  });

  final String keyVerse;
  final List<BibleRef> supplementalScripture;
  final List<String> exposition;
  final List<PromptQuestion> questions;
  final String? conclusion;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'keyVerse': keyVerse,
        'supplementalScripture':
            supplementalScripture.map((reference) => reference.toJson()).toList(),
        'exposition': exposition,
        'questions': questions.map((question) => question.toJson()).toList(),
        'conclusion': conclusion,
      };

  factory SearchLessonPayload.fromJson(Map<String, dynamic> json) {
    return SearchLessonPayload(
      keyVerse: json['keyVerse'] as String,
      supplementalScripture: (json['supplementalScripture'] as List<dynamic>)
          .map((dynamic item) => BibleRef.fromJson(item as Map<String, dynamic>))
          .toList(),
      exposition: (json['exposition'] as List<dynamic>).cast<String>(),
      questions: (json['questions'] as List<dynamic>)
          .map((dynamic item) => PromptQuestion.fromJson(item as Map<String, dynamic>))
          .toList(),
      conclusion: json['conclusion'] as String?,
    );
  }
}
