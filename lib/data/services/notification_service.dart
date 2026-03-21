import 'package:afc_studymate/app_router.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:timezone/timezone.dart' as tz;

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

class NotificationService {
  NotificationService();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final Logger _logger = Logger();

  static const String _channelId = 'studymate_reminders';
  static const String _channelName = 'Daily Reminders';
  static const String _androidIcon = '@drawable/ic_stat_notify';
  static const int _dailyReminderId = 0;
  static const int _sundayReminderId = 1;
  static const int _discoveryReminderId = 2;

  static const NotificationDetails _details = NotificationDetails(
    android: AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: 'Daily study and devotion reminders',
      importance: Importance.high,
      priority: Priority.high,
      icon: _androidIcon,
    ),
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  Future<void> initialise() async {
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings(_androidIcon),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    try {
      await _notifications.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (response) {
          final payload = response.payload;
          if (payload != null && payload.isNotEmpty) {
            _logger.i('Notification tapped: $payload');
            rootNavigatorKey.currentContext?.go(payload);
          }
        },
      );
    } catch (error, stackTrace) {
      _logger.w(
        'Notification initialise failed. Continuing without notifications.',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<bool> requestPermission() async {
    final android = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final ios = _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    final androidGranted =
        await android?.requestNotificationsPermission() ?? true;
    final iosGranted =
        await ios?.requestPermissions(alert: true, badge: true, sound: true) ??
        true;

    return androidGranted && iosGranted;
  }

  /// Schedule a daily repeating reminder at [hour]:[minute] local time.
  Future<void> scheduleDaily({
    required int hour,
    required int minute,
    String title = 'AFM SEAR StudyMate',
    String body = 'Time for your daily devotion and study! 📖',
  }) async {
    await _notifications.cancel(id: _dailyReminderId);

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notifications.zonedSchedule(
      id: _dailyReminderId,
      scheduledDate: scheduledDate,
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      title: title,
      body: body,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    _logger.i('Daily reminder scheduled at $hour:$minute');
  }

  /// Schedule a weekly Sunday School reminder.
  Future<void> scheduleWeeklySundayReminder({
    required int hour,
    required int minute,
  }) async {
    await _scheduleWeeklyReminder(
      id: _sundayReminderId,
      weekday: DateTime.sunday,
      hour: hour,
      minute: minute,
      title: 'Sunday School Today!',
      body: 'Your weekly lesson is ready. Tap to study! 🎓',
    );
    _logger.i('Weekly Sunday reminder scheduled at $hour:$minute');
  }

  Future<void> scheduleWeeklyDiscoveryReminder({
    required int hour,
    required int minute,
  }) async {
    await _scheduleWeeklyReminder(
      id: _discoveryReminderId,
      weekday: DateTime.wednesday,
      hour: hour,
      minute: minute,
      title: 'Discovery Reminder',
      body: 'Your mid-week Discovery lesson is ready. Tap to reflect.',
    );
    _logger.i('Weekly Discovery reminder scheduled at $hour:$minute');
  }

  Future<void> _scheduleWeeklyReminder({
    required int id,
    required int weekday,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    await _notifications.cancel(id: id);
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    while (scheduledDate.weekday != weekday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }

    await _notifications.zonedSchedule(
      id: id,
      scheduledDate: scheduledDate,
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      title: title,
      body: body,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
    _logger.i('All notifications cancelled');
  }

  Future<void> cancelDaily() async {
    await _notifications.cancel(id: _dailyReminderId);
    _logger.i('Daily reminder cancelled');
  }

  Future<void> cancelWeeklySundayReminder() async {
    await _notifications.cancel(id: _sundayReminderId);
    _logger.i('Weekly Sunday reminder cancelled');
  }

  Future<void> cancelWeeklyDiscoveryReminder() async {
    await _notifications.cancel(id: _discoveryReminderId);
    _logger.i('Weekly Discovery reminder cancelled');
  }
}
