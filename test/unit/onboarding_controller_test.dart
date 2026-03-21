import 'package:afc_studymate/data/drift/app_database.dart';
import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/user_profile.dart';
import 'package:afc_studymate/data/services/notification_service.dart';
import 'package:afc_studymate/features/onboarding/onboarding_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAppDatabase extends AppDatabase {
  UserProfile? savedProfile;
  final Map<String, String> savedSettings = <String, String>{};

  @override
  Future<void> upsertProfile(UserProfile profile) async {
    savedProfile = profile;
  }

  @override
  Future<void> upsertSetting(String key, String value) async {
    savedSettings[key] = value;
  }
}

class _FakeNotificationService extends NotificationService {
  _FakeNotificationService({required this.permissionGranted});

  final bool permissionGranted;
  final List<String> calls = <String>[];

  @override
  Future<bool> requestPermission() async {
    calls.add('requestPermission');
    return permissionGranted;
  }

  @override
  Future<void> scheduleDaily({
    required int hour,
    required int minute,
    String title = 'AFC StudyMate',
    String body = 'Time for your daily devotion and study! 📖',
  }) async {
    calls.add('scheduleDaily:$hour:$minute');
  }

  @override
  Future<void> scheduleWeeklySundayReminder({
    required int hour,
    required int minute,
  }) async {
    calls.add('scheduleSunday:$hour:$minute');
  }

  @override
  Future<void> scheduleWeeklyDiscoveryReminder({
    required int hour,
    required int minute,
  }) async {
    calls.add('scheduleDiscovery:$hour:$minute');
  }

  @override
  Future<void> cancelDaily() async {
    calls.add('cancelDaily');
  }

  @override
  Future<void> cancelWeeklySundayReminder() async {
    calls.add('cancelSunday');
  }

  @override
  Future<void> cancelWeeklyDiscoveryReminder() async {
    calls.add('cancelDiscovery');
  }
}

Future<void> _settleAsyncWork() async {
  await Future<void>.delayed(const Duration(milliseconds: 10));
  await Future<void>.delayed(const Duration(milliseconds: 10));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('complete persists reminder selections and schedules each reminder independently', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final database = _FakeAppDatabase();
    final notifications = _FakeNotificationService(permissionGranted: true);
    final controller = OnboardingController(
      database: database,
      notificationService: notifications,
    );

    controller.updateName('Teacher Ruth');
    controller.updateRole(Role.teacher);
    controller.updateTrack(Track.search);
    controller.updateTranslation(Translation.shona);
    controller.toggleDaily(false);
    controller.toggleSunday(true);
    controller.toggleDiscovery(false);

    await controller.complete();
    await _settleAsyncWork();

    final prefs = await SharedPreferences.getInstance();
    expect(controller.state.completed, isTrue);
    expect(database.savedProfile?.name, 'Teacher Ruth');
    expect(database.savedProfile?.role, Role.teacher);
    expect(database.savedProfile?.targetTrack, Track.search);
    expect(database.savedProfile?.translation, Translation.shona);
    expect(
      database.savedSettings,
      containsPair('daily_reminder_enabled', 'false'),
    );
    expect(
      database.savedSettings,
      containsPair('sunday_reminder_enabled', 'true'),
    );
    expect(
      database.savedSettings,
      containsPair('discovery_reminder_enabled', 'false'),
    );
    expect(prefs.getBool('hasCompletedSetup'), isTrue);
    expect(prefs.getBool('reminder_enabled'), isFalse);
    expect(prefs.getBool('sunday_reminder_enabled'), isTrue);
    expect(prefs.getBool('discovery_reminder_enabled'), isFalse);
    expect(
      notifications.calls,
      equals(<String>[
        'requestPermission',
        'cancelDaily',
        'scheduleSunday:8:0',
        'cancelDiscovery',
      ]),
    );
  });

  test('complete skips notification permission when every reminder is disabled', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final controller = OnboardingController(
      database: _FakeAppDatabase(),
      notificationService: _FakeNotificationService(permissionGranted: true),
    );

    controller.toggleDaily(false);
    controller.toggleSunday(false);
    controller.toggleDiscovery(false);

    await controller.complete();
    await _settleAsyncWork();

    final prefs = await SharedPreferences.getInstance();
    final notifications =
        controller.notificationService as _FakeNotificationService;
    expect(notifications.calls, isEmpty);
    expect(prefs.getBool('reminder_enabled'), isFalse);
    expect(prefs.getBool('sunday_reminder_enabled'), isFalse);
    expect(prefs.getBool('discovery_reminder_enabled'), isFalse);
  });

  test('complete stops scheduling when notification permission is denied', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final notifications = _FakeNotificationService(permissionGranted: false);
    final controller = OnboardingController(
      database: _FakeAppDatabase(),
      notificationService: notifications,
    );

    controller.toggleDaily(true);
    controller.toggleSunday(true);
    controller.toggleDiscovery(true);

    await controller.complete();
    await _settleAsyncWork();

    expect(notifications.calls, equals(<String>['requestPermission']));
  });
}
