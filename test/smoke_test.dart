import 'package:afc_studymate/app_router.dart';
import 'package:afc_studymate/data/drift/app_database.dart';
import 'package:afc_studymate/data/services/analytics_service.dart';
import 'package:afc_studymate/data/services/app_bootstrap_service.dart';
import 'package:afc_studymate/data/services/asset_pack_service.dart';
import 'package:afc_studymate/data/services/notification_service.dart';
import 'package:afc_studymate/data/services/push_messaging_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

class _FakeBootstrapService extends AppBootstrapService {
  _FakeBootstrapService({required this.firstRun})
    : super(
        database: AppDatabase(),
        assetPackService: AssetPackService(),
        analyticsService: NoopAnalyticsService(logger: Logger()),
        notificationService: NotificationService(),
        pushMessagingService: NoopPushMessagingService(logger: Logger()),
        logger: Logger(),
      );

  final bool firstRun;

  @override
  bool get isFirstRun => firstRun;

  @override
  Future<void> bootstrap({
    void Function(BootstrapProgress progress)? onProgress,
  }) async {}
}

void main() {
  test('router starts on onboarding for first run users', () {
    final container = ProviderContainer(
      overrides: [
        appBootstrapServiceProvider.overrideWithValue(
          _FakeBootstrapService(firstRun: true),
        ),
      ],
    );
    addTearDown(container.dispose);

    final router = container.read(appRouterProvider);
    addTearDown(router.dispose);

    expect(
      router.routeInformationProvider.value.uri.toString(),
      '/onboarding',
    );
  });

  test('router starts on today for returning users', () {
    final container = ProviderContainer(
      overrides: [
        appBootstrapServiceProvider.overrideWithValue(
          _FakeBootstrapService(firstRun: false),
        ),
      ],
    );
    addTearDown(container.dispose);

    final router = container.read(appRouterProvider);
    addTearDown(router.dispose);

    expect(
      router.routeInformationProvider.value.uri.toString(),
      '/home/today',
    );
  });
}
