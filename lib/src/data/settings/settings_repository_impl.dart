import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/settings/entities.dart';
import '../../domain/settings/repositories.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  static const _themeKey = 'app_theme_mode';

  @override
  Future<AppThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_themeKey);
    switch (value) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      default:
        return AppThemeMode.system;
    }
  }

  @override
  Future<void> saveThemeMode(AppThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    switch (mode) {
      case AppThemeMode.system:
        await prefs.remove(_themeKey);
        break;
      case AppThemeMode.light:
        await prefs.setString(_themeKey, 'light');
        break;
      case AppThemeMode.dark:
        await prefs.setString(_themeKey, 'dark');
        break;
    }
  }
}
