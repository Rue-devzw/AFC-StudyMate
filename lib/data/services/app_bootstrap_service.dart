import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

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

  Future<void> bootstrap() async {
    await database.seedFromAssets();
    await notificationService.initialise();
    logger.i('Bootstrap complete');
  }
}
