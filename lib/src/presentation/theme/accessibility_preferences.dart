import 'package:flutter/foundation.dart';

@immutable
class AccessibilityPreferences {
  const AccessibilityPreferences({
    this.fontScale = 1.0,
    this.useDyslexiaFriendlyFonts = false,
    this.highContrast = false,
  });

  final double fontScale;
  final bool useDyslexiaFriendlyFonts;
  final bool highContrast;

  AccessibilityPreferences merge(AccessibilityPreferences? overrides) {
    if (overrides == null) {
      return this;
    }
    return AccessibilityPreferences(
      fontScale: fontScale * overrides.fontScale,
      useDyslexiaFriendlyFonts:
          useDyslexiaFriendlyFonts || overrides.useDyslexiaFriendlyFonts,
      highContrast: highContrast || overrides.highContrast,
    );
  }

  AccessibilityPreferences copyWith({
    double? fontScale,
    bool? useDyslexiaFriendlyFonts,
    bool? highContrast,
  }) {
    return AccessibilityPreferences(
      fontScale: fontScale ?? this.fontScale,
      useDyslexiaFriendlyFonts:
          useDyslexiaFriendlyFonts ?? this.useDyslexiaFriendlyFonts,
      highContrast: highContrast ?? this.highContrast,
    );
  }
}

const AccessibilityPreferences kBaseAccessibilityPreferences =
    AccessibilityPreferences();

const AccessibilityPreferences kReadableAccessibilityPreferences =
    AccessibilityPreferences(fontScale: 1.1, useDyslexiaFriendlyFonts: true);

const AccessibilityPreferences kHighContrastAccessibilityPreferences =
    AccessibilityPreferences(fontScale: 1.2, highContrast: true);
