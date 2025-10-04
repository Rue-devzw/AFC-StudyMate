import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:workmanager/workmanager.dart';

import '../db/app_database.dart';
import 'lesson_attachment_cache.dart';
import 'lesson_ingestion_pipeline.dart';
import 'lesson_source_registry.dart';
import 'lesson_sync_constants.dart';
import '../sync/sync_orchestrator.dart';

const String kLessonSyncBackgroundTask = 'afc_lesson_sync';

class LessonSyncService {
  LessonSyncService({
    required AssetBundle bundle,
    required LessonIngestionPipeline pipeline,
    required LessonSourceRegistry registry,
    required LessonAttachmentCache attachmentCache,
    http.Client? client,
  })  : _bundle = bundle,
        _pipeline = pipeline,
        _registry = registry,
        _attachmentCache = attachmentCache,
        _client = client ?? http.Client();

  final AssetBundle _bundle;
  final LessonIngestionPipeline _pipeline;
  final LessonSourceRegistry _registry;
  final LessonAttachmentCache _attachmentCache;
  final http.Client _client;

  Future<LessonSyncSummary>? _runningSync;
  static bool _workmanagerInitialised = false;

  Future<void> ensureBackgroundScheduled() async {
    if (!_supportsBackgroundScheduling) {
      return;
    }

    if (!_workmanagerInitialised) {
      try {
        await Workmanager().initialize(
          lessonSyncCallbackDispatcher,
          isInDebugMode: kDebugMode,
        );
        _workmanagerInitialised = true;
      } catch (_) {
        return;
      }
    }

    try {
      await Workmanager().registerPeriodicTask(
        kLessonSyncBackgroundTask,
        kLessonSyncBackgroundTask,
        frequency: const Duration(hours: 6),
        initialDelay: const Duration(minutes: 15),
        existingWorkPolicy: ExistingWorkPolicy.keep,
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
      );
    } catch (_) {
      // Ignore registration errors.
    }
  }

  Future<LessonSyncSummary> syncAll({bool force = false}) {
    final running = _runningSync;
    if (running != null) {
      return running;
    }

    final completer = Completer<LessonSyncSummary>();
    _runningSync = completer.future;

    () async {
      try {
        await _registry.registerBundledSources(_bundle);
        final sources = await _registry.getAllSources();
        final results = <LessonSyncSourceResult>[];
        for (final source in sources) {
          if (!source.enabled) {
            results.add(LessonSyncSourceResult(
              sourceId: source.id,
              type: source.type,
              status: LessonSyncStatus.skipped,
              message: 'Disabled',
            ));
            continue;
          }
          try {
            final result = await _syncSource(source, force: force);
            results.add(result);
          } catch (error) {
            final message = error.toString();
            await _registry.updateError(source.id, message);
            results.add(LessonSyncSourceResult(
              sourceId: source.id,
              type: source.type,
              status: LessonSyncStatus.failed,
              message: message,
            ));
          }
        }
        final summary = LessonSyncSummary(results: results);
        completer.complete(summary);
      } catch (error, stackTrace) {
        if (!completer.isCompleted) {
          completer.completeError(error, stackTrace);
        }
      } finally {
        _runningSync = null;
      }
    }();

    return completer.future;
  }

  Future<LessonSyncSourceResult> _syncSource(
    LessonSourceRow source, {
    required bool force,
  }) async {
    await _registry.markAttempt(source.id);
    switch (source.type) {
      case LessonSourceType.asset:
        return _syncAssetSource(source, force: force);
      case LessonSourceType.remote:
        return _syncRemoteSource(source, force: force);
      default:
        final message = 'Unsupported source type ${source.type}';
        await _registry.updateError(source.id, message);
        return LessonSyncSourceResult(
          sourceId: source.id,
          type: source.type,
          status: LessonSyncStatus.failed,
          message: message,
        );
    }
  }

  Future<LessonSyncSourceResult> _syncAssetSource(
    LessonSourceRow source, {
    required bool force,
  }) async {
    final assetPath = source.location.startsWith('asset:')
        ? source.location.substring(6)
        : source.location;
    final result = await _pipeline.ingestAssetFeed(
      assetPath: assetPath,
      feedId: source.id,
      fallbackClass: source.lessonClass,
      fallbackTitle: source.label ?? source.cohort,
    );
    if (result == null) {
      const message = 'Bundled lesson feed missing';
      await _registry.updateError(source.id, message);
      return LessonSyncSourceResult(
        sourceId: source.id,
        type: source.type,
        status: LessonSyncStatus.failed,
        message: message,
      );
    }
    final attachmentSummary = await _attachmentCache.ensureForLessons(
      result.lessonIds,
      quotaBytes: source.quotaBytes ?? kDefaultLessonAttachmentQuotaBytes,
    );
    await _registry.updateAttachmentUsage(
      source.id,
      attachmentSummary.totalBytes,
    );
    final message =
        'Synced ${result.lessonCount} lessons (${attachmentSummary.downloaded} attachments updated)';
    return LessonSyncSourceResult(
      sourceId: source.id,
      type: source.type,
      status: LessonSyncStatus.success,
      message: message,
      attachmentSummary: attachmentSummary,
    );
  }

  Future<LessonSyncSourceResult> _syncRemoteSource(
    LessonSourceRow source, {
    required bool force,
  }) async {
    final uri = Uri.tryParse(source.location);
    if (uri == null) {
      const message = 'Invalid URL';
      await _registry.updateError(source.id, message);
      return LessonSyncSourceResult(
        sourceId: source.id,
        type: source.type,
        status: LessonSyncStatus.failed,
        message: message,
      );
    }

    bool shouldDownload = true;
    if (!force) {
      try {
        final response = await _client.head(uri).timeout(
              const Duration(seconds: 10),
            );
        final etag = response.headers['etag'];
        DateTime? lastModified;
        final lastModifiedHeader = response.headers['last-modified'];
        if (lastModifiedHeader != null) {
          try {
            lastModified = http_parser.parseHttpDate(lastModifiedHeader);
          } catch (_) {
            lastModified = null;
          }
        }

        final unchanged = response.statusCode == 304 ||
            (etag != null && etag == source.etag) ||
            (lastModified != null &&
                source.lastModified != null &&
                source.lastModified == lastModified.millisecondsSinceEpoch);
        if (unchanged) {
          await _registry.markChecked(
            source.id,
            etag: etag ?? source.etag,
            lastModified: lastModified ??
                (source.lastModified == null
                    ? null
                    : DateTime.fromMillisecondsSinceEpoch(source.lastModified!)),
          );
          shouldDownload = false;
        }
      } on TimeoutException {
        // ignore
      } on http.ClientException {
        // ignore
      } catch (_) {
        // ignore other errors and proceed to download
      }
    }

    if (!shouldDownload) {
      return LessonSyncSourceResult(
        sourceId: source.id,
        type: source.type,
        status: LessonSyncStatus.skipped,
        message: 'Up to date',
      );
    }

    try {
      final result = await _pipeline.ingestRemoteFeed(uri, feedId: source.id);
      final attachmentSummary = await _attachmentCache.ensureForLessons(
        result.lessonIds,
        quotaBytes: source.quotaBytes ?? kDefaultLessonAttachmentQuotaBytes,
      );
      await _registry.updateAttachmentUsage(
        source.id,
        attachmentSummary.totalBytes,
      );
      final message =
          'Fetched ${result.lessonCount} lessons (${attachmentSummary.downloaded} attachments updated)';
      return LessonSyncSourceResult(
        sourceId: source.id,
        type: source.type,
        status: LessonSyncStatus.success,
        message: message,
        attachmentSummary: attachmentSummary,
      );
    } catch (error) {
      await _registry.updateError(source.id, error.toString());
      return LessonSyncSourceResult(
        sourceId: source.id,
        type: source.type,
        status: LessonSyncStatus.failed,
        message: error.toString(),
      );
    }
  }

  void dispose() {
    _client.close();
    _attachmentCache.dispose();
  }

  bool get _supportsBackgroundScheduling {
    if (kIsWeb) {
      return false;
    }
    final platform = defaultTargetPlatform;
    return platform == TargetPlatform.android || platform == TargetPlatform.iOS;
  }
}

class LessonSyncSummary {
  LessonSyncSummary({required this.results});

  final List<LessonSyncSourceResult> results;

  int get successCount =>
      results.where((result) => result.status == LessonSyncStatus.success).length;
  int get failureCount =>
      results.where((result) => result.status == LessonSyncStatus.failed).length;
  List<LessonSyncSourceResult> get failedSources => results
      .where((result) => result.status == LessonSyncStatus.failed)
      .toList();
}

enum LessonSyncStatus { success, skipped, failed }

class LessonSyncSourceResult {
  LessonSyncSourceResult({
    required this.sourceId,
    required this.type,
    required this.status,
    required this.message,
    this.attachmentSummary,
  });

  final String sourceId;
  final String type;
  final LessonSyncStatus status;
  final String message;
  final AttachmentCacheSummary? attachmentSummary;
}

@pragma('vm:entry-point')
void lessonSyncCallbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    if (task == kDataSyncBackgroundTask) {
      return await runDataSyncTask();
    }

    final db = AppDatabase();
    final registry = LessonSourceRegistry(db);
    final cache = LessonAttachmentCache(db);
    final pipeline = LessonIngestionPipeline(db, rootBundle, registry: registry);
    final service = LessonSyncService(
      bundle: rootBundle,
      pipeline: pipeline,
      registry: registry,
      attachmentCache: cache,
    );

    try {
      final summary = await service.syncAll();
      service.dispose();
      await db.close();
      return summary.failureCount == 0;
    } catch (_) {
      service.dispose();
      await db.close();
      return false;
    }
  });
}
