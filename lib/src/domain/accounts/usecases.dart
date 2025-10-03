import 'entities.dart';
import 'repositories.dart';

class GetCurrentAccountUseCase {
  final AccountRepository _repository;

  const GetCurrentAccountUseCase(this._repository);

  Future<LocalAccount?> call() => _repository.getCurrentAccount();
}

class WatchAccountUseCase {
  final AccountRepository _repository;

  const WatchAccountUseCase(this._repository);

  Stream<LocalAccount?> call() => _repository.watchCurrentAccount();
}

class SaveAccountUseCase {
  final AccountRepository _repository;

  const SaveAccountUseCase(this._repository);

  Future<void> call(LocalAccount account) =>
      _repository.saveAccount(account);
}

class DeleteAccountUseCase {
  final AccountRepository _repository;

  const DeleteAccountUseCase(this._repository);

  Future<void> call(String id) => _repository.deleteAccount(id);
}
