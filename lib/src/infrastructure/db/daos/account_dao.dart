import 'package:drift/drift.dart';

import '../app_database.dart';

class AccountDao {
  AccountDao(this._db);

  final AppDatabase _db;

  Stream<List<LocalUser>> watchAccounts() {
    final query = _db.select(_db.localUsers)
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.displayName)]);
    return query.watch();
  }

  Future<List<LocalUser>> getAccounts() {
    final query = _db.select(_db.localUsers)
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.displayName)]);
    return query.get();
  }

  Stream<LocalUser?> watchActiveAccount() {
    final query = _db.select(_db.localUsers)
      ..where((tbl) => tbl.isActive.equals(true))
      ..limit(1);
    return query.watchSingleOrNull();
  }

  Future<LocalUser?> getActiveAccount() {
    final query = _db.select(_db.localUsers)
      ..where((tbl) => tbl.isActive.equals(true))
      ..limit(1);
    return query.getSingleOrNull();
  }

  Future<LocalUser?> getAccountById(String id) {
    final query = _db.select(_db.localUsers)
      ..where((tbl) => tbl.id.equals(id))
      ..limit(1);
    return query.getSingleOrNull();
  }

  Future<void> upsertAccount(LocalUsersCompanion companion) {
    return _db.into(_db.localUsers).insertOnConflictUpdate(companion);
  }

  Future<void> setActiveAccount(String id) async {
    await _db.transaction(() async {
      await _db.update(_db.localUsers).write(
            const LocalUsersCompanion(isActive: Value(false)),
          );
      await (_db.update(_db.localUsers)..where((tbl) => tbl.id.equals(id))).write(
        const LocalUsersCompanion(isActive: Value(true)),
      );
    });
  }

  Future<void> deleteAccount(String id) {
    return (_db.delete(_db.localUsers)..where((tbl) => tbl.id.equals(id))).go();
  }
}
