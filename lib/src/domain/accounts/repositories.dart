import 'entities.dart';

abstract class AccountRepository {
  Stream<List<LocalAccount>> watchAccounts();
  Future<List<LocalAccount>> getAccounts();
  Future<LocalAccount?> getCurrentAccount();
  Stream<LocalAccount?> watchCurrentAccount();
  Future<void> setActiveAccount(String id);
  Future<void> saveAccount(LocalAccount account);
  Future<void> deleteAccount(String id);
  Future<LocalAccount?> getAccountById(String id);
}
