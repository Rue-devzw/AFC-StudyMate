import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../app_router.dart';

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

  static const NotificationDetails _details = NotificationDetails(
    android: AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: 'Daily study and devotion reminders',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    ),
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  Future<void> initialise() async {
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
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
    String title = 'AFC StudyMate',
    String body = 'Time for your daily devotion and study! 📖',
  }) async {
    await _notifications.cancelAll();

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
      id: 0,
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
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    while (scheduledDate.weekday != DateTime.sunday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }

    await _notifications.zonedSchedule(
      id: 1,
      scheduledDate: scheduledDate,
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      title: 'Sunday School Today!',
      body: 'Your weekly lesson is ready. Tap to study! 🎓',
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
    _logger.i('Weekly Sunday reminder scheduled at $hour:$minute');
  }

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
    _logger.i('All notifications cancelled');
  }
}
