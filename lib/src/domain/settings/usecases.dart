import 'entities.dart';
import 'repositories.dart';

class GetThemeModeUseCase {
  final SettingsRepository _repository;

  const GetThemeModeUseCase(this._repository);

  Future<AppThemeMode> call(String userId) =>
      _repository.getThemeMode(userId);
}

class SaveThemeModeUseCase {
  final SettingsRepository _repository;

  const SaveThemeModeUseCase(this._repository);

  Future<void> call(String userId, AppThemeMode mode) =>
      _repository.saveThemeMode(userId, mode);
}

class GetThemeProfileUseCase {
  final SettingsRepository _repository;

  const GetThemeProfileUseCase(this._repository);

  Future<String?> call(String userId) =>
      _repository.getThemeProfileId(userId);
}

class SaveThemeProfileUseCase {
  final SettingsRepository _repository;

  const SaveThemeProfileUseCase(this._repository);

  Future<void> call(String userId, String profileId) =>
      _repository.saveThemeProfileId(userId, profileId);
}

class GetNotificationPreferencesUseCase {
  final SettingsRepository _repository;

  const GetNotificationPreferencesUseCase(this._repository);

  Future<NotificationPreferences> call(String userId) =>
      _repository.getNotificationPreferences(userId);
}

class SaveNotificationPreferencesUseCase {
  final SettingsRepository _repository;

  const SaveNotificationPreferencesUseCase(this._repository);

  Future<void> call(String userId, NotificationPreferences preferences) =>
      _repository.saveNotificationPreferences(userId, preferences);
}
