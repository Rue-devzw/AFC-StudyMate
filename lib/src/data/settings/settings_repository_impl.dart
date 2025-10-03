import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/settings/entities.dart';
import '../../domain/settings/repositories.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  static const _themeKey = 'app_theme_mode';

  String _keyFor(String userId) => '${_themeKey}_$userId';

  @override
  Future<AppThemeMode> getThemeMode(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_keyFor(userId));
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
  Future<void> saveThemeMode(String userId, AppThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _keyFor(userId);
    switch (mode) {
      case AppThemeMode.system:
        await prefs.remove(key);
        break;
      case AppThemeMode.light:
        await prefs.setString(key, 'light');
        break;
      case AppThemeMode.dark:
        await prefs.setString(key, 'dark');
        break;
    }
  }
}
