import 'dart:convert';

import 'package:afc_studymate/data/drift/app_database.dart';
import 'package:afc_studymate/data/services/auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

const _driveBackupFileName = 'studymate_user_data.json';

final cloudBackupServiceProvider = Provider<CloudBackupService>((ref) {
  return CloudBackupService(
    database: ref.read(appDatabaseProvider),
    authService: ref.read(authServiceProvider),
  );
});

class CloudBackupService {
  CloudBackupService({
    required this.database,
    required this.authService,
  });

  final AppDatabase database;
  final AuthService authService;

  Future<bool> isAvailable() async {
    return true;
  }

  Future<void> backupNow() async {
    final account = await _requireAccount();
    final snapshot = await database.exportUserData();
    final payload = jsonEncode(snapshot);
    final api = await _driveApiFor(account);
    final existing = await _findBackupFile(api);
    final uploadMedia = drive.Media(
      Stream<List<int>>.value(utf8.encode(payload)),
      payload.length,
      contentType: 'application/json',
    );

    final file = drive.File()
      ..name = _driveBackupFileName
      ..parents = const <String>['appDataFolder']
      ..description = 'AFM SEAR StudyMate backup';

    if (existing?.id case final fileId?) {
      await api.files.update(
        file,
        fileId,
        uploadMedia: uploadMedia,
      );
      return;
    }

    await api.files.create(file, uploadMedia: uploadMedia);
  }

  Future<void> restoreLatest() async {
    final account = await _requireAccount();
    final api = await _driveApiFor(account);
    final file = await _findBackupFile(api);
    final fileId = file?.id;
    if (fileId == null || fileId.isEmpty) {
      throw StateError('No Google Drive backup was found for this account.');
    }

    final media = await api.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    );
    if (media is! drive.Media) {
      throw StateError('Could not download the Google Drive backup file.');
    }

    final bytes = <int>[];
    await media.stream.forEach(bytes.addAll);
    final decoded = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
    await database.importUserDataSnapshot(decoded);
  }

  Future<GoogleSignInAccount?> signIn() => authService.signInWithGoogle();

  Future<void> signOut() => authService.signOut();

  Future<GoogleSignInAccount> _requireAccount() async {
    final account =
        authService.currentUser ?? await authService.signInSilently();
    if (account != null) {
      return account;
    }
    final interactive = await authService.signInWithGoogle();
    if (interactive == null) {
      throw StateError(
        'Google Drive backup requires a signed-in Google account.',
      );
    }
    return interactive;
  }

  Future<drive.DriveApi> _driveApiFor(GoogleSignInAccount account) async {
    final headers = await authService.authorizationHeadersForDrive(
      account: account,
    );
    return drive.DriveApi(_GoogleAuthClient(headers));
  }

  Future<drive.File?> _findBackupFile(drive.DriveApi api) async {
    final result = await api.files.list(
      spaces: 'appDataFolder',
      q: "name = '$_driveBackupFileName' and trashed = false",
      pageSize: 1,
      $fields: 'files(id, name, modifiedTime)',
    );
    final files = result.files;
    if (files == null || files.isEmpty) {
      return null;
    }
    return files.first;
  }
}

class _GoogleAuthClient extends http.BaseClient {
  _GoogleAuthClient(this._headers);

  final Map<String, String> _headers;
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _inner.send(request);
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}
