import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'accessibility_preferences.dart';

typedef ThemeTextBuilder = TextTheme Function(
  AccessibilityPreferences preferences,
  Brightness brightness,
);

class AgeCohortThemeProfile {
  AgeCohortThemeProfile({
    required this.id,
    required this.label,
    required this.description,
    required this.iconScale,
    AccessibilityPreferences baseAccessibility =
        kBaseAccessibilityPreferences,
    AccessibilityPreferences? accessibilityOverrides,
    required Color seedColor,
    required Color contrastSeedColor,
    required Color lightSurface,
    required Color darkSurface,
    required ThemeTextBuilder textThemeBuilder,
    this.cohortKeywords = const [],
  })  : _seedColor = seedColor,
        _contrastSeedColor = contrastSeedColor,
        _lightSurface = lightSurface,
        _darkSurface = darkSurface,
        _textThemeBuilder = textThemeBuilder,
        accessibility =
            baseAccessibility.merge(accessibilityOverrides);

  final String id;
  final String label;
  final String description;
  final double iconScale;
  final AccessibilityPreferences accessibility;
  final List<String> cohortKeywords;

  final Color _seedColor;
  final Color _contrastSeedColor;
  final Color _lightSurface;
  final Color _darkSurface;
  final ThemeTextBuilder _textThemeBuilder;

  ThemeData toThemeData(Brightness brightness) {
    final textTheme = _textThemeBuilder(accessibility, brightness);
    final colorScheme = _buildColorScheme(brightness, accessibility);
    final iconSize = 24.0 * iconScale * accessibility.fontScale;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surface,
      textTheme: textTheme,
      iconTheme: IconThemeData(
        size: iconSize,
        color: colorScheme.primary,
      ),
      primaryIconTheme: IconThemeData(
        size: iconSize,
        color: colorScheme.onPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        centerTitle: true,
        titleTextStyle:
            textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: colorScheme.surface,
        textColor: colorScheme.onSurface,
        iconColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      cardTheme: CardTheme(
        color: colorScheme.surface,
        elevation: accessibility.highContrast ? 6 : 2,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: accessibility.highContrast
                ? colorScheme.outline
                : colorScheme.outlineVariant,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(textStyle: textTheme.labelLarge),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceVariant.withOpacity(0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
      focusColor: colorScheme.primary,
      splashColor: colorScheme.primary.withOpacity(0.1),
      highlightColor: colorScheme.primary.withOpacity(0.1),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        showUnselectedLabels: true,
        selectedIconTheme: IconThemeData(size: iconSize * 1.1),
        unselectedIconTheme: IconThemeData(size: iconSize * 0.95),
      ),
      navigationRailTheme: NavigationRailThemeData(
        selectedIconTheme: IconThemeData(size: iconSize * 1.1),
        unselectedIconTheme: IconThemeData(size: iconSize * 0.95),
        selectedLabelTextStyle: textTheme.labelLarge,
        unselectedLabelTextStyle:
            textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  ColorScheme _buildColorScheme(
    Brightness brightness,
    AccessibilityPreferences preferences,
  ) {
    final isDark = brightness == Brightness.dark;
    final seed = preferences.highContrast ? _contrastSeedColor : _seedColor;
    final surface = preferences.highContrast
        ? (isDark ? const Color(0xFF101010) : Colors.white)
        : (isDark ? _darkSurface : _lightSurface);

    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      surface: surface,
      brightness: brightness,
    );

    if (!preferences.highContrast) {
      return scheme;
    }

    return scheme.copyWith(
      surface: surface,
      background: surface,
      onSurface: isDark ? Colors.white : Colors.black,
      primary: isDark ? Colors.amberAccent : seed,
      onPrimary: isDark ? Colors.black : Colors.white,
      outline: isDark ? Colors.white70 : Colors.black54,
      outlineVariant: isDark ? Colors.white38 : Colors.black26,
    );
  }
}

TextTheme _composeTextTheme({
  required TextTheme body,
  required TextTheme display,
  required AccessibilityPreferences preferences,
  double bodyScale = 1.0,
  double headingScale = 1.0,
  double lineHeight = 1.5,
}) {
  final scaledBody =
      body.apply(fontSizeFactor: bodyScale * preferences.fontScale);
  final scaledDisplay =
      display.apply(fontSizeFactor: headingScale * preferences.fontScale);

  return scaledBody.copyWith(
    displayLarge: scaledDisplay.displayLarge,
    displayMedium: scaledDisplay.displayMedium,
    displaySmall: scaledDisplay.displaySmall,
    headlineLarge: scaledDisplay.headlineLarge,
    headlineMedium: scaledDisplay.headlineMedium,
    headlineSmall: scaledDisplay.headlineSmall,
    titleLarge: scaledDisplay.titleLarge ?? scaledBody.titleLarge,
    titleMedium: scaledDisplay.titleMedium ?? scaledBody.titleMedium,
    titleSmall: scaledDisplay.titleSmall ?? scaledBody.titleSmall,
    bodyLarge: scaledBody.bodyLarge?.copyWith(height: lineHeight),
    bodyMedium: scaledBody.bodyMedium?.copyWith(height: lineHeight),
    bodySmall: scaledBody.bodySmall?.copyWith(height: lineHeight),
    labelLarge: scaledBody.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    labelMedium: scaledBody.labelMedium?.copyWith(fontWeight: FontWeight.w600),
    labelSmall: scaledBody.labelSmall?.copyWith(fontWeight: FontWeight.w600),
  );
}

TextTheme _earlyLearnerTypography(
  AccessibilityPreferences preferences,
  Brightness brightness,
) {
  final playful = GoogleFonts.fredokaTextTheme();
  final display = GoogleFonts.baloo2TextTheme();
  final base = preferences.useDyslexiaFriendlyFonts
      ? GoogleFonts.atkinsonHyperlegibleTextTheme()
      : playful;
  return _composeTextTheme(
    body: base,
    display: display,
    preferences: preferences,
    bodyScale: 1.2,
    headingScale: 1.3,
    lineHeight: 1.6,
  );
}

TextTheme _youthTypography(
  AccessibilityPreferences preferences,
  Brightness brightness,
) {
  final base = preferences.useDyslexiaFriendlyFonts
      ? GoogleFonts.atkinsonHyperlegibleTextTheme()
      : GoogleFonts.lexendTextTheme();
  final display = GoogleFonts.spaceGroteskTextTheme();
  return _composeTextTheme(
    body: base,
    display: display,
    preferences: preferences,
    bodyScale: 1.1,
    headingScale: 1.15,
    lineHeight: 1.55,
  );
}

TextTheme _adultTypography(
  AccessibilityPreferences preferences,
  Brightness brightness,
) {
  final base = preferences.useDyslexiaFriendlyFonts
      ? GoogleFonts.atkinsonHyperlegibleTextTheme()
      : GoogleFonts.nunitoTextTheme();
  final display = GoogleFonts.sourceSerifProTextTheme();
  return _composeTextTheme(
    body: base,
    display: display,
    preferences: preferences,
    bodyScale: 1.05,
    headingScale: 1.1,
    lineHeight: 1.5,
  );
}

TextTheme _mentorTypography(
  AccessibilityPreferences preferences,
  Brightness brightness,
) {
  final base = GoogleFonts.atkinsonHyperlegibleTextTheme();
  final display = GoogleFonts.merriweatherTextTheme();
  return _composeTextTheme(
    body: base,
    display: display,
    preferences: preferences,
    bodyScale: 1.2,
    headingScale: 1.25,
    lineHeight: 1.65,
  );
}

final List<AgeCohortThemeProfile> kAgeCohortThemeProfiles = [
  AgeCohortThemeProfile(
    id: 'early-learners',
    label: 'Early Learners (5-8)',
    description:
        'Playful typography, bright colors, and generous sizing for new readers.',
    iconScale: 1.35,
    accessibilityOverrides: kReadableAccessibilityPreferences,
    seedColor: const Color(0xFF3DDC97),
    contrastSeedColor: const Color(0xFF0B8043),
    lightSurface: const Color(0xFFF0FFFA),
    darkSurface: const Color(0xFF0C1A13),
    textThemeBuilder: _earlyLearnerTypography,
    cohortKeywords: const ['kid', 'child', 'junior', 'beginner', 'primary'],
  ),
  AgeCohortThemeProfile(
    id: 'youth',
    label: 'Youth & Teens',
    description:
        'Energetic palette with bold headings and supportive accessibility boosts.',
    iconScale: 1.2,
    accessibilityOverrides:
        kBaseAccessibilityPreferences.copyWith(fontScale: 1.1),
    seedColor: const Color(0xFF6750A4),
    contrastSeedColor: const Color(0xFF311B92),
    lightSurface: const Color(0xFFEFECFF),
    darkSurface: const Color(0xFF1B1535),
    textThemeBuilder: _youthTypography,
    cohortKeywords: const ['teen', 'youth', 'student', 'middle', 'intermediate'],
  ),
  AgeCohortThemeProfile(
    id: 'adults',
    label: 'Adults',
    description: 'Balanced contrast and comfortable typography for most readers.',
    iconScale: 1.0,
    accessibilityOverrides:
        kBaseAccessibilityPreferences.copyWith(fontScale: 1.05),
    seedColor: const Color(0xFF3F51B5),
    contrastSeedColor: const Color(0xFF1A237E),
    lightSurface: const Color(0xFFE8EAF6),
    darkSurface: const Color(0xFF12131F),
    textThemeBuilder: _adultTypography,
    cohortKeywords: const ['adult', 'general', 'discovery', 'answer', 'parent'],
  ),
  AgeCohortThemeProfile(
    id: 'mentors',
    label: 'Mentors & Seniors',
    description:
        'High-contrast palette with dyslexia-friendly fonts and large icons.',
    iconScale: 1.3,
    accessibilityOverrides: kHighContrastAccessibilityPreferences,
    seedColor: const Color(0xFF00696F),
    contrastSeedColor: const Color(0xFF004D40),
    lightSurface: const Color(0xFFE0F7FA),
    darkSurface: const Color(0xFF002021),
    textThemeBuilder: _mentorTypography,
    cohortKeywords: const ['mentor', 'teacher', 'leader', 'senior', 'facilitator'],
  ),
];

AgeCohortThemeProfile defaultThemeProfile() => kAgeCohortThemeProfiles[2];
