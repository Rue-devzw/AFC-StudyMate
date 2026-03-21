import 'package:afc_studymate/data/drift/app_database.dart';
import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/services/analytics_service.dart';
import 'package:afc_studymate/data/services/app_bootstrap_service.dart';
import 'package:afc_studymate/data/services/asset_pack_service.dart';
import 'package:afc_studymate/data/services/notification_service.dart';
import 'package:afc_studymate/data/services/push_messaging_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAppDatabase extends AppDatabase {
  bool seeded = false;
  Future<String> Function(String assetPath)? lastTextLoader;

  @override
  Future<void> seedFromAssets({
    Future<String> Function(String assetPath)? textLoader,
  }) async {
    seeded = true;
    lastTextLoader = textLoader;
  }
}

class _FakeAssetPackService extends AssetPackService {
  int prepareCalls = 0;

  @override
  Future<AssetPackPrepareResult> prepare({
    void Function(AssetPackProgress progress)? onProgress,
    Set<String>? includeLogicalAssetPaths,
    Set<String>? includeExtensions,
  }) async {
    prepareCalls++;
    onProgress?.call(
      const AssetPackProgress(
        progress: 0.4,
        message: 'Preparing fake asset pack...',
      ),
    );
    return const AssetPackPrepareResult(
      usedCompressedBundles: true,
      usedFallbackAssets: false,
      version: 1,
    );
  }

  @override
  Future<String> loadText(String logicalAssetPath) async {
    return '{}';
  }
}

class _FakeNotificationService extends NotificationService {
  int initialiseCalls = 0;

  @override
  Future<void> initialise() async {
    initialiseCalls++;
  }
}

class _FakeAnalyticsService implements AnalyticsService {
  int initialiseCalls = 0;

  @override
  Future<void> initialise() async {
    initialiseCalls++;
  }

  @override
  Future<void> logDaybreakRead({required String lessonId}) async {}

  @override
  Future<void> logJournalSaved({
    required String source,
    Track? track,
    String? lessonId,
  }) async {}

  @override
  Future<void> logLessonCompleted({
    required String lessonId,
    required Track track,
  }) async {}

  @override
  Future<void> logLessonOpened({
    required String lessonId,
    required Track track,
    String? source,
  }) async {}

  @override
  Future<void> logMemoryVerseReviewed({
    required String verseId,
    required String action,
  }) async {}

  @override
  Future<void> logTeacherAttendanceMarked({
    required String studentId,
    required bool present,
    required String lessonId,
    required String dateKey,
  }) async {}
}

class _FakePushMessagingService implements PushMessagingService {
  int initialiseCalls = 0;

  @override
  Future<String?> getToken() async => null;

  @override
  Future<void> initialise() async {
    initialiseCalls++;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('bootstrap marks first run false for returning users and reports stages', () async {
    SharedPreferences.setMockInitialValues({'hasCompletedSetup': true});
    final database = _FakeAppDatabase();
    final assetPackService = _FakeAssetPackService();
    final notificationService = _FakeNotificationService();
    final analyticsService = _FakeAnalyticsService();
    final pushMessagingService = _FakePushMessagingService();
    final bootstrap = AppBootstrapService(
      database: database,
      assetPackService: assetPackService,
      analyticsService: analyticsService,
      notificationService: notificationService,
      pushMessagingService: pushMessagingService,
      logger: Logger(),
    );
    final progressMessages = <String>[];

    await bootstrap.bootstrap(
      onProgress: (progress) => progressMessages.add(progress.message),
    );

    expect(bootstrap.isFirstRun, isFalse);
    expect(database.seeded, isTrue);
    expect(assetPackService.prepareCalls, 1);
    expect(notificationService.initialiseCalls, 1);
    expect(analyticsService.initialiseCalls, 1);
    expect(pushMessagingService.initialiseCalls, 1);
    expect(
      progressMessages,
      containsAllInOrder([
        'Preparing lesson bundles...',
        'Preparing fake asset pack...',
        'Loading lesson data...',
        'Initializing notifications...',
        'Initializing analytics...',
        'Initializing messaging...',
        'Ready',
      ]),
    );
  });

  test('bootstrap marks first run true when setup has not completed', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final bootstrap = AppBootstrapService(
      database: _FakeAppDatabase(),
      assetPackService: _FakeAssetPackService(),
      analyticsService: NoopAnalyticsService(logger: Logger()),
      notificationService: _FakeNotificationService(),
      pushMessagingService: _FakePushMessagingService(),
      logger: Logger(),
    );

    await bootstrap.bootstrap();

    expect(bootstrap.isFirstRun, isTrue);
  });
}
