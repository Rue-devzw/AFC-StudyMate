import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/bible/reading_progress/entities.dart';
import '../../domain/bible/reading_progress/repositories.dart';

class ReadingProgressRepositoryImpl implements ReadingProgressRepository {
  ReadingProgressRepositoryImpl();

  static const _storageKey = 'reading_progress_state';
  final _controller = StreamController<ReadingPosition?>.broadcast();
  bool _initialised = false;

  Future<void> _ensureInitialised() async {
    if (_initialised) {
      return;
    }
    final position = await getLastPosition();
    _controller.add(position);
    _initialised = true;
  }

  @override
  Stream<ReadingPosition?> watch() async* {
    await _ensureInitialised();
    yield* _controller.stream;
  }

  @override
  Future<ReadingPosition?> getLastPosition() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_storageKey);
    if (stored == null) {
      return null;
    }
    try {
      final decoded = jsonDecode(stored) as Map<String, dynamic>;
      return ReadingPosition(
        translationId: decoded['translationId'] as String,
        bookId: decoded['bookId'] as int,
        chapter: decoded['chapter'] as int,
        verse: decoded['verse'] as int,
        updatedAt: DateTime.fromMillisecondsSinceEpoch(decoded['updatedAt'] as int),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> savePosition(ReadingPosition position) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = jsonEncode({
      'translationId': position.translationId,
      'bookId': position.bookId,
      'chapter': position.chapter,
      'verse': position.verse,
      'updatedAt': position.updatedAt.millisecondsSinceEpoch,
    });
    await prefs.setString(_storageKey, payload);
    await _ensureInitialised();
    _controller.add(position);
  }

  void dispose() {
    _controller.close();
  }
}
