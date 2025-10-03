import 'entities.dart';

abstract class SettingsRepository {
  Future<AppThemeMode> getThemeMode();
  Future<void> saveThemeMode(AppThemeMode mode);
}
