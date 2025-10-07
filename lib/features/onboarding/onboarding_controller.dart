import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/drift/app_database.dart';
import '../../data/models/enums.dart';

final onboardingControllerProvider = StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
  return OnboardingController(database: ref.read(appDatabaseProvider));
});

class OnboardingState {
  const OnboardingState({
    this.role = Role.learner,
    this.track = Track.beginners,
    this.translation = Translation.kjv,
    this.sundayReminder = true,
    this.discoveryReminder = true,
    this.dailyReminder = true,
    this.completed = false,
  });

  final Role role;
  final Track track;
  final Translation translation;
  final bool sundayReminder;
  final bool discoveryReminder;
  final bool dailyReminder;
  final bool completed;

  OnboardingState copyWith({
    Role? role,
    Track? track,
    Translation? translation,
    bool? sundayReminder,
    bool? discoveryReminder,
    bool? dailyReminder,
    bool? completed,
  }) {
    return OnboardingState(
      role: role ?? this.role,
      track: track ?? this.track,
      translation: translation ?? this.translation,
      sundayReminder: sundayReminder ?? this.sundayReminder,
      discoveryReminder: discoveryReminder ?? this.discoveryReminder,
      dailyReminder: dailyReminder ?? this.dailyReminder,
      completed: completed ?? this.completed,
    );
  }
}

class OnboardingController extends StateNotifier<OnboardingState> {
  OnboardingController({required this.database}) : super(const OnboardingState());

  final AppDatabase database;

  void updateRole(Role role) => state = state.copyWith(role: role);

  void updateTrack(Track track) => state = state.copyWith(track: track);

  void updateTranslation(Translation translation) => state = state.copyWith(translation: translation);

  void toggleSunday(bool value) => state = state.copyWith(sundayReminder: value);

  void toggleDiscovery(bool value) => state = state.copyWith(discoveryReminder: value);

  void toggleDaily(bool value) => state = state.copyWith(dailyReminder: value);

  Future<void> complete() async {
    await database.upsertSetting('role', state.role.name);
    await database.upsertSetting('track', state.track.name);
    await database.upsertSetting('translation', state.translation.name);
    state = state.copyWith(completed: true);
  }
}
