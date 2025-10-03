import 'dart:convert';

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
  Stream<List<LocalAccount>> watchAccounts() async* {
    await _ensureSeeded();
    yield* _dao.watchAccounts().map((rows) => rows.map(_map).toList());
  }

  @override
  Future<List<LocalAccount>> getAccounts() async {
    await _ensureSeeded();
    final rows = await _dao.getAccounts();
    return rows.map(_map).toList();
  }

  @override
  Future<LocalAccount?> getCurrentAccount() async {
    await _ensureSeeded();
    final row = await _dao.getActiveAccount();
    if (row == null) {
      return null;
    }
    return _map(row);
  }

  @override
  Stream<LocalAccount?> watchCurrentAccount() async* {
    await _ensureSeeded();
    yield* _dao
        .watchActiveAccount()
        .map((row) => row == null ? null : _map(row));
  }

  @override
  Future<void> setActiveAccount(String id) async {
    await _ensureSeeded();
    await _dao.setActiveAccount(id);
  }

  @override
  Future<void> saveAccount(LocalAccount account) {
    final companion = LocalUsersCompanion(
      id: Value(account.id),
      displayName: Value(account.displayName),
      avatarUrl: Value(account.avatarUrl),
      preferredCohortId: Value(account.preferredCohortId),
      preferredCohortTitle: Value(account.preferredCohortTitle),
      preferredLessonClass: Value(account.preferredLessonClass),
      roles: Value(json.encode(account.roles)),
      isActive: Value(account.isActive),
    );
    return _dao.upsertAccount(companion);
  }

  @override
  Future<void> deleteAccount(String id) async {
    await _ensureSeeded();
    final account = await _dao.getAccountById(id);
    await _dao.deleteAccount(id);
    if (account?.isActive == true) {
      final remaining = await _dao.getAccounts();
      if (remaining.isNotEmpty) {
        await _dao.setActiveAccount(remaining.first.id);
      }
    }
  }

  @override
  Future<LocalAccount?> getAccountById(String id) async {
    await _ensureSeeded();
    final row = await _dao.getAccountById(id);
    if (row == null) {
      return null;
    }
    return _map(row);
  }

  LocalAccount _map(LocalUser row) {
    return LocalAccount(
      id: row.id,
      displayName: row.displayName,
      avatarUrl: row.avatarUrl,
      preferredCohortId: row.preferredCohortId,
      preferredCohortTitle: row.preferredCohortTitle,
      preferredLessonClass: row.preferredLessonClass,
      roles: _decodeRoles(row.roles),
      isActive: row.isActive,
    );
  }

  List<String> _decodeRoles(String? roles) {
    if (roles == null || roles.isEmpty) {
      return const [];
    }
    try {
      final decoded = json.decode(roles);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {
      // ignore
    }
    return const [];
  }
}
