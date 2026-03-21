import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const googleDriveAppDataScope = 'https://www.googleapis.com/auth/drive.appdata';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(GoogleSignIn.instance);
});

final authUserProvider = StreamProvider<GoogleSignInAccount?>((ref) async* {
  final authService = ref.watch(authServiceProvider);
  await authService.ensureInitialised();
  yield authService.currentUser;
  yield* authService.onCurrentUserChanged;
});

class AuthService {
  AuthService(this._googleSignIn);

  final GoogleSignIn _googleSignIn;
  final StreamController<GoogleSignInAccount?> _authChanges =
      StreamController<GoogleSignInAccount?>.broadcast();

  StreamSubscription<GoogleSignInAuthenticationEvent>? _authEventsSub;
  GoogleSignInAccount? _currentUser;
  bool _initialised = false;

  GoogleSignInAccount? get currentUser => _currentUser;

  Stream<GoogleSignInAccount?> get onCurrentUserChanged => _authChanges.stream;

  Future<bool> ensureInitialised() async {
    if (_initialised) {
      return true;
    }

    await _googleSignIn.initialize();
    _authEventsSub ??= _googleSignIn.authenticationEvents.listen(
      (event) {
        switch (event) {
          case GoogleSignInAuthenticationEventSignIn():
            _setCurrentUser(event.user);
          case GoogleSignInAuthenticationEventSignOut():
            _setCurrentUser(null);
        }
      },
      onError: _authChanges.addError,
    );

    final restored = await _lightweightAuthentication();
    _setCurrentUser(restored);
    _initialised = true;
    return true;
  }

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    await ensureInitialised();
    try {
      final account = await _googleSignIn.authenticate(
        scopeHint: const <String>[googleDriveAppDataScope],
      );
      _setCurrentUser(account);
      return account;
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }
      rethrow;
    }
  }

  Future<GoogleSignInAccount?> signInSilently() async {
    await ensureInitialised();
    if (_currentUser != null) {
      return _currentUser;
    }
    final account = await _lightweightAuthentication();
    _setCurrentUser(account);
    return account;
  }

  Future<Map<String, String>> authorizationHeadersForDrive({
    GoogleSignInAccount? account,
    bool promptIfNecessary = true,
  }) async {
    await ensureInitialised();
    final resolvedAccount =
        account ??
        currentUser ??
        (promptIfNecessary ? await signInWithGoogle() : await signInSilently());
    if (resolvedAccount == null) {
      throw StateError(
        'Google Drive backup requires a signed-in Google account.',
      );
    }

    final headers = await resolvedAccount.authorizationClient
        .authorizationHeaders(
          const <String>[googleDriveAppDataScope],
          promptIfNecessary: promptIfNecessary,
        );
    if (headers == null) {
      throw StateError(
        'StudyMate could not get Google Drive permission for this account.',
      );
    }
    return headers;
  }

  Future<void> signOut() async {
    if (_initialised) {
      await _googleSignIn.signOut();
    }
    _setCurrentUser(null);
  }

  Future<GoogleSignInAccount?> _lightweightAuthentication() async {
    final future = _googleSignIn.attemptLightweightAuthentication();
    if (future == null) {
      return _currentUser;
    }
    try {
      return await future;
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled ||
          error.code == GoogleSignInExceptionCode.uiUnavailable) {
        return null;
      }
      rethrow;
    }
  }

  void _setCurrentUser(GoogleSignInAccount? account) {
    _currentUser = account;
    _authChanges.add(account);
  }
}
