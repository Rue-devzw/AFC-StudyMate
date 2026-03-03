import 'package:afc_studymate/data/drift/app_database.dart';
import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/user_profile.dart';
import 'package:afc_studymate/data/services/notification_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
      return OnboardingController(
        database: ref.read(appDatabaseProvider),
        notificationService: ref.read(notificationServiceProvider),
      );
    });

class OnboardingState {
  const OnboardingState({
    this.name = '',
    this.role = Role.learner,
    this.track = Track.beginners,
    this.translation = Translation.kjv,
    this.sundayReminder = true,
    this.discoveryReminder = true,
    this.dailyReminder = true,
    this.completed = false,
  });

  final String name;
  final Role role;
  final Track track;
  final Translation translation;
  final bool sundayReminder;
  final bool discoveryReminder;
  final bool dailyReminder;
  final bool completed;

  OnboardingState copyWith({
    String? name,
    Role? role,
    Track? track,
    Translation? translation,
    bool? sundayReminder,
    bool? discoveryReminder,
    bool? dailyReminder,
    bool? completed,
  }) {
    return OnboardingState(
      name: name ?? this.name,
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
  OnboardingController({
    required this.database,
    required this.notificationService,
  }) : super(const OnboardingState());

  final AppDatabase database;
  final NotificationService notificationService;

  void updateName(String name) => state = state.copyWith(name: name);

  void updateRole(Role role) => state = state.copyWith(role: role);

  void updateTrack(Track track) => state = state.copyWith(track: track);

  void updateTranslation(Translation translation) =>
      state = state.copyWith(translation: translation);

  void toggleSunday(bool value) =>
      state = state.copyWith(sundayReminder: value);

  void toggleDiscovery(bool value) =>
      state = state.copyWith(discoveryReminder: value);

  void toggleDaily(bool value) => state = state.copyWith(dailyReminder: value);

  Future<void> complete() async {
    final profile = UserProfile(
      userId: 'local_user',
      name: state.name.isEmpty ? 'Learner' : state.name,
      role: state.role,
      targetTrack: state.track,
      translation: state.translation,
    );
    await database.upsertProfile(profile);

    // Also keep loose settings for legacy/compatibility if needed
    await database.upsertSetting('role', state.role.name);
    await database.upsertSetting('track', state.track.name);
    await database.upsertSetting('translation', state.translation.name);
    await database.upsertSetting(
      'daily_reminder_enabled',
      state.dailyReminder.toString(),
    );
    await database.upsertSetting(
      'sunday_reminder_enabled',
      state.sundayReminder.toString(),
    );
    await database.upsertSetting(
      'discovery_reminder_enabled',
      state.discoveryReminder.toString(),
    );

    final hasAnyReminder =
        state.dailyReminder || state.sundayReminder || state.discoveryReminder;
    if (hasAnyReminder) {
      final granted = await notificationService.requestPermission();
      if (granted) {
        if (state.dailyReminder || state.discoveryReminder) {
          await notificationService.scheduleDaily(hour: 6, minute: 0);
        } else {
          await notificationService.cancelDaily();
        }
        if (state.sundayReminder) {
          await notificationService.scheduleWeeklySundayReminder(
            hour: 8,
            minute: 0,
          );
        } else {
          await notificationService.cancelWeeklySundayReminder();
        }
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCompletedSetup', true);

    state = state.copyWith(completed: true);
  }
}
