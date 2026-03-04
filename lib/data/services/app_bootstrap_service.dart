import 'package:afc_studymate/data/drift/app_database.dart';
import 'package:afc_studymate/data/services/analytics_service.dart';
import 'package:afc_studymate/data/services/asset_pack_service.dart';
import 'package:afc_studymate/data/services/notification_service.dart';
import 'package:afc_studymate/data/services/push_messaging_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appBootstrapServiceProvider = Provider<AppBootstrapService>((ref) {
  return AppBootstrapService(
    database: ref.read(appDatabaseProvider),
    assetPackService: ref.read(assetPackServiceProvider),
    analyticsService: ref.read(analyticsServiceProvider),
    notificationService: ref.read(notificationServiceProvider),
    pushMessagingService: ref.read(pushMessagingServiceProvider),
    logger: Logger(),
  );
});

class AppBootstrapService {
  AppBootstrapService({
    required this.database,
    required this.assetPackService,
    required this.analyticsService,
    required this.notificationService,
    required this.pushMessagingService,
    required this.logger,
  });

  final AppDatabase database;
  final AssetPackService assetPackService;
  final AnalyticsService analyticsService;
  final NotificationService notificationService;
  final PushMessagingService pushMessagingService;
  final Logger logger;

  bool _isFirstRun = true;
  bool get isFirstRun => _isFirstRun;

  Future<void> bootstrap({
    void Function(BootstrapProgress progress)? onProgress,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstRun = !(prefs.getBool('hasCompletedSetup') ?? false);
    onProgress?.call(
      const BootstrapProgress(
        progress: 0.03,
        message: 'Preparing lesson bundles...',
      ),
    );
    final unpackResult = await assetPackService.prepare(
      onProgress: (progress) {
        onProgress?.call(
          BootstrapProgress(
            progress: 0.05 + (progress.progress * 0.6),
            message: progress.message,
          ),
        );
      },
    );
    if (unpackResult.usedFallbackAssets) {
      logger.w('Asset pack unpack failed, falling back to embedded assets.');
    }

    onProgress?.call(
      const BootstrapProgress(
        progress: 0.68,
        message: 'Loading lesson data...',
      ),
    );
    await database.seedFromAssets(textLoader: assetPackService.loadText);
    onProgress?.call(
      const BootstrapProgress(
        progress: 0.78,
        message: 'Initializing notifications...',
      ),
    );
    await notificationService.initialise();
    onProgress?.call(
      const BootstrapProgress(
        progress: 0.86,
        message: 'Initializing analytics...',
      ),
    );
    await analyticsService.initialise();
    onProgress?.call(
      const BootstrapProgress(
        progress: 0.93,
        message: 'Initializing messaging...',
      ),
    );
    await pushMessagingService.initialise();
    onProgress?.call(
      const BootstrapProgress(
        progress: 1,
        message: 'Ready',
      ),
    );
    logger.i('Bootstrap complete, isFirstRun: $_isFirstRun');
  }
}

class BootstrapProgress {
  const BootstrapProgress({
    required this.progress,
    required this.message,
  });

  final double progress;
  final String message;
}
