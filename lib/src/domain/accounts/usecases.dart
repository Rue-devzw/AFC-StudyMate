import 'entities.dart';
import 'repositories.dart';

class WatchAccountsUseCase {
  const WatchAccountsUseCase(this._repository);

  final AccountRepository _repository;

  Stream<List<LocalAccount>> call() => _repository.watchAccounts();
}

class GetAccountsUseCase {
  const GetAccountsUseCase(this._repository);

  final AccountRepository _repository;

  Future<List<LocalAccount>> call() => _repository.getAccounts();
}

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

class SetActiveAccountUseCase {
  final AccountRepository _repository;

  const SetActiveAccountUseCase(this._repository);

  Future<void> call(String id) => _repository.setActiveAccount(id);
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
