import 'package:afc_studymate/data/services/feature_flags_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

final firebaseRuntimeServiceProvider = Provider<FirebaseRuntimeService>((ref) {
  return FirebaseRuntimeService(
    flags: ref.read(featureFlagsProvider),
    logger: Logger(),
  );
});

class FirebaseRuntimeService {
  FirebaseRuntimeService({required this.flags, required this.logger});

  final FeatureFlags flags;
  final Logger logger;

  bool _attempted = false;
  bool _initialised = false;

  bool get isInitialised => _initialised;

  Future<bool> ensureInitialised() async {
    if (_attempted) {
      return _initialised;
    }
    _attempted = true;

    if (!flags.isFirebaseConfigured) {
      logger.i('Firebase not configured; running local-first mode.');
      return false;
    }

    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      _initialised = true;
      return true;
    } catch (error, stackTrace) {
      logger.w(
        'Firebase init failed; falling back to no-op adapters.',
        error: error,
        stackTrace: stackTrace,
      );
      _initialised = false;
      return false;
    }
  }
}
