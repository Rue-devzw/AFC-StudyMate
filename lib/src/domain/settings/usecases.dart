import 'entities.dart';
import 'repositories.dart';

class GetThemeModeUseCase {
  final SettingsRepository _repository;

  const GetThemeModeUseCase(this._repository);

  Future<AppThemeMode> call() => _repository.getThemeMode();
}

class SaveThemeModeUseCase {
  final SettingsRepository _repository;

  const SaveThemeModeUseCase(this._repository);

  Future<void> call(AppThemeMode mode) =>
      _repository.saveThemeMode(mode);
}
