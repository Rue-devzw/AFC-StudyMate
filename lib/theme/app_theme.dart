import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { system, light, dark }
enum AppFontPack { classic, nunito, lora, merriweather, rubik }
enum AppBackgroundMode {
  trackDefault,
  dashboard,
  journal,
  sundaySchool,
  bible,
  discovery,
}

const _themeModePrefKey = 'theme_mode';
const _fontPackPrefKey = 'font_pack';
const _backgroundModePrefKey = 'background_mode';
const _lowResourcePrefKey = 'low_resource_mode';
const _cloudBackupPrefKey = 'cloud_backup_enabled';

final appThemeProvider = Provider<AppTheme>((ref) {
  final fontPack = ref.watch(appFontPackProvider);
  return AppTheme(fontPack: fontPack);
});

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

final appFontPackProvider =
    StateNotifierProvider<AppFontPackController, AppFontPack>((ref) {
      return AppFontPackController()..load();
    });

final appBackgroundModeProvider =
    StateNotifierProvider<AppBackgroundModeController, AppBackgroundMode>((
      ref,
    ) {
      return AppBackgroundModeController()..load();
    });

final lowResourceModeProvider =
    StateNotifierProvider<BoolPrefController, bool>((ref) {
      return BoolPrefController(key: _lowResourcePrefKey, defaultValue: false)
        ..load();
    });

final cloudBackupEnabledProvider =
    StateNotifierProvider<BoolPrefController, bool>((ref) {
      return BoolPrefController(key: _cloudBackupPrefKey, defaultValue: false)
        ..load();
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

class AppFontPackController extends StateNotifier<AppFontPack> {
  AppFontPackController() : super(AppFontPack.classic);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_fontPackPrefKey);
    state = _fromStored(stored);
  }

  Future<void> setFontPack(AppFontPack pack) async {
    state = pack;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fontPackPrefKey, pack.name);
  }

  AppFontPack _fromStored(String? value) {
    for (final pack in AppFontPack.values) {
      if (pack.name == value) {
        return pack;
      }
    }
    return AppFontPack.classic;
  }
}

class AppBackgroundModeController extends StateNotifier<AppBackgroundMode> {
  AppBackgroundModeController() : super(AppBackgroundMode.trackDefault);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_backgroundModePrefKey);
    state = _fromStored(stored);
  }

  Future<void> setBackgroundMode(AppBackgroundMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_backgroundModePrefKey, mode.name);
  }

  AppBackgroundMode _fromStored(String? value) {
    for (final mode in AppBackgroundMode.values) {
      if (mode.name == value) {
        return mode;
      }
    }
    return AppBackgroundMode.trackDefault;
  }
}

class BoolPrefController extends StateNotifier<bool> {
  BoolPrefController({required this.key, required this.defaultValue})
    : super(defaultValue);

  final String key;
  final bool defaultValue;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(key) ?? defaultValue;
  }

  Future<void> setValue(bool value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }
}

String appFontPackLabel(AppFontPack pack) {
  switch (pack) {
    case AppFontPack.classic:
      return 'Classic (Inter + Crimson)';
    case AppFontPack.nunito:
      return 'Nunito';
    case AppFontPack.lora:
      return 'Lora';
    case AppFontPack.merriweather:
      return 'Merriweather';
    case AppFontPack.rubik:
      return 'Rubik';
  }
}

String appBackgroundModeLabel(AppBackgroundMode mode) {
  switch (mode) {
    case AppBackgroundMode.trackDefault:
      return 'Track default';
    case AppBackgroundMode.dashboard:
      return 'Dashboard';
    case AppBackgroundMode.journal:
      return 'Journal';
    case AppBackgroundMode.sundaySchool:
      return 'Sunday School';
    case AppBackgroundMode.bible:
      return 'Bible';
    case AppBackgroundMode.discovery:
      return 'Discovery';
  }
}

class AppTheme {
  AppTheme({required this.fontPack});

  final AppFontPack fontPack;

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

    final customTextTheme = _buildTextTheme(isDark);

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

  TextTheme _buildTextTheme(bool isDark) {
    final bodyColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B);
    final displayColor = isDark ? Colors.white : const Color(0xFF0F172A);
    switch (fontPack) {
      case AppFontPack.classic:
        final serifTextTheme = GoogleFonts.crimsonTextTextTheme(
          Typography.englishLike2021,
        );
        final sansSerifTextTheme = GoogleFonts.interTextTheme(
          Typography.englishLike2021,
        );
        return serifTextTheme
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
            .apply(bodyColor: bodyColor, displayColor: displayColor);
      case AppFontPack.nunito:
        return GoogleFonts.nunitoTextTheme(
          Typography.englishLike2021,
        ).apply(bodyColor: bodyColor, displayColor: displayColor);
      case AppFontPack.lora:
        return GoogleFonts.loraTextTheme(
          Typography.englishLike2021,
        ).apply(bodyColor: bodyColor, displayColor: displayColor);
      case AppFontPack.merriweather:
        return GoogleFonts.merriweatherTextTheme(
          Typography.englishLike2021,
        ).apply(bodyColor: bodyColor, displayColor: displayColor);
      case AppFontPack.rubik:
        return GoogleFonts.rubikTextTheme(
          Typography.englishLike2021,
        ).apply(bodyColor: bodyColor, displayColor: displayColor);
    }
  }
}
