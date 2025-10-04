import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../db/app_database.dart';
import 'lesson_sync_constants.dart';

class AttachmentCacheSummary {
  const AttachmentCacheSummary({
    required this.downloaded,
    required this.skipped,
    required this.removed,
    required this.totalBytes,
  });

  final int downloaded;
  final int skipped;
  final int removed;
  final int totalBytes;

  static const AttachmentCacheSummary empty = AttachmentCacheSummary(
    downloaded: 0,
    skipped: 0,
    removed: 0,
    totalBytes: 0,
  );
}

class LessonAttachmentCache {
  LessonAttachmentCache(this._db, {http.Client? client})
      : _client = client ?? http.Client();

  final AppDatabase _db;
  final http.Client _client;
  Directory? _cacheDirectory;

  Future<AttachmentCacheSummary> ensureForLessons(
    Iterable<String> lessonIds, {
    int? quotaBytes,
  }) async {
    final ids = lessonIds.toSet();
    if (ids.isEmpty) {
      final usage = await _currentUsage();
      return AttachmentCacheSummary.empty.copyWith(totalBytes: usage);
    }

    final attachments = await (_db.select(_db.lessonAttachments)
          ..where((tbl) => tbl.lessonId.isIn(ids.toList())))
        .get();
    if (attachments.isEmpty) {
      final usage = await _currentUsage();
      return AttachmentCacheSummary.empty.copyWith(totalBytes: usage);
    }

    final directory = await _ensureCacheDirectory();
    var downloaded = 0;
    var skipped = 0;

    for (final attachment in attachments) {
      final uri = Uri.tryParse(attachment.url);
      if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) {
        skipped++;
        continue;
      }

      final file = await _resolveFile(directory, attachment.url);
      if (await file.exists()) {
        final fileLength = await file.length();
        if (attachment.localPath != file.path ||
            (attachment.sizeBytes ?? 0) != fileLength) {
          await (_db.update(_db.lessonAttachments)
                ..where((tbl) => tbl.lessonId.equals(attachment.lessonId) &
                    tbl.position.equals(attachment.position)))
              .write(
                LessonAttachmentsCompanion(
                  localPath: Value(file.path),
                  sizeBytes: Value(fileLength),
                  downloadedAt: Value(attachment.downloadedAt ??
                      DateTime.now().millisecondsSinceEpoch),
                ),
              );
        }
        skipped++;
        continue;
      }

      try {
        final response = await _client.get(uri).timeout(
              const Duration(seconds: 20),
            );
        if (response.statusCode >= 400) {
          skipped++;
          continue;
        }
        await file.create(recursive: true);
        await file.writeAsBytes(response.bodyBytes);
        downloaded++;
        await (_db.update(_db.lessonAttachments)
              ..where((tbl) =>
                  tbl.lessonId.equals(attachment.lessonId) &
                  tbl.position.equals(attachment.position)))
            .write(
              LessonAttachmentsCompanion(
                localPath: Value(file.path),
                sizeBytes: Value(response.bodyBytes.length),
                downloadedAt:
                    Value(DateTime.now().millisecondsSinceEpoch),
              ),
            );
      } on TimeoutException {
        skipped++;
      } on SocketException {
        skipped++;
      }
    }

    await _enforceQuota(quotaBytes ?? kDefaultLessonAttachmentQuotaBytes);

    final removed = await _evictMissingFiles();
    final usage = await _currentUsage();

    return AttachmentCacheSummary(
      downloaded: downloaded,
      skipped: skipped,
      removed: removed,
      totalBytes: usage,
    );
  }

  Future<int> _enforceQuota(int quotaBytes) async {
    if (quotaBytes <= 0) {
      return 0;
    }
    final attachments = await (_db.select(_db.lessonAttachments)
          ..where((tbl) => tbl.localPath.isNotNull())
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.downloadedAt)]))
        .get();

    var total = 0;
    final toDelete = <LessonAttachmentRow>[];
    for (final attachment in attachments) {
      final size = attachment.sizeBytes ?? 0;
      if (total + size > quotaBytes) {
        toDelete.add(attachment);
      } else {
        total += size;
      }
    }

    for (final attachment in toDelete) {
      if (attachment.localPath != null) {
        final file = File(attachment.localPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }
      await (_db.update(_db.lessonAttachments)
            ..where((tbl) => tbl.lessonId.equals(attachment.lessonId) &
                tbl.position.equals(attachment.position)))
          .write(
            const LessonAttachmentsCompanion(
              localPath: Value(null),
              sizeBytes: Value(null),
              downloadedAt: Value(null),
            ),
          );
    }

    return total;
  }

  Future<int> _evictMissingFiles() async {
    final attachments = await (_db.select(_db.lessonAttachments)
          ..where((tbl) => tbl.localPath.isNotNull()))
        .get();

    var removed = 0;
    for (final attachment in attachments) {
      final path = attachment.localPath;
      if (path == null) {
        continue;
      }
      final file = File(path);
      if (await file.exists()) {
        continue;
      }
      removed++;
      await (_db.update(_db.lessonAttachments)
            ..where((tbl) => tbl.lessonId.equals(attachment.lessonId) &
                tbl.position.equals(attachment.position)))
          .write(
            const LessonAttachmentsCompanion(
              localPath: Value(null),
              sizeBytes: Value(null),
              downloadedAt: Value(null),
            ),
          );
    }

    return removed;
  }

  Future<int> _currentUsage() async {
    final attachments = await (_db.select(_db.lessonAttachments)
          ..where((tbl) => tbl.sizeBytes.isNotNull()))
        .get();
    return attachments.fold<int>(
      0,
      (int sum, LessonAttachmentRow item) => sum + (item.sizeBytes ?? 0),
    );
  }

  Future<File> _resolveFile(Directory directory, String url) async {
    final digest = sha1.convert(utf8.encode(url)).toString();
    final uri = Uri.parse(url);
    final extension = p.extension(uri.path);
    return File(p.join(directory.path, '$digest$extension'));
  }

  Future<Directory> _ensureCacheDirectory() async {
    if (_cacheDirectory != null) {
      return _cacheDirectory!;
    }
    final base = await getApplicationSupportDirectory();
    final directory = Directory(p.join(base.path, 'lesson_attachments'));
    if (!(await directory.exists())) {
      await directory.create(recursive: true);
    }
    _cacheDirectory = directory;
    return directory;
  }

  void dispose() {
    _client.close();
  }
}

extension on AttachmentCacheSummary {
  AttachmentCacheSummary copyWith({
    int? downloaded,
    int? skipped,
    int? removed,
    int? totalBytes,
  }) {
    return AttachmentCacheSummary(
      downloaded: downloaded ?? this.downloaded,
      skipped: skipped ?? this.skipped,
      removed: removed ?? this.removed,
      totalBytes: totalBytes ?? this.totalBytes,
    );
  }
}
