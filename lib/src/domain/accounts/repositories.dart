import 'entities.dart';

abstract class AccountRepository {
  Future<LocalAccount?> getCurrentAccount();
  Stream<LocalAccount?> watchCurrentAccount();
  Future<void> saveAccount(LocalAccount account);
  Future<void> deleteAccount(String id);
}
