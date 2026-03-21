import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { system, light, dark }

enum AppFontPack {
  classic,
  nunito,
  lora,
  merriweather,
  rubik,
  lexend,
  poppins,
  sourceSans,
  workSans,
}

enum AppBackgroundMode {
  trackDefault,
  followGlobal,
  dashboard,
  journal,
  sundaySchool,
  bible,
  discovery,
  sereneSunrise,
  meadowBloom,
  oceanDawn,
  twilightConstellation,
  ivoryCanvas,
  skyBlue,
  meadowGreen,
  roseBlush,
  midnightSlate,
}

enum AppBackgroundSlot {
  today,
  journal,
  bible,
  discovery,
  discoveryArchive,
  sundaySchool,
  classRoster,
  teacherGuides,
  memoryVerse,
  profile,
  settings,
}

enum AppAppearancePreset { kids, youth, classic, accessible }

enum AppBackgroundTone { dark, light }

const _themeModePrefKey = 'theme_mode';
const _fontPackPrefKey = 'font_pack';
const _backgroundModePrefKey = 'background_mode';
const _screenBackgroundPrefPrefix = 'screen_background_';
const _lowResourcePrefKey = 'low_resource_mode';
const _cloudBackupPrefKey = 'cloud_backup_enabled';

const customizableBackgroundSlots = <AppBackgroundSlot>[
  AppBackgroundSlot.today,
  AppBackgroundSlot.journal,
  AppBackgroundSlot.bible,
  AppBackgroundSlot.discovery,
  AppBackgroundSlot.discoveryArchive,
  AppBackgroundSlot.sundaySchool,
  AppBackgroundSlot.classRoster,
  AppBackgroundSlot.teacherGuides,
  AppBackgroundSlot.memoryVerse,
  AppBackgroundSlot.profile,
  AppBackgroundSlot.settings,
];

class AppAppearancePresetConfig {
  const AppAppearancePresetConfig({
    required this.themeMode,
    required this.fontPack,
    required this.globalBackgroundMode,
    required this.lowResourceMode,
    this.screenOverrides = const <AppBackgroundSlot, AppBackgroundMode>{},
  });

  final AppThemeMode themeMode;
  final AppFontPack fontPack;
  final AppBackgroundMode globalBackgroundMode;
  final bool lowResourceMode;
  final Map<AppBackgroundSlot, AppBackgroundMode> screenOverrides;
}

final appThemeProvider = Provider<AppTheme>((ref) {
  final fontPack = ref.watch(appFontPackProvider);
  return AppTheme(fontPack: fontPack);
});

final themeModeProvider = StateNotifierProvider<ThemeModeController, ThemeMode>(
  (
    ref,
  ) {
    return ThemeModeController()..load();
  },
);

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

final StateNotifierProviderFamily<
  ScreenBackgroundModeController,
  AppBackgroundMode,
  AppBackgroundSlot
>
screenBackgroundModeProvider =
    StateNotifierProvider.family<
      ScreenBackgroundModeController,
      AppBackgroundMode,
      AppBackgroundSlot
    >((ref, slot) {
      return ScreenBackgroundModeController(slot: slot)..load();
    });

final lowResourceModeProvider = StateNotifierProvider<BoolPrefController, bool>(
  (ref) {
    return BoolPrefController(key: _lowResourcePrefKey, defaultValue: false)
      ..load();
  },
);

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
    state = _backgroundModeFromStored(
      stored,
      fallback: AppBackgroundMode.trackDefault,
    );
  }

  Future<void> setBackgroundMode(AppBackgroundMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_backgroundModePrefKey, mode.name);
  }
}

class ScreenBackgroundModeController extends StateNotifier<AppBackgroundMode> {
  ScreenBackgroundModeController({required this.slot})
    : super(AppBackgroundMode.followGlobal);

  final AppBackgroundSlot slot;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_screenBackgroundPrefKey(slot));
    state = _backgroundModeFromStored(
      stored,
      fallback: AppBackgroundMode.followGlobal,
    );
  }

  Future<void> setBackgroundMode(AppBackgroundMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_screenBackgroundPrefKey(slot), mode.name);
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

AppBackgroundMode _backgroundModeFromStored(
  String? value, {
  required AppBackgroundMode fallback,
}) {
  for (final mode in AppBackgroundMode.values) {
    if (mode.name == value) {
      return mode;
    }
  }
  return fallback;
}

String _screenBackgroundPrefKey(AppBackgroundSlot slot) =>
    '$_screenBackgroundPrefPrefix${slot.name}';

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
    case AppFontPack.lexend:
      return 'Lexend';
    case AppFontPack.poppins:
      return 'Poppins';
    case AppFontPack.sourceSans:
      return 'Source Sans 3';
    case AppFontPack.workSans:
      return 'Work Sans';
  }
}

String appBackgroundModeLabel(
  AppBackgroundMode mode, {
  bool forScreenOverride = false,
}) {
  switch (mode) {
    case AppBackgroundMode.trackDefault:
      return forScreenOverride ? 'Screen default' : 'Screen defaults';
    case AppBackgroundMode.followGlobal:
      return 'Use global setting';
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
    case AppBackgroundMode.sereneSunrise:
      return 'Serene Sunrise';
    case AppBackgroundMode.meadowBloom:
      return 'Meadow Bloom';
    case AppBackgroundMode.oceanDawn:
      return 'Ocean Dawn';
    case AppBackgroundMode.twilightConstellation:
      return 'Twilight Constellation';
    case AppBackgroundMode.ivoryCanvas:
      return 'Ivory Canvas';
    case AppBackgroundMode.skyBlue:
      return 'Sky Blue';
    case AppBackgroundMode.meadowGreen:
      return 'Meadow Green';
    case AppBackgroundMode.roseBlush:
      return 'Rose Blush';
    case AppBackgroundMode.midnightSlate:
      return 'Midnight Slate';
  }
}

String appBackgroundSlotLabel(AppBackgroundSlot slot) {
  switch (slot) {
    case AppBackgroundSlot.today:
      return 'Today';
    case AppBackgroundSlot.journal:
      return 'Journal';
    case AppBackgroundSlot.bible:
      return 'Bible';
    case AppBackgroundSlot.discovery:
      return 'Discovery';
    case AppBackgroundSlot.discoveryArchive:
      return 'Discovery Archive';
    case AppBackgroundSlot.sundaySchool:
      return 'Sunday School';
    case AppBackgroundSlot.classRoster:
      return 'Class Roster';
    case AppBackgroundSlot.teacherGuides:
      return 'Teacher Guides';
    case AppBackgroundSlot.memoryVerse:
      return 'Memory Verse';
    case AppBackgroundSlot.profile:
      return 'Profile';
    case AppBackgroundSlot.settings:
      return 'Settings';
  }
}

String appAppearancePresetLabel(AppAppearancePreset preset) {
  switch (preset) {
    case AppAppearancePreset.kids:
      return 'Kids';
    case AppAppearancePreset.youth:
      return 'Youth';
    case AppAppearancePreset.classic:
      return 'Classic';
    case AppAppearancePreset.accessible:
      return 'Accessible';
  }
}

String appAppearancePresetDescription(AppAppearancePreset preset) {
  switch (preset) {
    case AppAppearancePreset.kids:
      return 'Bright, cheerful, and easy for children to explore.';
    case AppAppearancePreset.youth:
      return 'Fresh contrast, modern fonts, and energetic screen styling.';
    case AppAppearancePreset.classic:
      return 'Warm traditional reading tones with a timeless feel.';
    case AppAppearancePreset.accessible:
      return 'Cleaner colors and highly readable text for easy viewing.';
  }
}

AppAppearancePresetConfig appAppearancePresetConfig(
  AppAppearancePreset preset,
) {
  switch (preset) {
    case AppAppearancePreset.kids:
      return const AppAppearancePresetConfig(
        themeMode: AppThemeMode.light,
        fontPack: AppFontPack.nunito,
        globalBackgroundMode: AppBackgroundMode.sereneSunrise,
        lowResourceMode: false,
        screenOverrides: <AppBackgroundSlot, AppBackgroundMode>{
          AppBackgroundSlot.today: AppBackgroundMode.sereneSunrise,
          AppBackgroundSlot.journal: AppBackgroundMode.roseBlush,
          AppBackgroundSlot.bible: AppBackgroundMode.ivoryCanvas,
          AppBackgroundSlot.discovery: AppBackgroundMode.skyBlue,
          AppBackgroundSlot.discoveryArchive: AppBackgroundMode.meadowBloom,
          AppBackgroundSlot.sundaySchool: AppBackgroundMode.meadowBloom,
          AppBackgroundSlot.classRoster: AppBackgroundMode.skyBlue,
          AppBackgroundSlot.teacherGuides: AppBackgroundMode.sereneSunrise,
          AppBackgroundSlot.memoryVerse: AppBackgroundMode.meadowGreen,
          AppBackgroundSlot.profile: AppBackgroundMode.roseBlush,
          AppBackgroundSlot.settings: AppBackgroundMode.ivoryCanvas,
        },
      );
    case AppAppearancePreset.youth:
      return const AppAppearancePresetConfig(
        themeMode: AppThemeMode.dark,
        fontPack: AppFontPack.lexend,
        globalBackgroundMode: AppBackgroundMode.oceanDawn,
        lowResourceMode: false,
        screenOverrides: <AppBackgroundSlot, AppBackgroundMode>{
          AppBackgroundSlot.today: AppBackgroundMode.twilightConstellation,
          AppBackgroundSlot.journal: AppBackgroundMode.oceanDawn,
          AppBackgroundSlot.bible: AppBackgroundMode.midnightSlate,
          AppBackgroundSlot.discovery: AppBackgroundMode.sereneSunrise,
          AppBackgroundSlot.discoveryArchive:
              AppBackgroundMode.twilightConstellation,
          AppBackgroundSlot.sundaySchool: AppBackgroundMode.meadowGreen,
          AppBackgroundSlot.classRoster: AppBackgroundMode.midnightSlate,
          AppBackgroundSlot.teacherGuides: AppBackgroundMode.oceanDawn,
          AppBackgroundSlot.memoryVerse:
              AppBackgroundMode.twilightConstellation,
          AppBackgroundSlot.profile: AppBackgroundMode.oceanDawn,
          AppBackgroundSlot.settings: AppBackgroundMode.midnightSlate,
        },
      );
    case AppAppearancePreset.classic:
      return const AppAppearancePresetConfig(
        themeMode: AppThemeMode.light,
        fontPack: AppFontPack.classic,
        globalBackgroundMode: AppBackgroundMode.ivoryCanvas,
        lowResourceMode: false,
        screenOverrides: <AppBackgroundSlot, AppBackgroundMode>{
          AppBackgroundSlot.today: AppBackgroundMode.ivoryCanvas,
          AppBackgroundSlot.journal: AppBackgroundMode.journal,
          AppBackgroundSlot.bible: AppBackgroundMode.bible,
          AppBackgroundSlot.discovery: AppBackgroundMode.discovery,
          AppBackgroundSlot.discoveryArchive: AppBackgroundMode.ivoryCanvas,
          AppBackgroundSlot.sundaySchool: AppBackgroundMode.sundaySchool,
          AppBackgroundSlot.classRoster: AppBackgroundMode.ivoryCanvas,
          AppBackgroundSlot.teacherGuides: AppBackgroundMode.journal,
          AppBackgroundSlot.memoryVerse: AppBackgroundMode.ivoryCanvas,
          AppBackgroundSlot.profile: AppBackgroundMode.journal,
          AppBackgroundSlot.settings: AppBackgroundMode.ivoryCanvas,
        },
      );
    case AppAppearancePreset.accessible:
      return const AppAppearancePresetConfig(
        themeMode: AppThemeMode.light,
        fontPack: AppFontPack.sourceSans,
        globalBackgroundMode: AppBackgroundMode.skyBlue,
        lowResourceMode: false,
        screenOverrides: <AppBackgroundSlot, AppBackgroundMode>{
          AppBackgroundSlot.today: AppBackgroundMode.skyBlue,
          AppBackgroundSlot.journal: AppBackgroundMode.ivoryCanvas,
          AppBackgroundSlot.bible: AppBackgroundMode.ivoryCanvas,
          AppBackgroundSlot.discovery: AppBackgroundMode.meadowGreen,
          AppBackgroundSlot.discoveryArchive: AppBackgroundMode.skyBlue,
          AppBackgroundSlot.sundaySchool: AppBackgroundMode.meadowGreen,
          AppBackgroundSlot.classRoster: AppBackgroundMode.skyBlue,
          AppBackgroundSlot.teacherGuides: AppBackgroundMode.ivoryCanvas,
          AppBackgroundSlot.memoryVerse: AppBackgroundMode.ivoryCanvas,
          AppBackgroundSlot.profile: AppBackgroundMode.skyBlue,
          AppBackgroundSlot.settings: AppBackgroundMode.ivoryCanvas,
        },
      );
  }
}

bool matchesAppearancePreset({
  required AppAppearancePreset preset,
  required AppThemeMode themeMode,
  required AppFontPack fontPack,
  required AppBackgroundMode globalBackgroundMode,
  required bool lowResourceMode,
  required Map<AppBackgroundSlot, AppBackgroundMode> screenBackgrounds,
}) {
  final config = appAppearancePresetConfig(preset);
  if (themeMode != config.themeMode ||
      fontPack != config.fontPack ||
      globalBackgroundMode != config.globalBackgroundMode ||
      lowResourceMode != config.lowResourceMode) {
    return false;
  }
  for (final slot in customizableBackgroundSlots) {
    if (screenBackgrounds[slot] != config.screenOverrides[slot]) {
      return false;
    }
  }
  return true;
}

class AppBackgroundConfig {
  const AppBackgroundConfig({
    required this.tone,
    required this.baseColors,
    required this.overlayColors,
    this.assetPath,
    this.baseStops,
    this.overlayStops,
  });

  final AppBackgroundTone tone;
  final String? assetPath;
  final List<Color> baseColors;
  final List<Color> overlayColors;
  final List<double>? baseStops;
  final List<double>? overlayStops;

  bool get usesImage => assetPath != null;
}

AppBackgroundConfig resolveAppBackgroundConfig({
  required String fallbackAsset,
  required AppBackgroundMode globalMode,
  required AppBackgroundMode screenMode,
}) {
  final effectiveMode = screenMode == AppBackgroundMode.followGlobal
      ? (globalMode == AppBackgroundMode.followGlobal
            ? AppBackgroundMode.trackDefault
            : globalMode)
      : screenMode;
  return appBackgroundConfigForMode(
    effectiveMode,
    fallbackAsset: fallbackAsset,
  );
}

AppBackgroundConfig appBackgroundConfigForMode(
  AppBackgroundMode mode, {
  required String fallbackAsset,
}) {
  switch (mode) {
    case AppBackgroundMode.trackDefault:
      return const AppBackgroundConfig(
        tone: AppBackgroundTone.dark,
        baseColors: <Color>[
          Color(0xFF182332),
          Color(0xFF101826),
          Color(0xFF090F1B),
        ],
        overlayColors: <Color>[
          Color(0x33121822),
          Color(0x80121822),
          Color(0xCC090F1B),
        ],
      ).copyWithAsset(fallbackAsset);
    case AppBackgroundMode.followGlobal:
      return appBackgroundConfigForMode(
        AppBackgroundMode.trackDefault,
        fallbackAsset: fallbackAsset,
      );
    case AppBackgroundMode.dashboard:
      return const AppBackgroundConfig(
        tone: AppBackgroundTone.dark,
        assetPath: 'assets/images/bg_dashboard.png',
        baseColors: <Color>[
          Color(0xFF162030),
          Color(0xFF0C1522),
        ],
        overlayColors: <Color>[
          Color(0x1A000000),
          Color(0x80071018),
          Color(0xE6101620),
        ],
      );
    case AppBackgroundMode.journal:
      return const AppBackgroundConfig(
        tone: AppBackgroundTone.dark,
        assetPath: 'assets/images/bg_journal.png',
        baseColors: <Color>[
          Color(0xFF241C13),
          Color(0xFF130E08),
        ],
        overlayColors: <Color>[
          Color(0x14000000),
          Color(0x70110B06),
          Color(0xD90E0905),
        ],
      );
    case AppBackgroundMode.sundaySchool:
      return const AppBackgroundConfig(
        tone: AppBackgroundTone.dark,
        assetPath: 'assets/images/bg_sunday_school.png',
        baseColors: <Color>[
          Color(0xFF203224),
          Color(0xFF0F1912),
        ],
        overlayColors: <Color>[
          Color(0x14000000),
          Color(0x6B0E1A12),
          Color(0xD90A120D),
        ],
      );
    case AppBackgroundMode.bible:
      return const AppBackgroundConfig(
        tone: AppBackgroundTone.dark,
        assetPath: 'assets/images/bg_bible.png',
        baseColors: <Color>[
          Color(0xFF152130),
          Color(0xFF0A1119),
        ],
        overlayColors: <Color>[
          Color(0x0F000000),
          Color(0x66111A24),
          Color(0xDE0A1119),
        ],
      );
    case AppBackgroundMode.discovery:
      return const AppBackgroundConfig(
        tone: AppBackgroundTone.dark,
        assetPath: 'assets/images/bg_discovery.png',
        baseColors: <Color>[
          Color(0xFF1E2E2A),
          Color(0xFF0E1414),
        ],
        overlayColors: <Color>[
          Color(0x12000000),
          Color(0x66111D1C),
          Color(0xDE090E11),
        ],
      );
    case AppBackgroundMode.sereneSunrise:
      return const AppBackgroundConfig(
        tone: AppBackgroundTone.light,
        assetPath: 'assets/images/backgrounds/bg_serene_sunrise.jpg',
        baseColors: <Color>[
          Color(0xFFF4D2B0),
          Color(0xFFDEA87B),
        ],
        overlayColors: <Color>[
          Color(0x12FFFFFF),
          Color(0x7A6A3726),
          Color(0xD9612E24),
        ],
      );
    case AppBackgroundMode.meadowBloom:
      return const AppBackgroundConfig(
        tone: AppBackgroundTone.light,
        assetPath: 'assets/images/backgrounds/bg_meadow_bloom.jpg',
        baseColors: <Color>[
          Color(0xFFCFE7CC),
          Color(0xFF81AA6D),
        ],
        overlayColors: <Color>[
          Color(0x0FFFFFFF),
          Color(0x6B27412D),
          Color(0xD918231A),
        ],
      );
    case AppBackgroundMode.oceanDawn:
      return const AppBackgroundConfig(
        tone: AppBackgroundTone.light,
        assetPath: 'assets/images/backgrounds/bg_ocean_dawn.jpg',
        baseColors: <Color>[
          Color(0xFFCFE2EE),
          Color(0xFF507A99),
        ],
        overlayColors: <Color>[
          Color(0x0FFFFFFF),
          Color(0x5C203952),
          Color(0xD8162232),
        ],
      );
    case AppBackgroundMode.twilightConstellation:
      return const AppBackgroundConfig(
        tone: AppBackgroundTone.dark,
        assetPath: 'assets/images/backgrounds/bg_twilight_constellation.jpg',
        baseColors: <Color>[
          Color(0xFF2F3764),
          Color(0xFF130E2A),
        ],
        overlayColors: <Color>[
          Color(0x0FFFFFFF),
          Color(0x52181439),
          Color(0xDE090816),
        ],
      );
    case AppBackgroundMode.ivoryCanvas:
      return const AppBackgroundConfig(
        tone: AppBackgroundTone.light,
        baseColors: <Color>[
          Color(0xFFF3EAD8),
          Color(0xFFE8DDC7),
          Color(0xFFDCCEB4),
        ],
        baseStops: <double>[0, 0.55, 1],
        overlayColors: <Color>[
          Color(0x14FFFFFF),
          Color(0x22B79A6E),
          Color(0x383C2412),
        ],
      );
    case AppBackgroundMode.skyBlue:
      return const AppBackgroundConfig(
        tone: AppBackgroundTone.light,
        baseColors: <Color>[
          Color(0xFFD8ECF8),
          Color(0xFFACD3EF),
          Color(0xFF7CB6DE),
        ],
        baseStops: <double>[0, 0.52, 1],
        overlayColors: <Color>[
          Color(0x0FFFFFFF),
          Color(0x1F6B90B5),
          Color(0x36253B56),
        ],
      );
    case AppBackgroundMode.meadowGreen:
      return const AppBackgroundConfig(
        tone: AppBackgroundTone.light,
        baseColors: <Color>[
          Color(0xFFDCEBD7),
          Color(0xFFB9D3A7),
          Color(0xFF87A56D),
        ],
        baseStops: <double>[0, 0.45, 1],
        overlayColors: <Color>[
          Color(0x0FFFFFFF),
          Color(0x2A5B7450),
          Color(0x3B1F2D1C),
        ],
      );
    case AppBackgroundMode.roseBlush:
      return const AppBackgroundConfig(
        tone: AppBackgroundTone.light,
        baseColors: <Color>[
          Color(0xFFF2DEDB),
          Color(0xFFE7B8B1),
          Color(0xFFCF8B84),
        ],
        baseStops: <double>[0, 0.48, 1],
        overlayColors: <Color>[
          Color(0x0FFFFFFF),
          Color(0x237C4A49),
          Color(0x36291A22),
        ],
      );
    case AppBackgroundMode.midnightSlate:
      return const AppBackgroundConfig(
        tone: AppBackgroundTone.dark,
        baseColors: <Color>[
          Color(0xFF273447),
          Color(0xFF1A2432),
          Color(0xFF0F1621),
        ],
        baseStops: <double>[0, 0.48, 1],
        overlayColors: <Color>[
          Color(0x14000000),
          Color(0x26111924),
          Color(0x4C05070D),
        ],
      );
  }
}

extension on AppBackgroundConfig {
  AppBackgroundConfig copyWithAsset(String assetPath) {
    return AppBackgroundConfig(
      tone: tone,
      assetPath: assetPath,
      baseColors: baseColors,
      overlayColors: overlayColors,
      baseStops: baseStops,
      overlayStops: overlayStops,
    );
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
        titleTextStyle: customTextTheme.titleLarge?.copyWith(
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
          textStyle: customTextTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  TextTheme _buildTextTheme(bool isDark) {
    final bodyColor = isDark
        ? const Color(0xFFE2E8F0)
        : const Color(0xFF1E293B);
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
      case AppFontPack.lexend:
        return GoogleFonts.lexendTextTheme(
          Typography.englishLike2021,
        ).apply(bodyColor: bodyColor, displayColor: displayColor);
      case AppFontPack.poppins:
        return GoogleFonts.poppinsTextTheme(
          Typography.englishLike2021,
        ).apply(bodyColor: bodyColor, displayColor: displayColor);
      case AppFontPack.sourceSans:
        return GoogleFonts.sourceSans3TextTheme(
          Typography.englishLike2021,
        ).apply(bodyColor: bodyColor, displayColor: displayColor);
      case AppFontPack.workSans:
        return GoogleFonts.workSansTextTheme(
          Typography.englishLike2021,
        ).apply(bodyColor: bodyColor, displayColor: displayColor);
    }
  }
}
