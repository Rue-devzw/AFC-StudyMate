import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/bible/reading_progress/entities.dart';
import '../../domain/bible/reading_progress/repositories.dart';

class ReadingProgressRepositoryImpl implements ReadingProgressRepository {
  ReadingProgressRepositoryImpl();

  static const _storageKey = 'reading_progress_state';
  final _controllers = <String, StreamController<ReadingPosition?>>{};
  final _initialisedUsers = <String>{};

  StreamController<ReadingPosition?> _controllerFor(String userId) {
    return _controllers.putIfAbsent(
      userId,
      () => StreamController<ReadingPosition?>.broadcast(),
    );
  }

  String _keyFor(String userId) => '${_storageKey}_$userId';

  Future<void> _ensureInitialised(String userId) async {
    if (_initialisedUsers.contains(userId)) {
      return;
    }
    final position = await getLastPosition(userId);
    _controllerFor(userId).add(position);
    _initialisedUsers.add(userId);
  }

  @override
  Stream<ReadingPosition?> watch(String userId) async* {
    await _ensureInitialised(userId);
    yield* _controllerFor(userId).stream;
  }

  @override
  Future<ReadingPosition?> getLastPosition(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_keyFor(userId));
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
  Future<void> savePosition(String userId, ReadingPosition position) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = jsonEncode({
      'translationId': position.translationId,
      'bookId': position.bookId,
      'chapter': position.chapter,
      'verse': position.verse,
      'updatedAt': position.updatedAt.millisecondsSinceEpoch,
    });
    await prefs.setString(_keyFor(userId), payload);
    await _ensureInitialised(userId);
    _controllerFor(userId).add(position);
  }

  void dispose() {
    for (final controller in _controllers.values) {
      controller.close();
    }
    _controllers.clear();
    _initialisedUsers.clear();
  }
}
