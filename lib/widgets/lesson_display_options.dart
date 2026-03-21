import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum LessonReadingFontStyle { serif, sans }

@immutable
class LessonReadingPreferences {
  const LessonReadingPreferences({
    required this.fontScale,
    required this.fontStyle,
  });

  final double fontScale;
  final LessonReadingFontStyle fontStyle;
}

final lessonReadingFontScaleProvider = StateProvider<double>((ref) => 1.0);

final lessonReadingFontStyleProvider = StateProvider<LessonReadingFontStyle>(
  (ref) => LessonReadingFontStyle.sans,
);

class LessonReadingScope extends InheritedWidget {
  const LessonReadingScope({
    required this.preferences,
    required super.child,
    super.key,
  });

  final LessonReadingPreferences preferences;

  static LessonReadingPreferences of(BuildContext context) {
    return maybeOf(context) ??
        const LessonReadingPreferences(
          fontScale: 1,
          fontStyle: LessonReadingFontStyle.sans,
        );
  }

  static LessonReadingPreferences? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<LessonReadingScope>()
        ?.preferences;
  }

  @override
  bool updateShouldNotify(LessonReadingScope oldWidget) {
    return preferences.fontScale != oldWidget.preferences.fontScale ||
        preferences.fontStyle != oldWidget.preferences.fontStyle;
  }
}

TextStyle lessonReadingTextStyle(
  BuildContext context, {
  TextStyle? baseStyle,
  double sizeFactor = 1,
}) {
  final preferences = LessonReadingScope.of(context);
  final fallback =
      Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6) ??
      const TextStyle(fontSize: 16, height: 1.6);
  final base = baseStyle ?? fallback;
  final scaled = base.copyWith(
    fontSize:
        (base.fontSize ?? fallback.fontSize ?? 16) *
        preferences.fontScale *
        sizeFactor,
  );

  return switch (preferences.fontStyle) {
    LessonReadingFontStyle.serif => GoogleFonts.merriweather(textStyle: scaled),
    LessonReadingFontStyle.sans => GoogleFonts.inter(textStyle: scaled),
  };
}

class LessonDisplayOptionsSheet extends StatefulWidget {
  const LessonDisplayOptionsSheet({
    required this.fontScale,
    required this.onFontScaleChanged,
    required this.fontStyle,
    required this.onFontStyleChanged,
    super.key,
  });

  final double fontScale;
  final ValueChanged<double> onFontScaleChanged;
  final LessonReadingFontStyle fontStyle;
  final ValueChanged<LessonReadingFontStyle> onFontStyleChanged;

  @override
  State<LessonDisplayOptionsSheet> createState() =>
      _LessonDisplayOptionsSheetState();
}

class _LessonDisplayOptionsSheetState extends State<LessonDisplayOptionsSheet> {
  late double _fontScale = widget.fontScale;
  late LessonReadingFontStyle _fontStyle = widget.fontStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          24,
          16,
          24,
          24 + mediaQuery.viewPadding.bottom,
        ),
        child: LessonReadingScope(
          preferences: LessonReadingPreferences(
            fontScale: _fontScale,
            fontStyle: _fontStyle,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Lesson reading controls',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Adjust lesson text for comfort and clarity while you read.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Font size',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Slider(
                value: _fontScale,
                min: 0.85,
                max: 1.45,
                divisions: 12,
                label: '${(_fontScale * 100).round()}%',
                onChanged: (value) {
                  setState(() => _fontScale = value);
                  widget.onFontScaleChanged(value);
                },
              ),
              const SizedBox(height: 12),
              Text(
                'Font style',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              SegmentedButton<LessonReadingFontStyle>(
                segments: const <ButtonSegment<LessonReadingFontStyle>>[
                  ButtonSegment(
                    value: LessonReadingFontStyle.serif,
                    label: Text('Serif'),
                  ),
                  ButtonSegment(
                    value: LessonReadingFontStyle.sans,
                    label: Text('Sans-serif'),
                  ),
                ],
                selected: <LessonReadingFontStyle>{_fontStyle},
                onSelectionChanged: (selection) {
                  final value = selection.first;
                  setState(() => _fontStyle = value);
                  widget.onFontStyleChanged(value);
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Preview',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: Builder(
                  builder: (context) => Text(
                    'Wisdom grows when we can read slowly, think clearly, and stay with the lesson long enough for it to shape us.',
                    style: lessonReadingTextStyle(
                      context,
                      baseStyle: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface,
                        height: 1.65,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
