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

  Future<void> initialise() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _notifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          _logger.i('Notification payload: $payload');
          // Navigate to the lesson or screen specified in the payload
          rootNavigatorKey.currentContext?.go(payload);
        }
      },
    );
  }

  Future<void> scheduleWeeklyReminder({
    required int hour,
    required int minute,
    required String id,
    required String title,
    required String body,
    required DateTime firstInstance,
  }) async {
    await _notifications.zonedSchedule(
      id: id.hashCode,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(firstInstance, tz.local).add(
        Duration(
          hours: hour - firstInstance.hour,
          minutes: minute - firstInstance.minute,
        ),
      ),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails('studyMate', 'Reminders'),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }
}
