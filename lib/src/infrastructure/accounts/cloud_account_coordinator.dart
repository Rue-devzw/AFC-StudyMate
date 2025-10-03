import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/accounts/entities.dart';
import '../../domain/accounts/repositories.dart';
import '../../domain/sync/entities.dart';
import '../../domain/sync/repositories.dart';

class CloudAccountCoordinator {
  CloudAccountCoordinator(this._accountRepository, this._syncRepository);

  final AccountRepository _accountRepository;
  final SyncRepository _syncRepository;

  static const String _initialSeedOpType = 'cloud.profile.initial';

  Future<void> handleAuthState(User? user) async {
    if (user == null) {
      await _activateLocalFallback();
      return;
    }

    final existing = await _accountRepository.getAccountById(user.uid);
    final profile = LocalAccount(
      id: user.uid,
      displayName:
          user.displayName?.trim().isNotEmpty == true ? user.displayName : existing?.displayName ?? user.email ?? 'Cloud account',
      avatarUrl: user.photoURL ?? existing?.avatarUrl,
      preferredCohortId: existing?.preferredCohortId,
      preferredCohortTitle: existing?.preferredCohortTitle,
      preferredLessonClass: existing?.preferredLessonClass,
      isActive: true,
    );

    await _accountRepository.saveAccount(profile);
    await _accountRepository.setActiveAccount(profile.id);
    await _seedInitialSync(profile, user);
  }

  Future<void> _seedInitialSync(LocalAccount account, User user) async {
    final alreadySeeded =
        await _syncRepository.hasOperation(account.id, _initialSeedOpType);
    if (alreadySeeded) {
      return;
    }

    final providerIds = user.providerData.map((item) => item.providerId).toList();
    final payload = {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoUrl': user.photoURL,
      'providers': providerIds,
      'seededAt': DateTime.now().toIso8601String(),
    };

    final operation = SyncOperation(
      id: '',
      userId: account.id,
      opType: _initialSeedOpType,
      payload: payload,
      createdAt: DateTime.now(),
    );
    await _syncRepository.enqueue(operation);
  }

  Future<void> _activateLocalFallback() async {
    final localAccount = await _accountRepository.getAccountById('local-user');
    if (localAccount != null) {
      await _accountRepository.setActiveAccount(localAccount.id);
    } else {
      final accounts = await _accountRepository.getAccounts();
      final fallback = accounts.isNotEmpty ? accounts.first : null;
      if (fallback != null) {
        await _accountRepository.setActiveAccount(fallback.id);
      }
    }
  }
}
