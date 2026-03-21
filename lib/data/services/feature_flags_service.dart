import 'package:afc_studymate/firebase_options.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final featureFlagsProvider = Provider<FeatureFlags>((ref) {
  return const FeatureFlags();
});

final cloudFeaturesAvailableProvider = Provider<bool>((ref) {
  return ref.watch(featureFlagsProvider).isFirebaseConfigured;
});

final remoteSyncAvailableProvider = Provider<bool>((ref) {
  final flags = ref.watch(featureFlagsProvider);
  return flags.isFirebaseConfigured && flags.enableRemoteSync;
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
