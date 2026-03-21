import 'package:afc_studymate/firebase_options.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final featureFlagsProvider = Provider<FeatureFlags>((ref) {
  return const FeatureFlags();
});

final cloudFeaturesAvailableProvider = Provider<bool>((ref) {
  return ref.watch(featureFlagsProvider).cloudFeaturesReady;
});

final remoteSyncAvailableProvider = Provider<bool>((ref) {
  return false;
});

class FeatureFlags {
  const FeatureFlags({
    this.enableAnalytics = const bool.fromEnvironment(
      'ENABLE_ANALYTICS',
    ),
    this.enablePushMessaging = const bool.fromEnvironment(
      'ENABLE_PUSH_MESSAGING',
    ),
    this.enableAccountCloud = const bool.fromEnvironment(
      'ENABLE_ACCOUNT_CLOUD',
      defaultValue: true,
    ),
  });

  final bool enableAnalytics;
  final bool enablePushMessaging;
  final bool enableAccountCloud;

  bool get isFirebaseConfigured => DefaultFirebaseOptions.configured;

  bool get cloudFeaturesReady => enableAccountCloud;
}
