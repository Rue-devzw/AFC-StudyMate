import 'package:afc_studymate/data/drift/app_database.dart';
import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/user_profile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provider for the current user's profile.
/// Uses 'local_user' as the default ID for this application.
final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  final db = ref.read(appDatabaseProvider);
  const userId = 'local_user';

  final profile = await db.getProfile(userId);

  // Return existing profile or a default one if it doesn't exist yet
  return profile ??
      const UserProfile(
        userId: userId,
        name: 'Learner',
        role: Role.learner,
        targetTrack: Track.search,
        translation: Translation.kjv,
      );
});

/// A simpler stream provider for profile updates if needed,
/// but FutureProvider + invalidate is often enough for this app's patterns.
