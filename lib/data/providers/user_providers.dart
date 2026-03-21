import 'package:afc_studymate/data/drift/app_database.dart';
import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/user_profile.dart';
import 'package:afc_studymate/data/providers/app_refresh_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const userProfileUserId = 'local_user';

const defaultUserProfile = UserProfile(
  userId: userProfileUserId,
  name: 'Learner',
  role: Role.learner,
  targetTrack: Track.search,
  translation: Translation.kjv,
);

/// Provider for the current user's profile.
final userProfileRefreshTickProvider = StateProvider<int>((ref) => 0);

final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  ref.watch(userProfileRefreshTickProvider);
  ref.watch(appDataRefreshTickProvider);
  final db = ref.read(appDatabaseProvider);
  final profile = await db.getProfile(userProfileUserId);
  return profile ?? defaultUserProfile;
});

void triggerUserProfileRefresh(WidgetRef ref) {
  final notifier = ref.read(userProfileRefreshTickProvider.notifier);
  notifier.state = notifier.state + 1;
}
