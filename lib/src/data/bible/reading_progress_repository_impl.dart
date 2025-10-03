import 'dart:async';
import 'dart:convert';

import '../../domain/bible/reading_progress/entities.dart';
import '../../domain/bible/reading_progress/repositories.dart';
import '../../infrastructure/security/secure_storage_service.dart';

class ReadingProgressRepositoryImpl implements ReadingProgressRepository {
  ReadingProgressRepositoryImpl(this._storage);

  static const _storageKey = 'reading_progress_state';
  final _controllers = <String, StreamController<ReadingPosition?>>{};
  final _initialisedUsers = <String>{};
  final SecureStorageService _storage;

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
    final stored = await _storage.read(_keyFor(userId));
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
    final payload = jsonEncode({
      'translationId': position.translationId,
      'bookId': position.bookId,
      'chapter': position.chapter,
      'verse': position.verse,
      'updatedAt': position.updatedAt.millisecondsSinceEpoch,
    });
    await _storage.write(_keyFor(userId), payload);
    await _ensureInitialised(userId);
    _controllerFor(userId).add(position);
  }

  @override
  Future<void> clear(String userId) async {
    await _storage.delete(_keyFor(userId));
    final controller = _controllers[userId];
    controller?.add(null);
    _initialisedUsers.remove(userId);
  }

  void dispose() {
    for (final controller in _controllers.values) {
      controller.close();
    }
    _controllers.clear();
    _initialisedUsers.clear();
  }
}
