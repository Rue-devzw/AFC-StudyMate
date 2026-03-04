import 'dart:convert';
import 'dart:io';

import 'package:afc_studymate/data/models/attendance_record.dart';
import 'package:afc_studymate/data/models/bible_ref.dart';
import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/journal_entry.dart';
import 'package:afc_studymate/data/models/lesson.dart';
import 'package:afc_studymate/data/models/memory_verse.dart';
import 'package:afc_studymate/data/models/note.dart';
import 'package:afc_studymate/data/models/progress.dart';
import 'package:afc_studymate/data/models/student.dart';
import 'package:afc_studymate/data/models/teacher_guide.dart';
import 'package:afc_studymate/data/models/user_profile.dart';
import 'package:afc_studymate/utils/scripture_reference_parser.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

Map<String, TeacherGuide> mergeTeacherGuides(
  List<Map<String, dynamic>> entries,
) {
  final merged = <String, TeacherGuide>{};
  for (final rawGuide in entries) {
    final guide = TeacherGuide.fromJson(rawGuide);
    final existing = merged[guide.lessonId];
    if (existing == null) {
      merged[guide.lessonId] = guide;
      continue;
    }
    final normalizedExisting = existing.content.trim();
    final normalizedIncoming = guide.content.trim();
    if (normalizedIncoming.isEmpty ||
        normalizedExisting.contains(normalizedIncoming)) {
      continue;
    }
    merged[guide.lessonId] = existing.copyWith(
      content: '$normalizedExisting\n\n$normalizedIncoming',
      pdfPath: existing.pdfPath.isNotEmpty ? existing.pdfPath : guide.pdfPath,
    );
  }
  return merged;
}

class AppDatabase {
  AppDatabase();

  final Map<String, Lesson> _lessons = <String, Lesson>{};
  final List<Progress> _progress = <Progress>[];
  final Map<String, Note> _notes = <String, Note>{};
  final Map<String, JournalEntry> _journalEntries = <String, JournalEntry>{};
  final Map<String, String> _settings = <String, String>{};
  final Map<String, TeacherGuide> _teacherGuides = <String, TeacherGuide>{};
  final Map<String, Student> _students = <String, Student>{};
  final Map<String, AttendanceRecord> _attendance =
      <String, AttendanceRecord>{};
  UserProfile? _profile;
  final Map<String, MemoryVerse> _memoryVerses = <String, MemoryVerse>{};
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
        _applyUserData(data, clearExisting: true);
      } catch (e) {
        // Silently fail or log error
      }
    }
  }

  Future<void> _saveToDisk() async {
    if (_dataFile == null) await _ensureInitialized();
    final data = await exportUserData();
    await _dataFile!.writeAsString(jsonEncode(data));
  }

  Future<Map<String, dynamic>> exportUserData() async {
    await _ensureInitialized();
    return <String, dynamic>{
      'progress': _progress.map((e) => e.toJson()).toList(),
      'notes': _notes.map((k, v) => MapEntry(k, v.toJson())),
      'memoryVerses': _memoryVerses.map((k, v) => MapEntry(k, v.toJson())),
      'journalEntries': _journalEntries.map((k, v) => MapEntry(k, v.toJson())),
      'students': _students.map((k, v) => MapEntry(k, v.toJson())),
      'attendance': _attendance.map((k, v) => MapEntry(k, v.toJson())),
      'profile': _profile?.toJson(),
      'exportedAt': DateTime.now().toIso8601String(),
    };
  }

  Future<void> importUserDataSnapshot(
    Map<String, dynamic> data, {
    bool merge = false,
  }) async {
    await _ensureInitialized();
    _applyUserData(data, clearExisting: !merge);
    await _saveToDisk();
  }

  void _applyUserData(
    Map<String, dynamic> data, {
    required bool clearExisting,
  }) {
    if (clearExisting) {
      _progress.clear();
      _notes.clear();
      _memoryVerses.clear();
      _journalEntries.clear();
      _students.clear();
      _attendance.clear();
      _profile = null;
    }

    final progressList = data['progress'] as List<dynamic>? ?? <dynamic>[];
    _progress.addAll(
      progressList
          .whereType<Map<String, dynamic>>()
          .map(Progress.fromJson),
    );

    final notesMap = data['notes'] as Map<String, dynamic>? ?? <String, dynamic>{};
    _notes.addAll(
      notesMap.map(
        (k, v) => MapEntry(k, Note.fromJson(v as Map<String, dynamic>)),
      ),
    );

    final memoryVersesMap =
        data['memoryVerses'] as Map<String, dynamic>? ?? <String, dynamic>{};
    _memoryVerses.addAll(
      memoryVersesMap.map(
        (k, v) => MapEntry(k, MemoryVerse.fromJson(v as Map<String, dynamic>)),
      ),
    );

    final journalEntriesMap =
        data['journalEntries'] as Map<String, dynamic>? ?? <String, dynamic>{};
    _journalEntries.addAll(
      journalEntriesMap.map(
        (k, v) => MapEntry(k, JournalEntry.fromJson(v as Map<String, dynamic>)),
      ),
    );

    final studentsMap =
        data['students'] as Map<String, dynamic>? ?? <String, dynamic>{};
    _students.addAll(
      studentsMap.map(
        (k, v) => MapEntry(k, Student.fromJson(v as Map<String, dynamic>)),
      ),
    );

    final attendanceMap =
        data['attendance'] as Map<String, dynamic>? ?? <String, dynamic>{};
    _attendance.addAll(
      attendanceMap.map(
        (k, v) =>
            MapEntry(k, AttendanceRecord.fromJson(v as Map<String, dynamic>)),
      ),
    );

    if (data['profile'] case final Map<String, dynamic> profileData) {
      _profile = UserProfile.fromJson(profileData);
    }
  }

  Future<void> importLessonsFromAsset(
    String assetPath,
    Track track, {
    Future<String> Function(String assetPath)? textLoader,
  }) async {
    final raw = textLoader == null
        ? await rootBundle.loadString(assetPath)
        : await textLoader(assetPath);
    final dynamic decoded = jsonDecode(raw);
    final lessons = _parseLessonsForTrack(decoded, track);

    for (final lesson in lessons) {
      _lessons[lesson.id] = lesson;
    }
  }

  Future<void> importTeacherGuidesFromAsset(
    String assetPath, {
    Future<String> Function(String assetPath)? textLoader,
  }) async {
    final raw = textLoader == null
        ? await rootBundle.loadString(assetPath)
        : await textLoader(assetPath);
    final decoded = jsonDecode(raw);
    if (decoded is List) {
      final entries = decoded.whereType<Map<String, dynamic>>().toList();
      _teacherGuides.addAll(mergeTeacherGuides(entries));
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
        parentGuideRaw['family_devotions'] as Map<String, dynamic>? ??
        <String, dynamic>{};
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
      'keyVerse': ?keyVerse,
      'topic': raw['topic'] ?? raw['title'] ?? '',
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
    final bibleReferences = _parseBibleReferences(raw['bibleReference']);
    final payload = <String, dynamic>{
      'background': raw['background'] ?? '',
      'conclusion': raw['conclusion'] ?? '',
      'keyVerse': raw['keyVerse'] ?? '',
      'questions': raw['questions'] ?? <dynamic>[],
    };

    return Lesson(
      id: _coerceString(raw['id'], 'discovery_lesson_$index'),
      track: Track.discovery,
      title: _resolveDiscoveryTitle(
        raw['title'],
        bibleReferences,
        raw['questions'],
      ),
      bibleReferences: bibleReferences,
      payload: payload,
      weekIndex: (raw['weekIndex'] as int?) ?? index,
      dayIndex: raw['dayIndex'] as int?,
      displayNumber: _parseLessonNumber(raw['id']),
    );
  }

  String _resolveDiscoveryTitle(
    dynamic rawTitle,
    List<BibleRef> bibleReferences,
    dynamic rawQuestions,
  ) {
    final title = _coerceString(rawTitle, 'Discovery Lesson');
    if (title.trim().toUpperCase() != 'QUESTIONS') {
      return title;
    }
    if (bibleReferences.isNotEmpty) {
      return 'Study Questions: ${bibleReferences.first.displayText}';
    }
    final questions = rawQuestions as List<dynamic>? ?? <dynamic>[];
    if (questions.isNotEmpty) {
      final firstQuestion = questions.first.toString().replaceAll(
        RegExp(r'\s+'),
        ' ',
      );
      if (firstQuestion.isNotEmpty) {
        final snippet = firstQuestion.length > 64
            ? '${firstQuestion.substring(0, 64).trimRight()}...'
            : firstQuestion;
        return 'Study Questions: $snippet';
      }
    }
    return 'Study Questions';
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
            final rawVerse =
                reference['verses'] as String? ?? reference['verse'] as String?;
            final basicParsed = _parseReferenceFromString(rawVerse);
            if (basicParsed != null) {
              return basicParsed;
            }
            final parsed = ScriptureReferenceParser.parseReferenceList(
              rawVerse,
            );
            if (parsed.isNotEmpty) {
              return parsed.first;
            }
          }
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

  BibleRef? _parseReferenceFromString(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final match = RegExp(
      r'^\s*((?:[1-3]\s+)?[A-Za-z]+(?:\s+[A-Za-z]+)*)\s+(\d+)(?::(\d+)(?:[-–](\d+))?)?',
    ).firstMatch(value);
    if (match == null) {
      return null;
    }
    final book = match.group(1)?.trim();
    final chapter = int.tryParse(match.group(2) ?? '');
    final verseStart = int.tryParse(match.group(3) ?? '');
    final verseEnd = int.tryParse(match.group(4) ?? '');
    if (book == null || chapter == null) {
      return null;
    }
    return BibleRef(
      book: book,
      chapter: chapter,
      verseStart: verseStart,
      verseEnd: verseEnd,
    );
  }

  Future<void> seedFromAssets({
    Future<String> Function(String assetPath)? textLoader,
  }) {
    return _seedFuture ??= _performSeed(textLoader: textLoader);
  }

  Future<void> _performSeed({
    Future<String> Function(String assetPath)? textLoader,
  }) async {
    await _ensureInitialized();
    if (_lessons.isNotEmpty) {
      return;
    }
    await importLessonsFromAsset(
      'assets/data/beginners_lessons.json',
      Track.beginners,
      textLoader: textLoader,
    );
    await importLessonsFromAsset(
      'assets/data/primary_pals_lessons.json',
      Track.primaryPals,
      textLoader: textLoader,
    );
    await importLessonsFromAsset(
      'assets/data/the_answer_lessons.json',
      Track.answer,
      textLoader: textLoader,
    );
    await importLessonsFromAsset(
      'assets/data/search_lessons.json',
      Track.search,
      textLoader: textLoader,
    );
    await importLessonsFromAsset(
      'assets/data/discovery_lessons.json',
      Track.discovery,
      textLoader: textLoader,
    );
    await importLessonsFromAsset(
      'assets/data/daybreak_lessons.json',
      Track.daybreak,
      textLoader: textLoader,
    );

    await importTeacherGuidesFromAsset(
      'assets/data/primary_pals_teacher_guides.json',
      textLoader: textLoader,
    );
    await importTeacherGuidesFromAsset(
      'assets/data/answer_teacher_guides.json',
      textLoader: textLoader,
    );
    await importTeacherGuidesFromAsset(
      'assets/data/discovery_teacher_guides.json',
      textLoader: textLoader,
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

  Future<List<Note>> getAllNotes(String userId) async {
    await _ensureInitialized();
    final list = _notes.values.where((note) => note.userId == userId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Future<void> deleteNote(String noteId) async {
    await _ensureInitialized();
    _notes.remove(noteId);
    await _saveToDisk();
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

  Future<void> deleteJournalEntry(String entryId) async {
    await _ensureInitialized();
    _journalEntries.remove(entryId);
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

  Future<void> upsertStudent(Student student) async {
    await _ensureInitialized();
    _students[student.id] = student;
    await _saveToDisk();
  }

  Future<List<Student>> getStudents() async {
    await _ensureInitialized();
    final list = _students.values.toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return list;
  }

  Future<void> deleteStudent(String studentId) async {
    await _ensureInitialized();
    _students.remove(studentId);
    _attendance.removeWhere((_, value) => value.studentId == studentId);
    await _saveToDisk();
  }

  Future<void> upsertAttendance(AttendanceRecord record) async {
    await _ensureInitialized();
    _attendance[record.id] = record;
    await _saveToDisk();
  }

  Future<Map<String, AttendanceRecord>> getAttendanceForSession({
    required String lessonId,
    required String dateKey,
  }) async {
    await _ensureInitialized();
    final entries = _attendance.entries.where(
      (entry) =>
          entry.value.lessonId == lessonId && entry.value.dateKey == dateKey,
    );
    return Map<String, AttendanceRecord>.fromEntries(entries);
  }
}
