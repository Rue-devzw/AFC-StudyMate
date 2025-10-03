import '../app_database.dart';

class AccountDao {
  AccountDao(this._db);

  final AppDatabase _db;

  Stream<LocalUser?> watchAccount() {
    return _db.select(_db.localUsers).watchSingleOrNull();
  }

  Future<LocalUser?> getAccount() {
    return _db.select(_db.localUsers).getSingleOrNull();
  }

  Future<void> upsertAccount(LocalUsersCompanion companion) {
    return _db.into(_db.localUsers).insertOnConflictUpdate(companion);
  }

  Future<void> deleteAccount(String id) {
    return (_db.delete(_db.localUsers)..where((tbl) => tbl.id.equals(id))).go();
  }
}
