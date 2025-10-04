import 'dart:convert';

import '../../domain/settings/entities.dart';
import '../../domain/settings/repositories.dart';
import '../../infrastructure/security/secure_storage_service.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._storage);

  final SecureStorageService _storage;
  static const _themeKey = 'app_theme_mode';
  static const _themeProfileKey = 'theme_profile';
  static const _notificationKey = 'notification_preferences';

  String _themeModeKeyFor(String userId) => '${_themeKey}_$userId';
  String _themeProfileKeyFor(String userId) => '${_themeProfileKey}_$userId';
  String _notificationPrefsKeyFor(String userId) =>
      '${_notificationKey}_$userId';

  @override
  Future<AppThemeMode> getThemeMode(String userId) async {
    final value = await _storage.read(_themeModeKeyFor(userId));
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
    final key = _themeModeKeyFor(userId);
    switch (mode) {
      case AppThemeMode.system:
        await _storage.delete(key);
        break;
      case AppThemeMode.light:
        await _storage.write(key, 'light');
        break;
      case AppThemeMode.dark:
        await _storage.write(key, 'dark');
        break;
    }
  }

  @override
  Future<void> clearThemeMode(String userId) async {
    await _storage.delete(_themeModeKeyFor(userId));
  }

  @override
  Future<String?> getThemeProfileId(String userId) async {
    final value = await _storage.read(_themeProfileKeyFor(userId));
    if (value == null || value.isEmpty) {
      return null;
    }
    return value;
  }

  @override
  Future<void> saveThemeProfileId(String userId, String profileId) async {
    final key = _themeProfileKeyFor(userId);
    if (profileId.isEmpty) {
      await _storage.delete(key);
      return;
    }
    await _storage.write(key, profileId);
  }

  @override
  Future<NotificationPreferences> getNotificationPreferences(
      String userId) async {
    final key = _notificationPrefsKeyFor(userId);
    final raw = await _storage.read(key);
    if (raw == null || raw.isEmpty) {
      return const NotificationPreferences();
    }
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return NotificationPreferences.fromJson(decoded);
    } catch (_) {
      await _storage.delete(key);
      return const NotificationPreferences();
    }
  }

  @override
  Future<void> saveNotificationPreferences(
    String userId,
    NotificationPreferences preferences,
  ) async {
    final key = _notificationPrefsKeyFor(userId);
    final payload = jsonEncode(preferences.toJson());
    await _storage.write(key, payload);
  }
}
