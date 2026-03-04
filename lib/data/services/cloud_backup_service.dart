import 'dart:convert';
import 'dart:io';

import 'package:afc_studymate/data/drift/app_database.dart';
import 'package:afc_studymate/data/services/auth_service.dart';
import 'package:afc_studymate/data/services/firebase_runtime_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final cloudBackupServiceProvider = Provider<CloudBackupService>((ref) {
  return CloudBackupService(
    database: ref.read(appDatabaseProvider),
    authService: ref.read(authServiceProvider),
    firebaseRuntimeService: ref.read(firebaseRuntimeServiceProvider),
    storage: FirebaseStorage.instance,
  );
});

class CloudBackupService {
  CloudBackupService({
    required this.database,
    required this.authService,
    required this.firebaseRuntimeService,
    required this.storage,
  });

  final AppDatabase database;
  final AuthService authService;
  final FirebaseRuntimeService firebaseRuntimeService;
  final FirebaseStorage storage;

  Future<bool> isAvailable() async {
    return firebaseRuntimeService.ensureInitialised();
  }

  Future<void> backupNow() async {
    final ready = await firebaseRuntimeService.ensureInitialised();
    if (!ready) {
      throw StateError('Firebase is not configured for cloud backup.');
    }
    final user = authService.currentUser ?? (await authService.signInAnonymously()).user;
    if (user == null) {
      throw StateError('Unable to authenticate for cloud backup.');
    }

    final snapshot = await database.exportUserData();
    final payload = jsonEncode(snapshot);
    final ref = storage.ref().child('backups/${user.uid}/user_data.json');
    await ref.putString(
      payload,
      metadata: SettableMetadata(contentType: 'application/json'),
    );
  }

  Future<void> restoreLatest() async {
    final ready = await firebaseRuntimeService.ensureInitialised();
    if (!ready) {
      throw StateError('Firebase is not configured for cloud restore.');
    }
    final user = authService.currentUser ?? (await authService.signInAnonymously()).user;
    if (user == null) {
      throw StateError('Unable to authenticate for cloud restore.');
    }

    final ref = storage.ref().child('backups/${user.uid}/user_data.json');
    final tempDir = await Directory.systemTemp.createTemp('studymate_restore_');
    try {
      final tempFile = File('${tempDir.path}/user_data.json');
      await ref.writeToFile(tempFile);
      final decoded =
          jsonDecode(await tempFile.readAsString()) as Map<String, dynamic>;
      await database.importUserDataSnapshot(decoded);
    } finally {
      await tempDir.delete(recursive: true);
    }
  }
}
