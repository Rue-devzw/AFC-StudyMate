import 'dart:ui';

import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/theme/app_theme.dart';
import 'package:afc_studymate/widgets/drop_cap_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PremiumSurfacePalette {
  const PremiumSurfacePalette({
    required this.primaryText,
    required this.secondaryText,
    required this.tertiaryText,
    required this.icon,
    required this.divider,
    required this.cardBaseColor,
    required this.cardOpacity,
    required this.borderBaseColor,
    required this.borderOpacity,
    required this.inputFill,
    required this.dropdownBackground,
    required this.shadowColor,
    required this.backdropPrimaryText,
    required this.backdropSecondaryText,
    required this.backdropTertiaryText,
    required this.backdropIcon,
    required this.backdropDivider,
  });

  final Color primaryText;
  final Color secondaryText;
  final Color tertiaryText;
  final Color icon;
  final Color divider;
  final Color cardBaseColor;
  final double cardOpacity;
  final Color borderBaseColor;
  final double borderOpacity;
  final Color inputFill;
  final Color dropdownBackground;
  final Color shadowColor;
  final Color backdropPrimaryText;
  final Color backdropSecondaryText;
  final Color backdropTertiaryText;
  final Color backdropIcon;
  final Color backdropDivider;

  bool get usesDarkCardSurfaces => cardBaseColor.computeLuminance() < 0.2;
}

PremiumSurfacePalette premiumSurfacePaletteForBackground(
  AppBackgroundConfig config, {
  required bool lowResourceMode,
}) {
  if (lowResourceMode || config.tone == AppBackgroundTone.dark) {
    return const PremiumSurfacePalette(
      primaryText: Colors.white,
      secondaryText: Color(0xCCFFFFFF),
      tertiaryText: Color(0x99FFFFFF),
      icon: Color(0xCCFFFFFF),
      divider: Color(0x1AFFFFFF),
      cardBaseColor: Colors.white,
      cardOpacity: 0.14,
      borderBaseColor: Colors.white,
      borderOpacity: 0.22,
      inputFill: Color(0x14FFFFFF),
      dropdownBackground: Color(0xFF1C1C1E),
      shadowColor: Color(0x2D000000),
      backdropPrimaryText: Colors.white,
      backdropSecondaryText: Color(0xD9FFFFFF),
      backdropTertiaryText: Color(0xA6FFFFFF),
      backdropIcon: Color(0xE6FFFFFF),
      backdropDivider: Color(0x33FFFFFF),
    );
  }
  return const PremiumSurfacePalette(
    primaryText: Colors.white,
    secondaryText: Color(0xF0FFFFFF),
    tertiaryText: Color(0xB3FFFFFF),
    icon: Color(0xE6FFFFFF),
    divider: Color(0x24FFFFFF),
    cardBaseColor: Color(0xFF101722),
    cardOpacity: 0.56,
    borderBaseColor: Colors.white,
    borderOpacity: 0.16,
    inputFill: Color(0x66101722),
    dropdownBackground: Color(0xFF121926),
    shadowColor: Color(0x33000000),
    backdropPrimaryText: Color(0xFF263242),
    backdropSecondaryText: Color(0xCC263242),
    backdropTertiaryText: Color(0x99263242),
    backdropIcon: Color(0xCC263242),
    backdropDivider: Color(0x3D263242),
  );
}

class PremiumSurfaceScope extends InheritedWidget {
  const PremiumSurfaceScope({
    required this.palette,
    required super.child,
    super.key,
  });

  final PremiumSurfacePalette palette;

  static PremiumSurfacePalette of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<PremiumSurfaceScope>();
    return scope?.palette ??
        const PremiumSurfacePalette(
          primaryText: Colors.white,
          secondaryText: Color(0xCCFFFFFF),
          tertiaryText: Color(0x99FFFFFF),
          icon: Color(0xCCFFFFFF),
          divider: Color(0x1AFFFFFF),
          cardBaseColor: Colors.white,
          cardOpacity: 0.14,
          borderBaseColor: Colors.white,
          borderOpacity: 0.22,
          inputFill: Color(0x14FFFFFF),
          dropdownBackground: Color(0xFF1C1C1E),
          shadowColor: Color(0x2D000000),
          backdropPrimaryText: Colors.white,
          backdropSecondaryText: Color(0xD9FFFFFF),
          backdropTertiaryText: Color(0xA6FFFFFF),
          backdropIcon: Color(0xE6FFFFFF),
          backdropDivider: Color(0x33FFFFFF),
        );
  }

  @override
  bool updateShouldNotify(PremiumSurfaceScope oldWidget) {
    return palette != oldWidget.palette;
  }
}

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    super.key,
    this.padding,
    this.onTap,
    this.color,
    this.borderRadius,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(24);

    return Container(
      decoration: BoxDecoration(
        color: color ?? theme.colorScheme.surface,
        borderRadius: effectiveBorderRadius,
        border: Border.all(
          color: theme.brightness == Brightness.dark
              ? Colors.white10
              : Colors.black.withOpacity(0.05),
        ),
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveBorderRadius,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.variant = AppButtonVariant.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final AppButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        else if (icon != null)
          Icon(icon, size: 20),
        if (isLoading || icon != null) const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );

    ButtonStyle style;
    switch (variant) {
      case AppButtonVariant.primary:
        style = FilledButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        );
      case AppButtonVariant.secondary:
        style = FilledButton.styleFrom(
          backgroundColor: theme.colorScheme.secondaryContainer,
          foregroundColor: theme.colorScheme.onSecondaryContainer,
        );
      case AppButtonVariant.outline:
        style = OutlinedButton.styleFrom(
          side: BorderSide(color: theme.colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
    }

    final Widget button = variant == AppButtonVariant.outline
        ? OutlinedButton(
            onPressed: isLoading
                ? null
                : () {
                    HapticFeedback.lightImpact();
                    onPressed?.call();
                  },
            style: style,
            child: content,
          )
        : FilledButton(
            onPressed: isLoading
                ? null
                : () {
                    HapticFeedback.lightImpact();
                    onPressed?.call();
                  },
            style: style,
            child: content,
          );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, height: 56, child: button);
    }
    return SizedBox(height: 56, child: button);
  }
}

enum AppButtonVariant { primary, secondary, outline }

class AppSectionTitle extends StatelessWidget {
  const AppSectionTitle({
    required this.title,
    super.key,
    this.trailing,
  });

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.maxLines = 1,
    this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int maxLines;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      focusNode: focusNode,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 2,
          ),
        ),
      ),
    );
  }
}

class AppDropCapText extends StatelessWidget {
  const AppDropCapText({
    required this.text,
    super.key,
    this.style,
  });

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);

    // Provide a default serif style if not provided
    final textStyle =
        style ??
        theme.textTheme.bodyMedium?.copyWith(
          height: 1.6,
          fontSize: 18,
        );

    return DropCapText(
      text,
      style: textStyle,
      dropCapStyle: textStyle?.copyWith(
        fontSize: (textStyle.fontSize ?? 18) * 3.5,
        height: 1,
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
      textAlign: TextAlign.justify,
      dropCapPadding: const EdgeInsets.only(right: 8, bottom: 4),
    );
  }
}

class PremiumBackground extends StatelessWidget {
  const PremiumBackground({
    required this.config,
    super.key,
    this.lowResourceMode = false,
  });

  final AppBackgroundConfig config;
  final bool lowResourceMode;

  @override
  Widget build(BuildContext context) {
    if (lowResourceMode) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF17202A),
              Color(0xFF111827),
              Color(0xFF0B1020),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
      );
    }
    if (!config.usesImage) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: config.baseColors,
            stops: config.baseStops,
          ),
        ),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: config.baseColors,
              stops: config.baseStops,
            ),
          ),
        ),
        Image.asset(
          config.assetPath!,
          fit: BoxFit.cover,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: config.overlayColors,
              stops: config.overlayStops ?? const [0.0, 0.4, 1.0],
            ),
          ),
        ),
        if (config.tone == AppBackgroundTone.light)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x24060A12),
                  Color(0x70060A12),
                  Color(0xB3060A12),
                ],
                stops: [0.0, 0.45, 1.0],
              ),
            ),
          ),
      ],
    );
  }
}

class PremiumGlassCard extends StatelessWidget {
  const PremiumGlassCard({
    required this.child,
    super.key,
    this.padding,
    this.borderRadius,
    this.blur = 16.0,
    this.opacity = 0.15,
    this.borderOpacity = 0.3,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double blur;
  final double opacity;
  final double borderOpacity;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? BorderRadius.circular(24);
    final palette = PremiumSurfaceScope.of(context);
    final effectiveOpacity = palette.usesDarkCardSurfaces
        ? opacity.clamp(palette.cardOpacity, 0.72)
        : opacity;
    final effectiveBorderOpacity = palette.usesDarkCardSurfaces
        ? borderOpacity.clamp(palette.borderOpacity, 0.32)
        : borderOpacity;
    return ClipRRect(
      borderRadius: effectiveRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: palette.cardBaseColor.withOpacity(effectiveOpacity),
            borderRadius: effectiveRadius,
            border: Border.all(
              color: palette.borderBaseColor.withOpacity(
                effectiveBorderOpacity,
              ),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: palette.shadowColor,
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: padding ?? const EdgeInsets.all(24),
          child: child,
        ),
      ),
    );
  }
}

class PremiumTextField extends StatefulWidget {
  const PremiumTextField({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
    this.hint,
    this.keyboardType,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final String? hint;
  final TextInputType? keyboardType;

  @override
  State<PremiumTextField> createState() => _PremiumTextFieldState();
}

class _PremiumTextFieldState extends State<PremiumTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant PremiumTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = PremiumSurfaceScope.of(context);
    return PremiumGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              letterSpacing: 1.2,
              color: palette.secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            onChanged: widget.onChanged,
            keyboardType: widget.keyboardType,
            style: TextStyle(
              color: palette.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(color: palette.tertiaryText),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}

class PremiumBackgroundSlots {
  const PremiumBackgroundSlots._();

  static const AppBackgroundSlot today = AppBackgroundSlot.today;
  static const AppBackgroundSlot journal = AppBackgroundSlot.journal;
  static const AppBackgroundSlot bible = AppBackgroundSlot.bible;
  static const AppBackgroundSlot discovery = AppBackgroundSlot.discovery;
  static const AppBackgroundSlot discoveryArchive =
      AppBackgroundSlot.discoveryArchive;
  static const AppBackgroundSlot sundaySchool = AppBackgroundSlot.sundaySchool;
  static const AppBackgroundSlot classRoster = AppBackgroundSlot.classRoster;
  static const AppBackgroundSlot teacherGuides =
      AppBackgroundSlot.teacherGuides;
  static const AppBackgroundSlot memoryVerse = AppBackgroundSlot.memoryVerse;
  static const AppBackgroundSlot profile = AppBackgroundSlot.profile;
  static const AppBackgroundSlot settings = AppBackgroundSlot.settings;
}

class PremiumScaffold extends HookConsumerWidget {
  const PremiumScaffold({
    required this.body,
    required this.backgroundAsset,
    required this.backgroundSlot,
    super.key,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  final Widget body;
  final String backgroundAsset;
  final AppBackgroundSlot backgroundSlot;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalBackgroundMode = ref.watch(appBackgroundModeProvider);
    final screenBackgroundMode = ref.watch(
      screenBackgroundModeProvider(backgroundSlot),
    );
    final lowResourceMode = ref.watch(lowResourceModeProvider);
    final resolvedConfig = resolveAppBackgroundConfig(
      fallbackAsset: backgroundAsset,
      globalMode: globalBackgroundMode,
      screenMode: screenBackgroundMode,
    );
    final surfacePalette = premiumSurfacePaletteForBackground(
      resolvedConfig,
      lowResourceMode: lowResourceMode,
    );
    final topInset = appBar == null
        ? 0.0
        : MediaQuery.paddingOf(context).top + appBar!.preferredSize.height;
    return PremiumSurfaceScope(
      palette: surfacePalette,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: appBar,
        body: Stack(
          fit: StackFit.expand,
          children: [
            PremiumBackground(
              config: resolvedConfig,
              lowResourceMode: lowResourceMode,
            ),
            Padding(
              padding: EdgeInsets.only(top: topInset),
              child: body,
            ),
          ],
        ),
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}

const _baseBottomContentPadding = 120.0;

double standardBottomContentPadding(
  BuildContext context, {
  double extra = 0,
}) {
  return _baseBottomContentPadding +
      MediaQuery.paddingOf(context).bottom +
      extra;
}

double responsiveHorizontalPadding(
  BuildContext context, {
  double maxContentWidth = 860,
  double minPadding = 16,
}) {
  final width = MediaQuery.sizeOf(context).width;
  if (width <= maxContentWidth) {
    return minPadding;
  }
  return ((width - maxContentWidth) / 2).clamp(minPadding, 220);
}

extension TrackThemeExtension on Track {
  Color get color {
    switch (this) {
      case Track.discovery:
        return const Color(0xFF2ECC71); // Emerald
      case Track.primaryPals:
        return const Color(0xFF3498DB); // Blue
      case Track.answer:
        return const Color(0xFF9B59B6); // Amethyst
      case Track.search:
        return const Color(0xFF1ABC9C); // Turquoise
      case Track.beginners:
        return const Color(0xFFF1C40F); // Yellow
      case Track.daybreak:
        return const Color(0xFFE67E22); // Orange
    }
  }

  String get label {
    switch (this) {
      case Track.beginners:
        return 'Beginners';
      case Track.primaryPals:
        return 'Primary Pals';
      case Track.answer:
        return 'The Answer';
      case Track.search:
        return 'Search';
      case Track.discovery:
        return 'Discovery';
      case Track.daybreak:
        return 'Daybreak';
    }
  }
}
