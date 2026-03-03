import 'package:afc_studymate/data/drift/app_database.dart';
import 'package:afc_studymate/data/services/analytics_service.dart';
import 'package:afc_studymate/data/services/notification_service.dart';
import 'package:afc_studymate/data/services/push_messaging_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appBootstrapServiceProvider = Provider<AppBootstrapService>((ref) {
  return AppBootstrapService(
    database: ref.read(appDatabaseProvider),
    analyticsService: ref.read(analyticsServiceProvider),
    notificationService: ref.read(notificationServiceProvider),
    pushMessagingService: ref.read(pushMessagingServiceProvider),
    logger: Logger(),
  );
});

class AppBootstrapService {
  AppBootstrapService({
    required this.database,
    required this.analyticsService,
    required this.notificationService,
    required this.pushMessagingService,
    required this.logger,
  });

  final AppDatabase database;
  final AnalyticsService analyticsService;
  final NotificationService notificationService;
  final PushMessagingService pushMessagingService;
  final Logger logger;

  bool _isFirstRun = true;
  bool get isFirstRun => _isFirstRun;

  Future<void> bootstrap() async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstRun = !(prefs.getBool('hasCompletedSetup') ?? false);

    await database.seedFromAssets();
    await notificationService.initialise();
    await analyticsService.initialise();
    await pushMessagingService.initialise();
    logger.i('Bootstrap complete, isFirstRun: $_isFirstRun');
  }
}
