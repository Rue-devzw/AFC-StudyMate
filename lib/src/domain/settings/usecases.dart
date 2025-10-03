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
