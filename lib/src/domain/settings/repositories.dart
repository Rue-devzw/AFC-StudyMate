import 'entities.dart';

abstract class SettingsRepository {
  Future<AppThemeMode> getThemeMode(String userId);
  Future<void> saveThemeMode(String userId, AppThemeMode mode);
}
