import '../../domain/settings/entities.dart';
import '../../domain/settings/repositories.dart';
import '../../infrastructure/security/secure_storage_service.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._storage);

  final SecureStorageService _storage;
  static const _themeKey = 'app_theme_mode';

  String _keyFor(String userId) => '${_themeKey}_$userId';

  @override
  Future<AppThemeMode> getThemeMode(String userId) async {
    final value = await _storage.read(_keyFor(userId));
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
    final key = _keyFor(userId);
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
  Future<void> clearThemeMode(String userId) {
    return _storage.delete(_keyFor(userId));
  }
}
