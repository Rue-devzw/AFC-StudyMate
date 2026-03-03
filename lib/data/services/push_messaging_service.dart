import 'dart:async';

import 'package:afc_studymate/data/services/feature_flags_service.dart';
import 'package:afc_studymate/data/services/firebase_runtime_service.dart';
import 'package:afc_studymate/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _fcmTokenPrefKey = 'fcm_token';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (!DefaultFirebaseOptions.configured) {
    return;
  }

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
  } catch (_) {
    // Ignore background init failures in local-first mode.
  }
}

final pushMessagingServiceProvider = Provider<PushMessagingService>((ref) {
  final flags = ref.read(featureFlagsProvider);
  final logger = Logger();

  if (!flags.enablePushMessaging) {
    return NoopPushMessagingService(logger: logger);
  }

  return FirebasePushMessagingService(
    runtime: ref.read(firebaseRuntimeServiceProvider),
    logger: logger,
  );
});

abstract class PushMessagingService {
  Future<void> initialise();
  Future<String?> getToken();
}

class NoopPushMessagingService implements PushMessagingService {
  NoopPushMessagingService({required this.logger});

  final Logger logger;

  @override
  Future<String?> getToken() async => null;

  @override
  Future<void> initialise() async {
    logger.i('Push messaging disabled; no-op adapter active.');
  }
}

class FirebasePushMessagingService implements PushMessagingService {
  FirebasePushMessagingService({required this.runtime, required this.logger});

  final FirebaseRuntimeService runtime;
  final Logger logger;

  StreamSubscription<RemoteMessage>? _foregroundMessages;
  bool _initialised = false;

  @override
  Future<void> initialise() async {
    if (_initialised) {
      return;
    }

    final ready = await runtime.ensureInitialised();
    if (!ready) {
      return;
    }

    try {
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission(
        
      );

      logger.i('FCM permission status: ${settings.authorizationStatus.name}');

      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      _foregroundMessages ??= FirebaseMessaging.onMessage.listen((message) {
        logger.i('Foreground FCM message: ${message.messageId ?? 'unknown'}');
      });

      _initialised = true;
      await _persistToken(await messaging.getToken());
      messaging.onTokenRefresh.listen(_persistToken);
    } catch (error, stackTrace) {
      logger.w(
        'Push messaging init failed; keeping no-op behavior.',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fcmTokenPrefKey);
  }

  Future<void> _persistToken(String? token) async {
    if (token == null || token.isEmpty) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fcmTokenPrefKey, token);
    logger.i('FCM token registered locally.');
  }
}
