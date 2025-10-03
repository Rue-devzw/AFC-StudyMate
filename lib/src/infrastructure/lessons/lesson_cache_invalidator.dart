import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;

import '../db/app_database.dart';
import 'lesson_ingestion_pipeline.dart';

class LessonCacheInvalidator {
  LessonCacheInvalidator(
    this._db,
    this._pipeline, {
    Duration interval = const Duration(hours: 1),
    http.Client? client,
  })  : _interval = interval,
        _client = client ?? http.Client();

  final AppDatabase _db;
  final LessonIngestionPipeline _pipeline;
  final Duration _interval;
  final http.Client _client;

  Timer? _timer;
  bool _runningCheck = false;

  void start() {
    _timer ??= Timer.periodic(_interval, (_) => _checkFeeds());
    scheduleMicrotask(_checkFeeds);
  }

  Future<void> _checkFeeds() async {
    if (_runningCheck) {
      return;
    }
    _runningCheck = true;
    try {
      final feeds = await _db.select(_db.lessonFeeds).get();
      for (final feed in feeds) {
        final source = feed.source;
        if (!source.startsWith('http')) {
          continue;
        }
        final uri = Uri.tryParse(source);
        if (uri == null) {
          continue;
        }
        try {
          final response = await _client.head(uri).timeout(
                const Duration(seconds: 10),
              );
          final etag = response.headers['etag'];
          DateTime? lastModified;
          final lastModifiedHeader = response.headers['last-modified'];
          if (lastModifiedHeader != null) {
            try {
              lastModified = HttpDate.parse(lastModifiedHeader);
            } on FormatException {
              lastModified = null;
            }
          }

          final hasChanged = (etag != null && etag != feed.etag) ||
              (lastModified != null &&
                  feed.lastModified != lastModified.millisecondsSinceEpoch);
          if (hasChanged) {
            await _pipeline.ingestRemoteFeed(uri, feedId: feed.id);
          }

          await _db.into(_db.lessonFeeds).insertOnConflictUpdate(
                LessonFeedsCompanion(
                  id: Value(feed.id),
                  source: Value(feed.source),
                  cohort: Value(feed.cohort),
                  lessonClass: Value(feed.lessonClass),
                  checksum: Value(feed.checksum),
                  etag: Value(etag ?? feed.etag),
                  lastModified: Value(lastModified?.millisecondsSinceEpoch ?? feed.lastModified),
                  lastFetchedAt: Value(feed.lastFetchedAt),
                  lastCheckedAt: Value(DateTime.now().millisecondsSinceEpoch),
                ),
              );
        } on http.ClientException {
          continue;
        } on SocketException {
          continue;
        } on TimeoutException {
          continue;
        }
      }
    } finally {
      _runningCheck = false;
    }
  }

  void dispose() {
    _timer?.cancel();
    _client.close();
  }
}
