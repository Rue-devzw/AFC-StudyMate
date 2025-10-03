import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../domain/chat/entities.dart';
import '../../domain/meetings/entities.dart';
import '../../domain/settings/entities.dart';
import '../../domain/settings/repositories.dart';

class NotificationService {
  NotificationService({
    required FirebaseMessaging messaging,
    required FlutterLocalNotificationsPlugin localNotifications,
    required SettingsRepository settingsRepository,
    required Future<String?> Function() userIdProvider,
  })  : _messaging = messaging,
        _localNotifications = localNotifications,
        _settingsRepository = settingsRepository,
        _userIdProvider = userIdProvider;

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final SettingsRepository _settingsRepository;
  final Future<String?> Function() _userIdProvider;

  static const AndroidNotificationChannel _chatChannel =
      AndroidNotificationChannel(
    'chat_messages',
    'Class chat messages',
    description: 'Notifications for new class chat messages.',
    importance: Importance.high,
  );

  static const AndroidNotificationChannel _meetingChannel =
      AndroidNotificationChannel(
    'live_meeting_reminders',
    'Live meeting reminders',
    description: 'Reminders for upcoming live lessons and roundtables.',
    importance: Importance.high,
  );

  bool _initialised = false;
  bool _timeZoneInitialised = false;

  Future<void> initialise() async {
    if (_initialised) {
      return;
    }
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      await _configureLocalNotifications();
      _initialised = true;
    }
  }

  Future<void> _configureLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings();
    await _localNotifications.initialize(
      const InitializationSettings(
          android: androidSettings, iOS: darwinSettings),
    );
    final androidPlugin =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_chatChannel);
    await androidPlugin?.createNotificationChannel(_meetingChannel);
  }

  Future<void> _ensureTimezoneInitialised() async {
    if (_timeZoneInitialised) {
      return;
    }
    tz.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation(DateTime.now().timeZoneName));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
    _timeZoneInitialised = true;
  }

  Future<void> handleIncomingMessage(
    ChatMessage message,
    String className,
  ) async {
    if (!_initialised) {
      await initialise();
    }
    final userId = await _userIdProvider();
    if (userId == null || userId == message.userId) {
      return;
    }
    final preferences =
        await _settingsRepository.getNotificationPreferences(userId);
    final now = DateTime.now();
    if (!preferences.shouldNotify(message.classId, now)) {
      return;
    }
    if (!preferences.localNotificationsEnabled) {
      return;
    }
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _chatChannel.id,
        _chatChannel.name,
        channelDescription: _chatChannel.description,
        importance: Importance.high,
        priority: Priority.high,
        styleInformation: const BigTextStyleInformation(''),
      ),
      iOS: const DarwinNotificationDetails(),
    );
    final body = message.deleted
        ? '${message.authorName ?? 'Moderator'} removed a message.'
        : '${message.authorName ?? 'Classmate'}: ${message.body}';
    await _localNotifications.show(
      message.createdAt.millisecondsSinceEpoch ~/ 1000,
      className,
      body,
      notificationDetails,
      payload: jsonEncode({
        'classId': message.classId,
      }),
    );
  }

  Future<void> dispose() async {
    if (!kIsWeb) {
      await _localNotifications.cancelAll();
    }
  }

  Future<void> scheduleRoundtableReminder(
    String sessionId,
    String title,
    DateTime startTime,
    int minutesBefore,
  ) async {
    if (!_initialised) {
      await initialise();
    }
    await _ensureTimezoneInitialised();
    final reminderTime = startTime.subtract(Duration(minutes: minutesBefore));
    if (reminderTime.isBefore(DateTime.now())) {
      return;
    }
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'roundtable_reminders',
        'Roundtable reminders',
        channelDescription: 'Reminders for upcoming roundtable sessions.',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
    );
    await _localNotifications.zonedSchedule(
      _scheduleId(sessionId),
      'Upcoming roundtable',
      '$title starts at ${startTime.toLocal()}.',
      tz.TZDateTime.from(reminderTime, tz.local),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  Future<void> scheduleMeetingReminder(
    String linkId,
    String title,
    DateTime meetingTime, {
    required MeetingRole role,
  }) async {
    if (!_initialised) {
      await initialise();
    }
    await _ensureTimezoneInitialised();
    final reminderTime = meetingTime.subtract(const Duration(minutes: 5));
    if (reminderTime.isBefore(DateTime.now())) {
      return;
    }
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _meetingChannel.id,
        _meetingChannel.name,
        channelDescription: _meetingChannel.description,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
    );
    final roleLabel = role == MeetingRole.host ? 'as host' : 'as attendee';
    await _localNotifications.zonedSchedule(
      _scheduleId('meeting:$linkId:${role.storageValue}'),
      'Upcoming meeting',
      '$title starts soon $roleLabel.',
      tz.TZDateTime.from(reminderTime, tz.local),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  Future<void> cancelRoundtableReminder(String sessionId) async {
    await _localNotifications.cancel(_scheduleId(sessionId));
  }

  int _scheduleId(String id) => id.hashCode & 0x7fffffff;
}

class ChatNotificationObserver {
  ChatNotificationObserver(this._watchMessages, this._notificationService);

  final Stream<List<ChatMessage>> Function(String classId) _watchMessages;
  final NotificationService _notificationService;
  final Map<String, StreamSubscription<List<ChatMessage>>> _subscriptions = {};
  final Map<String, String?> _lastMessageIds = {};

  Iterable<String> get attachedClassIds => _subscriptions.keys;

  void attach(String classId, String className) {
    if (_subscriptions.containsKey(classId)) {
      return;
    }
    final subscription = _watchMessages(classId).listen((messages) {
      if (messages.isEmpty) {
        return;
      }
      final latest = messages.last;
      final lastId = _lastMessageIds[classId];
      if (lastId == latest.id) {
        return;
      }
      _lastMessageIds[classId] = latest.id;
      unawaited(_notificationService.handleIncomingMessage(latest, className));
    });
    _subscriptions[classId] = subscription;
  }

  Future<void> detach(String classId) async {
    final subscription = _subscriptions.remove(classId);
    await subscription?.cancel();
    _lastMessageIds.remove(classId);
  }

  Future<void> dispose() async {
    for (final subscription in _subscriptions.values) {
      await subscription.cancel();
    }
    _subscriptions.clear();
    _lastMessageIds.clear();
    await _notificationService.dispose();
  }
}
