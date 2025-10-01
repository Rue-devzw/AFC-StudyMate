import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Color _primaryColor = const Color(0xFF3F51B5); // Default primary color

  ThemeMode get themeMode => _themeMode;
  Color get primaryColor => _primaryColor;

  final List<Color> _colorOptions = [
    const Color(0xFF3F51B5), // Indigo
    Colors.blue,
    Colors.teal,
    Colors.green,
    Colors.red,
  ];

  List<Color> get colorOptions => _colorOptions;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setPrimaryColor(Color color) {
    _primaryColor = color;
    notifyListeners();
  }

  void setSystemTheme() {
    _themeMode = ThemeMode.system;
    notifyListeners();
  }
}
