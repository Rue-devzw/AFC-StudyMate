import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../drift/app_database.dart';
import '../services/notification_service.dart';

final appBootstrapServiceProvider = Provider<AppBootstrapService>((ref) {
  return AppBootstrapService(
    database: ref.read(appDatabaseProvider),
    notificationService: ref.read(notificationServiceProvider),
    logger: Logger(),
  );
});

class AppBootstrapService {
  AppBootstrapService({
    required this.database,
    required this.notificationService,
    required this.logger,
  });

  final AppDatabase database;
  final NotificationService notificationService;
  final Logger logger;

  bool _isFirstRun = true;
  bool get isFirstRun => _isFirstRun;

  Future<void> bootstrap() async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstRun = !(prefs.getBool('hasCompletedSetup') ?? false);

    await database.seedFromAssets();
    await notificationService.initialise();
    logger.i('Bootstrap complete, isFirstRun: $_isFirstRun');
  }
}
