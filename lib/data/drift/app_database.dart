import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/bible_ref.dart';
import '../models/enums.dart';
import '../models/lesson.dart';
import '../models/memory_verse.dart';
import '../models/note.dart';
import '../models/progress.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

class AppDatabase {
  AppDatabase();

  final Map<String, Lesson> _lessons = <String, Lesson>{};
  final List<Progress> _progress = <Progress>[];
  final Map<String, Note> _notes = <String, Note>{};
  final Map<String, String> _settings = <String, String>{};
  final Map<String, MemoryVerse> _memoryVerses = <String, MemoryVerse>{};

  Future<void> importLessonsFromAsset(String assetPath, Track track) async {
    final raw = await rootBundle.loadString(assetPath);
    final dynamic decoded = jsonDecode(raw);
    final lessons = _parseLessonsForTrack(decoded, track);

    for (final lesson in lessons) {
      _lessons[lesson.id] = lesson;
    }
  }

  List<Lesson> _parseLessonsForTrack(dynamic decoded, Track track) {
    switch (track) {
      case Track.beginners:
        if (decoded is! List) {
          return <Lesson>[];
        }
        final entries = decoded.whereType<Map<String, dynamic>>();
        return entries.map(_mapBeginnersLesson).toList();
      case Track.primaryPals:
        if (decoded is! Map<String, dynamic>) {
          return <Lesson>[];
        }
        final entries = (decoded['primary_pals_lessons'] as List<dynamic>? ?? <dynamic>[])
            .whereType<Map<String, dynamic>>();
        return entries.map(_mapPrimaryPalsLesson).toList();
      case Track.search:
        if (decoded is! List) {
          return <Lesson>[];
        }
        final entries = decoded.whereType<Map<String, dynamic>>();
        return entries.map(_mapSearchLesson).toList();
    }
  }

  Lesson _mapBeginnersLesson(Map<String, dynamic> raw) {
    final sections = (raw['lessonSections'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map((section) => <String, dynamic>{
              'sectionTitle': section['sectionTitle'] ?? 'Story moment',
              'sectionContent': section['sectionContent'] ?? '',
              'sectionType': section['sectionType'] ?? 'text',
              'imagePath': section['imagePath'],
            })
        .toList();

    final payload = <String, dynamic>{
      'sections': sections,
      'ageCategory': raw['ageCategory'],
    };

    return Lesson(
      id: _coerceString(raw['id'] ?? raw['lesson_id'], 'beginners_lesson'),
      track: Track.beginners,
      title: _coerceString(raw['title'] ?? raw['lessonTitle'], 'Lesson'),
      bibleReferences: _parseBibleReferences(raw['bibleReference']),
      payload: payload,
      weekIndex: raw['weekIndex'] as int?,
      dayIndex: raw['dayIndex'] as int?,
    );
  }

  Lesson _mapPrimaryPalsLesson(Map<String, dynamic> raw) {
    final activities = (raw['activities'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map((activity) => <String, dynamic>{
              'type': activity['type'] ?? 'Activity',
              'title': activity['title'],
              'instructions': activity['instructions'] ?? '',
              'data': activity,
            })
        .toList();

    final parentGuideRaw = raw['parent_guide'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final parentCorner = (parentGuideRaw['parents_corner'] as Map<String, dynamic>? ?? <String, dynamic>{})['text'];
    final familyDevotions = (parentGuideRaw['family_devotions'] as Map<String, dynamic>? ?? <String, dynamic>{});
    final devotions = (familyDevotions['verses'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map((devotion) => <String, dynamic>{
              'day': devotion['day'] ?? '',
              'prompt': devotion['reference'] ?? '',
            })
        .toList();

    final payload = <String, dynamic>{
      'story': (raw['story'] as List<dynamic>? ?? <dynamic>[]).cast<String>(),
      'activities': activities,
      'parentGuide': <String, dynamic>{
        'parentsCorner': parentCorner ?? '',
        'familyDevotions': devotions,
      },
    };

    return Lesson(
      id: _coerceString(raw['id'] ?? raw['lesson_id'], 'primary_pals_lesson'),
      track: Track.primaryPals,
      title: _coerceString(raw['title'], 'Lesson'),
      bibleReferences: _parseBibleReferences(raw['bibleReference']),
      payload: payload,
      weekIndex: raw['weekIndex'] as int?,
      dayIndex: raw['dayIndex'] as int?,
    );
  }

  Lesson _mapSearchLesson(Map<String, dynamic> raw) {
    final sections = (raw['lessonSections'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>();

    final exposition = <String>[];
    final questions = <Map<String, dynamic>>[];

    for (final section in sections) {
      final type = (section['sectionType'] as String? ?? 'text').toLowerCase();
      final content = section['sectionContent'] as String? ?? '';
      if (type == 'question') {
        final number = section['questionNumber'];
        final id = number != null ? 'q$number' : 'q${questions.length + 1}';
        questions.add(<String, dynamic>{
          'id': id,
          'prompt': content,
        });
      } else if (content.isNotEmpty) {
        exposition.add(content);
      }
    }

    final payload = <String, dynamic>{
      'keyVerse': raw['keyVerse'] ?? '',
      'supplementalScripture': raw['supplementalScripture'],
      'exposition': exposition,
      'questions': questions,
      'resourceMaterial': raw['resourceMaterial'],
    };

    return Lesson(
      id: _coerceString(raw['id'] ?? raw['lesson_id'], 'search_lesson'),
      track: Track.search,
      title: _coerceString(raw['title'] ?? raw['lessonTitle'], 'Lesson'),
      bibleReferences: _parseBibleReferences(raw['bibleReference']),
      payload: payload,
      weekIndex: raw['weekIndex'] as int?,
      dayIndex: raw['dayIndex'] as int?,
    );
  }

  List<BibleRef> _parseBibleReferences(dynamic value) {
    if (value is! List) {
      return <BibleRef>[];
    }

    return value
        .whereType<Map<String, dynamic>>()
        .map((reference) {
          final book = reference['book'] as String?;
          final chapter = _tryParseInt(reference['chapter']);
          if (book == null || chapter == null) {
            return null;
          }

          final verses = reference['verses'] as String? ?? reference['verse'] as String?;
          final range = _parseVerseRange(verses);

          return BibleRef(
            book: book,
            chapter: chapter,
            verseStart: range.$1,
            verseEnd: range.$2,
          );
        })
        .whereType<BibleRef>()
        .toList();
  }

  (int?, int?) _parseVerseRange(String? value) {
    if (value == null) {
      return (null, null);
    }

    final matches = RegExp(r'\d+').allMatches(value).map((match) => int.parse(match.group(0)!)).toList();
    if (matches.isEmpty) {
      return (null, null);
    }

    final start = matches.first;
    final end = matches.length > 1 ? matches.last : null;
    return (start, end);
  }

  int? _tryParseInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  String _coerceString(dynamic value, String fallback) {
    if (value is String && value.isNotEmpty) {
      return value;
    }
    return fallback;
  }

  Future<void> seedFromAssets() async {
    final prefs = await SharedPreferences.getInstance();
    final seeded = prefs.getBool('seeded_v1') ?? false;
    if (seeded) {
      return;
    }
    await importLessonsFromAsset('assets/data/beginners_lessons.json', Track.beginners);
    await importLessonsFromAsset('assets/data/primary_pals_lessons.json', Track.primaryPals);
    await importLessonsFromAsset('assets/data/search_lessons.json', Track.search);
    await prefs.setBool('seeded_v1', true);
  }

  Future<List<Lesson>> getLessonsByTrack(Track track) async {
    return _lessons.values.where((lesson) => lesson.track == track).toList()
      ..sort((a, b) => (a.weekIndex ?? 0).compareTo(b.weekIndex ?? 0));
  }

  Future<Lesson?> getLesson(String id) async => _lessons[id];

  Future<void> upsertProgress(Progress progress) async {
    _progress.removeWhere((item) => item.lessonId == progress.lessonId && item.userId == progress.userId);
    _progress.add(progress);
  }

  Future<List<Progress>> getProgressForUser(String userId) async {
    return _progress.where((item) => item.userId == userId).toList();
  }

  Future<void> upsertNote(Note note) async {
    _notes[note.id] = note;
  }

  Future<List<Note>> getNotes(String userId, BibleRef ref) async {
    return _notes.values
        .where((note) => note.userId == userId && note.ref.book == ref.book && note.ref.chapter == ref.chapter)
        .toList();
  }

  Future<void> upsertSetting(String key, String value) async {
    _settings[key] = value;
  }

  Future<String?> getSetting(String key) async => _settings[key];

  Future<void> upsertMemoryVerse(MemoryVerse verse) async {
    _memoryVerses[verse.id] = verse;
  }

  Future<List<MemoryVerse>> getMemoryVerses() async => _memoryVerses.values.toList();
}
