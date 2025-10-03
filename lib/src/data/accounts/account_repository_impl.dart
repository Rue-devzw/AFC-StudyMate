import 'package:drift/drift.dart';

import '../../domain/accounts/entities.dart';
import '../../domain/accounts/repositories.dart';
import '../../infrastructure/db/app_database.dart';
import '../../infrastructure/db/daos/account_dao.dart';

class AccountRepositoryImpl implements AccountRepository {
  AccountRepositoryImpl(this._db, this._dao);

  final AppDatabase _db;
  final AccountDao _dao;

  Future<void> _ensureSeeded() => _db.ensureSeeded();

  @override
  Future<LocalAccount?> getCurrentAccount() async {
    await _ensureSeeded();
    final row = await _dao.getAccount();
    if (row == null) {
      return null;
    }
    return _map(row);
  }

  @override
  Stream<LocalAccount?> watchCurrentAccount() async* {
    await _ensureSeeded();
    yield* _dao.watchAccount().map((row) => row == null ? null : _map(row));
  }

  @override
  Future<void> saveAccount(LocalAccount account) {
    final companion = LocalUsersCompanion(
      id: Value(account.id),
      displayName: Value(account.displayName),
      avatarUrl: Value(account.avatarUrl),
    );
    return _dao.upsertAccount(companion);
  }

  @override
  Future<void> deleteAccount(String id) {
    return _dao.deleteAccount(id);
  }

  LocalAccount _map(LocalUser row) {
    return LocalAccount(
      id: row.id,
      displayName: row.displayName,
      avatarUrl: row.avatarUrl,
    );
  }
}
