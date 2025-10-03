import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../infrastructure/accounts/firebase_auth_service.dart';

class CloudAuthState {
  const CloudAuthState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;

  CloudAuthState copyWith({bool? isLoading, String? errorMessage}) {
    return CloudAuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
}

class CloudAuthController extends StateNotifier<CloudAuthState> {
  CloudAuthController(this._authService) : super(const CloudAuthState());

  final FirebaseAuthService _authService;

  Future<bool> registerWithEmail(String email, String password) {
    return _run(() => _authService.registerWithEmail(email: email, password: password));
  }

  Future<bool> signInWithEmail(String email, String password) {
    return _run(() => _authService.signInWithEmail(email: email, password: password));
  }

  Future<bool> signInWithGoogle() {
    return _run(() => _authService.signInWithGoogle());
  }

  Future<bool> signInWithApple() {
    return _run(() => _authService.signInWithApple());
  }

  Future<bool> signOut() {
    return _run(() => _authService.signOut());
  }

  void reset() {
    state = const CloudAuthState();
  }

  Future<bool> _run(Future<void> Function() action) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await action();
      state = const CloudAuthState();
      return true;
    } on AuthException catch (error) {
      state = CloudAuthState(errorMessage: error.message);
    } catch (error) {
      state = const CloudAuthState(
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
    return false;
  }
}
