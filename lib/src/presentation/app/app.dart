import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../domain/accounts/entities.dart';
import '../providers.dart';
import '../home/home_screen.dart';
import '../accounts/profile_onboarding_screen.dart';
import '../theme/age_cohort_theme_profiles.dart';
import '../l10n/app_localizations.dart';
import '../l10n/l10n.dart';

class StudyMateApp extends ConsumerWidget {
  const StudyMateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeControllerProvider);
    final themeProfileAsync = ref.watch(themeProfileControllerProvider);
    ref.watch(meetingReminderCoordinatorProvider);

    final accountAsync = ref.watch(activeAccountProvider);

    return themeMode.when(
      data: (mode) => themeProfileAsync.when(
        data: (profile) => accountAsync.when(
          data: (account) => _buildApp(
            themeMode: mode,
            profile: profile,
            account: account,
          ),
          loading: () => _buildLoadingApp(mode, profile),
          error: (error, stack) => _buildErrorApp(mode, profile, error),
        ),
        loading: () => _buildLoadingApp(mode, defaultThemeProfile()),
        error: (error, stack) => _buildErrorApp(mode, defaultThemeProfile(), error),
      ),
      loading: () => _buildLoadingApp(ThemeMode.system, defaultThemeProfile()),
      error: (error, stack) =>
          _buildErrorApp(ThemeMode.system, defaultThemeProfile(), error),
    );
  }

  Widget _buildApp({
    required ThemeMode themeMode,
    required AgeCohortThemeProfile profile,
    required LocalAccount? account,
  }) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: profile.toThemeData(Brightness.light),
      darkTheme: profile.toThemeData(Brightness.dark),
      themeMode: themeMode,
      home: account == null
          ? const ProfileOnboardingScreen()
          : const HomeScreen(),
    );
  }

  Widget _buildLoadingApp(
    ThemeMode themeMode,
    AgeCohortThemeProfile profile,
  ) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: profile.toThemeData(Brightness.light),
      darkTheme: profile.toThemeData(Brightness.dark),
      themeMode: themeMode,
      home: const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildErrorApp(
    ThemeMode themeMode,
    AgeCohortThemeProfile profile,
    Object error,
  ) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: profile.toThemeData(Brightness.light),
      darkTheme: profile.toThemeData(Brightness.dark),
      themeMode: themeMode,
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: Text(context.l10n.appThemeLoadError('$error')),
          ),
        ),
      ),
    );
  }
}
