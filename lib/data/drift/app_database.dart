import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/bible_ref.dart';
import '../models/enums.dart';
import '../models/lesson.dart';
import '../models/memory_verse.dart';
import '../models/note.dart';
import '../models/progress.dart';
import '../models/journal_entry.dart';
import '../models/user_profile.dart';
import '../models/teacher_guide.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

class AppDatabase {
  AppDatabase();

  final Map<String, Lesson> _lessons = <String, Lesson>{};
  final List<Progress> _progress = <Progress>[];
  final Map<String, Note> _notes = <String, Note>{};
  final Map<String, JournalEntry> _journalEntries = <String, JournalEntry>{};
  final Map<String, String> _settings = <String, String>{};
  final Map<String, TeacherGuide> _teacherGuides = <String, TeacherGuide>{};
  UserProfile? _profile;
  Map<String, MemoryVerse> _memoryVerses = <String, MemoryVerse>{};
  Future<void>? _seedFuture;
  late SharedPreferences _prefs;
  File? _dataFile;

  Future<void> _ensureInitialized() async {
    if (_dataFile != null) return;
    final directory = await getApplicationDocumentsDirectory();
    _dataFile = File('${directory.path}/user_data.json');
    _prefs = await SharedPreferences.getInstance();

    if (await _dataFile!.exists()) {
      try {
        final content = await _dataFile!.readAsString();
        final data = jsonDecode(content) as Map<String, dynamic>;

        final progressList = data['progress'] as List<dynamic>? ?? [];
        _progress.clear();
        _progress.addAll(
          progressList.map((e) => Progress.fromJson(e as Map<String, dynamic>)),
        );

        final notesMap = data['notes'] as Map<String, dynamic>? ?? {};
        _notes.clear();
        _notes.addAll(
          notesMap.map(
            (k, v) => MapEntry(k, Note.fromJson(v as Map<String, dynamic>)),
          ),
        );

        final memoryVersesMap =
            data['memoryVerses'] as Map<String, dynamic>? ?? {};
        _memoryVerses.clear();
        _memoryVerses.addAll(
          memoryVersesMap.map(
            (k, v) =>
                MapEntry(k, MemoryVerse.fromJson(v as Map<String, dynamic>)),
          ),
        );

        final journalEntriesMap =
            data['journalEntries'] as Map<String, dynamic>? ?? {};
        _journalEntries.clear();
        _journalEntries.addAll(
          journalEntriesMap.map(
            (k, v) =>
                MapEntry(k, JournalEntry.fromJson(v as Map<String, dynamic>)),
          ),
        );

        if (data['profile'] != null) {
          _profile = UserProfile.fromJson(
            data['profile'] as Map<String, dynamic>,
          );
        }
      } catch (e) {
        // Silently fail or log error
      }
    }
  }

  Future<void> _saveToDisk() async {
    if (_dataFile == null) await _ensureInitialized();
    final data = {
      'progress': _progress.map((e) => e.toJson()).toList(),
      'notes': _notes.map((k, v) => MapEntry(k, v.toJson())),
      'memoryVerses': _memoryVerses.map((k, v) => MapEntry(k, v.toJson())),
      'journalEntries': _journalEntries.map((k, v) => MapEntry(k, v.toJson())),
      'profile': _profile?.toJson(),
    };
    await _dataFile!.writeAsString(jsonEncode(data));
  }

  Future<void> importLessonsFromAsset(String assetPath, Track track) async {
    final raw = await rootBundle.loadString(assetPath);
    final dynamic decoded = jsonDecode(raw);
    final lessons = _parseLessonsForTrack(decoded, track);

    for (final lesson in lessons) {
      _lessons[lesson.id] = lesson;
    }
  }

  Future<void> importTeacherGuidesFromAsset(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(raw);
    if (decoded is List) {
      final entries = decoded.whereType<Map<String, dynamic>>().toList();
      for (final rawGuide in entries) {
        final guide = TeacherGuide.fromJson(rawGuide);
        _teacherGuides[guide.lessonId] = guide;
      }
    }
  }

  Future<TeacherGuide?> getTeacherGuide(String lessonId) async {
    await _ensureInitialized();
    if (_seedFuture != null) await _seedFuture;

    // Search track shares Answer track's guides
    // Answer lessons have id 'answer_lesson_X', Search lessons have 'search_lesson_X'
    // But the payload id for Answer is actually `answer_1` or `answer_lesson_1`?
    // Let's resolve the underlying ID. Our generated JSON has `primary_pals_1`, `answer_1`.

    // First, check direct hit
    if (_teacherGuides.containsKey(lessonId)) {
      return _teacherGuides[lessonId];
    }

    // Try regex matching to adapt 'primary_pals_lesson_1' to 'primary_pals_1'
    final match = RegExp(
      r'(primary_pals|answer|discovery|search)_.*?(\d+)',
    ).firstMatch(lessonId);
    if (match != null) {
      var trackPrefix = match.group(1);
      final numStr = match.group(2);
      if (trackPrefix == 'search') {
        trackPrefix = 'answer';
      }
      final mappedId = '${trackPrefix}_$numStr';
      return _teacherGuides[mappedId];
    }

    return null;
  }

  List<Lesson> _parseLessonsForTrack(dynamic decoded, Track track) {
    switch (track) {
      case Track.beginners:
        if (decoded is! List) {
          return <Lesson>[];
        }
        final entries = decoded.whereType<Map<String, dynamic>>().toList();
        return <Lesson>[
          for (var index = 0; index < entries.length; index++)
            _mapBeginnersLesson(entries[index], index),
        ];
      case Track.primaryPals:
        if (decoded is! Map<String, dynamic>) {
          return <Lesson>[];
        }
        final entries =
            (decoded['primary_pals_lessons'] as List<dynamic>? ?? <dynamic>[])
                .whereType<Map<String, dynamic>>()
                .toList();
        return <Lesson>[
          for (var index = 0; index < entries.length; index++)
            _mapPrimaryPalsLesson(entries[index], index),
        ];
      case Track.answer:
        if (decoded is! List) {
          return <Lesson>[];
        }
        final entries = decoded.whereType<Map<String, dynamic>>().toList();
        return <Lesson>[
          for (var index = 0; index < entries.length; index++)
            _mapAnswerLesson(entries[index], index),
        ];
      case Track.search:
        if (decoded is! List) {
          return <Lesson>[];
        }
        final entries = decoded.whereType<Map<String, dynamic>>().toList();
        return <Lesson>[
          for (var index = 0; index < entries.length; index++)
            _mapSearchLesson(entries[index], index),
        ];
      case Track.discovery:
        if (decoded is! List) {
          return <Lesson>[];
        }
        final entries = decoded.whereType<Map<String, dynamic>>().toList();
        return <Lesson>[
          for (var index = 0; index < entries.length; index++)
            _mapDiscoveryLesson(entries[index], index),
        ];
      case Track.daybreak:
        if (decoded is! List) {
          return <Lesson>[];
        }
        final entries = decoded.whereType<Map<String, dynamic>>().toList();
        return <Lesson>[
          for (var index = 0; index < entries.length; index++)
            _mapDaybreakLesson(entries[index], index),
        ];
    }
  }

  Lesson _mapBeginnersLesson(Map<String, dynamic> raw, int index) {
    final sections = (raw['lessonSections'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(
          (section) => <String, dynamic>{
            'sectionTitle': section['sectionTitle'] ?? 'Story moment',
            'sectionContent': section['sectionContent'] ?? '',
            'sectionType': section['sectionType'] ?? 'text',
            'imagePath': section['imagePath'],
          },
        )
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
      weekIndex: (raw['weekIndex'] as int?) ?? index,
      dayIndex: raw['dayIndex'] as int?,
      displayNumber: _parseLessonNumber(raw['id'] ?? raw['lesson_id']),
    );
  }

  Lesson _mapPrimaryPalsLesson(Map<String, dynamic> raw, int index) {
    final activities = (raw['activities'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(
          (activity) => <String, dynamic>{
            'type': activity['type'] ?? 'Activity',
            'title': activity['title'],
            'instructions': activity['instructions'] ?? '',
            'data': activity,
          },
        )
        .toList();

    final parentGuideRaw =
        raw['parent_guide'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final parentCorner =
        (parentGuideRaw['parents_corner'] as Map<String, dynamic>? ??
        <String, dynamic>{})['text'];
    final familyDevotions =
        (parentGuideRaw['family_devotions'] as Map<String, dynamic>? ??
        <String, dynamic>{});
    final devotions =
        (familyDevotions['verses'] as List<dynamic>? ?? <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .map(
              (devotion) => <String, dynamic>{
                'day': devotion['day'] ?? '',
                'prompt': devotion['reference'] ?? '',
              },
            )
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
      weekIndex: (raw['weekIndex'] as int?) ?? index,
      dayIndex: raw['dayIndex'] as int?,
      displayNumber: _parseLessonNumber(raw['id'] ?? raw['lesson_id']),
    );
  }

  Lesson _mapAnswerLesson(Map<String, dynamic> raw, int index) {
    final activities = (raw['activities'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(
          (activity) => <String, dynamic>{
            'type': activity['type'] ?? 'Activity',
            'title': activity['title'],
            'instructions': activity['instructions'] ?? '',
            'data': activity,
          },
        )
        .toList();

    final keyVerseRaw = raw['key_verse'];
    Map<String, dynamic>? keyVerse;
    if (keyVerseRaw is Map<String, dynamic>) {
      keyVerse = keyVerseRaw;
    } else if (keyVerseRaw is String) {
      keyVerse = {'title': 'KEY VERSE', 'text': keyVerseRaw};
    }

    final payload = <String, dynamic>{
      'story': (raw['story'] as List<dynamic>? ?? <dynamic>[]).cast<String>(),
      if (keyVerse != null) 'keyVerse': keyVerse,
      'activities': activities,
    };

    return Lesson(
      id: _coerceString(raw['id'] ?? raw['lesson_id'], 'answer_lesson_$index'),
      track: Track.answer,
      title: _coerceString(raw['title'], 'The Answer Lesson'),
      bibleReferences: _parseBibleReferences(
        [
          {'verses': raw['bible_text']},
        ],
      ), // Temporary parse logic for direct string if needed, or structured later
      payload: payload,
      weekIndex: (raw['weekIndex'] as int?) ?? index,
      dayIndex: raw['dayIndex'] as int?,
      displayNumber: _parseLessonNumber(raw['id'] ?? raw['lesson_id']),
    );
  }

  Lesson _mapSearchLesson(Map<String, dynamic> raw, int index) {
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
      weekIndex: (raw['weekIndex'] as int?) ?? index,
      dayIndex: raw['dayIndex'] as int?,
      displayNumber: _parseLessonNumber(raw['id'] ?? raw['lesson_id']),
    );
  }

  Lesson _mapDiscoveryLesson(Map<String, dynamic> raw, int index) {
    final payload = <String, dynamic>{
      'background': raw['background'] ?? '',
      'conclusion': raw['conclusion'] ?? '',
      'keyVerse': raw['keyVerse'] ?? '',
      'questions': raw['questions'] ?? <dynamic>[],
    };

    return Lesson(
      id: _coerceString(raw['id'], 'discovery_lesson_$index'),
      track: Track.discovery,
      title: _coerceString(raw['title'], 'Discovery Lesson'),
      bibleReferences: _parseBibleReferences(raw['bibleReference']),
      payload: payload,
      weekIndex: (raw['weekIndex'] as int?) ?? index,
      dayIndex: raw['dayIndex'] as int?,
      displayNumber: _parseLessonNumber(raw['id']),
    );
  }

  Lesson _mapDaybreakLesson(Map<String, dynamic> raw, int index) {
    final payload = <String, dynamic>{
      'devotion': raw['devotion'] ?? '',
      'background': raw['background'] ?? '',
      'amplifiedOutline': raw['amplifiedOutline'] ?? '',
      'aCloserLook': raw['aCloserLook'] ?? <dynamic>[],
      'conclusion': raw['conclusion'] ?? '',
    };

    return Lesson(
      id: _coerceString(raw['id'], 'daybreak_lesson_$index'),
      track: Track.daybreak,
      title: _coerceString(raw['title'], 'Daybreak Devotion'),
      bibleReferences: _parseBibleReferences(raw['bibleReference']),
      payload: payload,
      weekIndex: raw['weekIndex'] as int?,
      dayIndex: (raw['dayIndex'] as int?) ?? index,
      displayNumber: _parseLessonNumber(raw['id']),
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

          final verses =
              reference['verses'] as String? ?? reference['verse'] as String?;
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

    final matches = RegExp(
      r'\d+',
    ).allMatches(value).map((match) => int.parse(match.group(0)!)).toList();
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

  int? _parseLessonNumber(dynamic id) {
    if (id is! String) return null;
    final match = RegExp(r'(\d+)').firstMatch(id);
    if (match != null) {
      return int.tryParse(match.group(1)!);
    }
    return null;
  }

  Future<void> seedFromAssets() {
    return _seedFuture ??= _performSeed();
  }

  Future<void> _performSeed() async {
    await _ensureInitialized();
    if (_lessons.isNotEmpty) {
      return;
    }
    await importLessonsFromAsset(
      'assets/data/beginners_lessons.json',
      Track.beginners,
    );
    await importLessonsFromAsset(
      'assets/data/primary_pals_lessons.json',
      Track.primaryPals,
    );
    await importLessonsFromAsset(
      'assets/data/the_answer_lessons.json',
      Track.answer,
    );
    await importLessonsFromAsset(
      'assets/data/search_lessons.json',
      Track.search,
    );
    await importLessonsFromAsset(
      'assets/data/discovery_lessons.json',
      Track.discovery,
    );
    await importLessonsFromAsset(
      'assets/data/daybreak_lessons.json',
      Track.daybreak,
    );

    await importTeacherGuidesFromAsset(
      'assets/data/primary_pals_teacher_guides.json',
    );
    await importTeacherGuidesFromAsset(
      'assets/data/answer_teacher_guides.json',
    );
    await importTeacherGuidesFromAsset(
      'assets/data/discovery_teacher_guides.json',
    );
  }

  Future<List<Lesson>> getLessonsByTrack(Track track) async {
    return _lessons.values.where((lesson) => lesson.track == track).toList()
      ..sort((a, b) => (a.weekIndex ?? 0).compareTo(b.weekIndex ?? 0));
  }

  Future<Lesson?> getLesson(String id) async => _lessons[id];

  Future<void> upsertProgress(Progress progress) async {
    await _ensureInitialized();
    _progress.removeWhere(
      (item) =>
          item.lessonId == progress.lessonId && item.userId == progress.userId,
    );
    _progress.add(progress);
    await _saveToDisk();
  }

  Future<List<Progress>> getProgressForUser(String userId) async {
    await _ensureInitialized();
    return _progress.where((item) => item.userId == userId).toList();
  }

  Future<void> upsertNote(Note note) async {
    await _ensureInitialized();
    _notes[note.id] = note;
    await _saveToDisk();
  }

  Future<List<Note>> getNotes(String userId, BibleRef ref) async {
    await _ensureInitialized();
    return _notes.values
        .where(
          (note) =>
              note.userId == userId &&
              note.ref.book == ref.book &&
              note.ref.chapter == ref.chapter,
        )
        .toList();
  }

  Future<void> upsertSetting(String key, String value) async {
    await _ensureInitialized();
    await _prefs.setString(key, value);
    _settings[key] = value;
  }

  Future<String?> getSetting(String key) async {
    await _ensureInitialized();
    return _prefs.getString(key) ?? _settings[key];
  }

  Future<void> upsertMemoryVerse(MemoryVerse verse) async {
    await _ensureInitialized();
    _memoryVerses[verse.id] = verse;
    await _saveToDisk();
  }

  Future<List<MemoryVerse>> getMemoryVerses() async {
    await _ensureInitialized();
    return _memoryVerses.values.toList();
  }

  Future<void> upsertJournalEntry(JournalEntry entry) async {
    await _ensureInitialized();
    _journalEntries[entry.id] = entry;
    await _saveToDisk();
  }

  Future<List<JournalEntry>> getJournalEntries(
    String userId, {
    Track? track,
  }) async {
    await _ensureInitialized();
    var entries = _journalEntries.values.where((e) => e.userId == userId);
    if (track != null) {
      entries = entries.where((e) => e.sourceTrack == track);
    }
    final sorted = entries.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }

  Future<void> upsertProfile(UserProfile profile) async {
    await _ensureInitialized();
    _profile = profile;
    await _saveToDisk();
  }

  Future<UserProfile?> getProfile(String userId) async {
    await _ensureInitialized();
    return _profile;
  }
}
