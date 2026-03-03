import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { system, light, dark }

const _themeModePrefKey = 'theme_mode';

final appThemeProvider = Provider<AppTheme>((ref) => AppTheme());

final themeModeProvider = StateNotifierProvider<ThemeModeController, ThemeMode>((
  ref,
) {
  return ThemeModeController()..load();
});

final appThemeModeProvider = Provider<AppThemeMode>((ref) {
  final mode = ref.watch(themeModeProvider);
  switch (mode) {
    case ThemeMode.light:
      return AppThemeMode.light;
    case ThemeMode.dark:
      return AppThemeMode.dark;
    case ThemeMode.system:
      return AppThemeMode.system;
  }
});

class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController() : super(ThemeMode.system);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_themeModePrefKey);
    state = _fromStored(stored);
  }

  Future<void> setAppThemeMode(AppThemeMode mode) async {
    switch (mode) {
      case AppThemeMode.light:
        state = ThemeMode.light;
      case AppThemeMode.dark:
        state = ThemeMode.dark;
      case AppThemeMode.system:
        state = ThemeMode.system;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModePrefKey, mode.name);
  }

  ThemeMode _fromStored(String? value) {
    AppThemeMode? mode;
    for (final item in AppThemeMode.values) {
      if (item.name == value) {
        mode = item;
        break;
      }
    }
    if (mode == null) {
      return ThemeMode.system;
    }
    switch (mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}

class AppTheme {
  AppTheme();

  ThemeData get lightTheme => _buildTheme(Brightness.light);

  ThemeData get darkTheme => _buildTheme(Brightness.dark);

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme.fromSeed(
      brightness: brightness,
      seedColor: const Color(0xFF2C3E50),
      primary: isDark ? const Color(0xFF8EACCD) : const Color(0xFF2C3E50),
      surface: isDark ? const Color(0xFF1A1C1E) : const Color(0xFFF8FAFC),
      background: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
    );

    // Create a base text theme using a Serif font for body
    final serifTextTheme = GoogleFonts.crimsonTextTextTheme(
      Typography.englishLike2021,
    );

    // Create a sans-serif text theme for headings
    final sansSerifTextTheme = GoogleFonts.interTextTheme(
      Typography.englishLike2021,
    );

    // Merge them: display and title use sans-serif, body uses serif
    final customTextTheme = serifTextTheme
        .copyWith(
          displayLarge: sansSerifTextTheme.displayLarge,
          displayMedium: sansSerifTextTheme.displayMedium,
          displaySmall: sansSerifTextTheme.displaySmall,
          headlineLarge: sansSerifTextTheme.headlineLarge,
          headlineMedium: sansSerifTextTheme.headlineMedium,
          headlineSmall: sansSerifTextTheme.headlineSmall,
          titleLarge: sansSerifTextTheme.titleLarge,
          titleMedium: sansSerifTextTheme.titleMedium,
          titleSmall: sansSerifTextTheme.titleSmall,
          labelLarge: sansSerifTextTheme.labelLarge,
          labelMedium: sansSerifTextTheme.labelMedium,
          labelSmall: sansSerifTextTheme.labelSmall,
        )
        .apply(
          bodyColor: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
          displayColor: isDark ? Colors.white : const Color(0xFF0F172A),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: customTextTheme,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
          ),
        ),
        color: colorScheme.surface,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: isDark ? Colors.white : const Color(0xFF0F172A),
          letterSpacing: -0.5,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
