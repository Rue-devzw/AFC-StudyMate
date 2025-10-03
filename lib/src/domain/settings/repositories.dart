import 'entities.dart';

abstract class SettingsRepository {
  Future<AppThemeMode> getThemeMode(String userId);
  Future<void> saveThemeMode(String userId, AppThemeMode mode);
  Future<NotificationPreferences> getNotificationPreferences(String userId);
  Future<void> saveNotificationPreferences(
    String userId,
    NotificationPreferences preferences,
  );
}
