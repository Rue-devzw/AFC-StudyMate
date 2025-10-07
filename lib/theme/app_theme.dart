import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appThemeProvider = Provider<AppTheme>((ref) {
  return AppTheme();
});

class AppTheme {
  AppTheme();

  ThemeMode get themeMode => ThemeMode.system;

  Provider<ThemeMode> get themeModeProvider => Provider<ThemeMode>((_) => themeMode);

  ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: const Color(0xFF2F5D62),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: Typography.englishLike2021.apply(fontFamily: 'Roboto'),
      );

  ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xFF8FC1D4),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: Typography.englishLike2021.apply(fontFamily: 'Roboto'),
      );
}
