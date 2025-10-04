import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
            resetOnError: true,
          ),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.unlocked_this_device,
          ),
          mOptions: MacOsOptions(
            accessibility: KeychainAccessibility.unlocked_this_device,
          ),
          webOptions: const WebOptions(),
        );

  final FlutterSecureStorage _secureStorage;
  Future<SharedPreferences>? _prefsFuture;

  Future<SharedPreferences> _prefs() {
    final existing = _prefsFuture;
    if (existing != null) {
      return existing;
    }
    final future = SharedPreferences.getInstance();
    _prefsFuture = future;
    return future;
  }

  Future<String?> read(String key) async {
    final value = await _secureStorage.read(key: key);
    if (value != null) {
      return value;
    }
    final prefs = await _prefs();
    final legacy = prefs.getString(key);
    if (legacy != null) {
      await _secureStorage.write(key: key, value: legacy);
      await prefs.remove(key);
      return legacy;
    }
    return null;
  }

  Future<Map<String, String>> readAll({String? prefix}) async {
    final entries = await _secureStorage.readAll();
    final filtered = <String, String>{};
    entries.forEach((key, value) {
      if (prefix == null || key.startsWith(prefix)) {
        filtered[key] = value;
      }
    });
    if (filtered.isNotEmpty) {
      return filtered;
    }
    final prefs = await _prefs();
    for (final key in prefs.getKeys()) {
      if (prefix == null || key.startsWith(prefix)) {
        final value = prefs.getString(key);
        if (value != null) {
          filtered[key] = value;
          await _secureStorage.write(key: key, value: value);
          await prefs.remove(key);
        }
      }
    }
    return filtered;
  }

  Future<void> write(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
    final prefs = await _prefs();
    await prefs.remove(key);
  }

  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
    final prefs = await _prefs();
    await prefs.remove(key);
  }
}
