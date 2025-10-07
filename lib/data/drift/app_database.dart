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
    final json = jsonDecode(raw) as List<dynamic>;
    for (final entry in json) {
      final map = entry as Map<String, dynamic>;
      final references = (map['bibleReferences'] as List<dynamic>? ?? <dynamic>[])
          .map((dynamic item) => BibleRef.fromJson(item as Map<String, dynamic>))
          .toList();
      final lesson = Lesson(
        id: map['id'] as String,
        track: track,
        title: map['title'] as String,
        bibleReferences: references,
        payload: Map<String, dynamic>.from(map['payload'] as Map? ?? <String, dynamic>{}),
        weekIndex: map['weekIndex'] as int?,
        dayIndex: map['dayIndex'] as int?,
      );
      _lessons[lesson.id] = lesson;
    }
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
