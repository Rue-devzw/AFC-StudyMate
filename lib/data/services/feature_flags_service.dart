import 'package:afc_studymate/firebase_options.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final featureFlagsProvider = Provider<FeatureFlags>((ref) {
  return const FeatureFlags();
});

class FeatureFlags {
  const FeatureFlags({
    this.enableAnalytics = const bool.fromEnvironment(
      'ENABLE_ANALYTICS',
    ),
    this.enablePushMessaging = const bool.fromEnvironment(
      'ENABLE_PUSH_MESSAGING',
    ),
    this.enableRemoteSync = const bool.fromEnvironment(
      'ENABLE_REMOTE_SYNC',
    ),
  });

  final bool enableAnalytics;
  final bool enablePushMessaging;
  final bool enableRemoteSync;

  bool get isFirebaseConfigured => DefaultFirebaseOptions.configured;
}
