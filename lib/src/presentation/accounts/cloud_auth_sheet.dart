import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

class CloudAuthSheet extends ConsumerStatefulWidget {
  const CloudAuthSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: CloudAuthSheet(),
        );
      },
    );
  }

  @override
  ConsumerState<CloudAuthSheet> createState() => _CloudAuthSheetState();
}

class _CloudAuthSheetState extends ConsumerState<CloudAuthSheet> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isRegister = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(cloudAuthControllerProvider);
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          top: 24,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.cloud_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isRegister ? 'Create cloud account' : 'Sign in to sync',
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _isRegister
                      ? 'Create an AFC StudyMate cloud account to sync lessons, notes and progress across devices.'
                      : 'Sign in to your AFC StudyMate cloud account to sync progress and messages.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email address',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address.';
                    }
                    if (!value.contains('@')) {
                      return 'Enter a valid email address.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  autofillHints: const [AutofillHints.password],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password.';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters long.';
                    }
                    return null;
                  },
                ),
                if (_isRegister) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Confirm password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                    autofillHints: const [AutofillHints.password],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password.';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match.';
                      }
                      return null;
                    },
                  ),
                ],
                if (authState.hasError) ...[
                  const SizedBox(height: 12),
                  Text(
                    authState.errorMessage!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: authState.isLoading ? null : _submit,
                  child: authState.isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_isRegister ? 'Create account' : 'Sign in'),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: authState.isLoading ? null : () => _signInWithGoogle(context),
                  icon: const Icon(Icons.account_circle_outlined),
                  label: const Text('Continue with Google'),
                ),
                if (_isAppleSupported)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: OutlinedButton.icon(
                      onPressed: authState.isLoading ? null : () => _signInWithApple(context),
                      icon: const Icon(Icons.apple),
                      label: const Text('Continue with Apple'),
                    ),
                  ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: authState.isLoading
                      ? null
                      : () {
                          setState(() {
                            _isRegister = !_isRegister;
                            ref.read(cloudAuthControllerProvider.notifier).reset();
                          });
                        },
                  child: Text(
                    _isRegister
                        ? 'Already have an account? Sign in'
                        : 'Need an account? Create one',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool get _isAppleSupported => kIsWeb ||
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final controller = ref.read(cloudAuthControllerProvider.notifier);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final success = _isRegister
        ? await controller.registerWithEmail(email, password)
        : await controller.signInWithEmail(email, password);
    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isRegister
              ? 'Account created. You are now signed in.'
              : 'Signed in successfully.'),
        ),
      );
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    final success = await ref.read(cloudAuthControllerProvider.notifier).signInWithGoogle();
    _handleSocialResult(context, success, providerLabel: 'Google');
  }

  Future<void> _signInWithApple(BuildContext context) async {
    final success = await ref.read(cloudAuthControllerProvider.notifier).signInWithApple();
    _handleSocialResult(context, success, providerLabel: 'Apple');
  }

  void _handleSocialResult(BuildContext context, bool success,
      {required String providerLabel}) {
    final state = ref.read(cloudAuthControllerProvider);
    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signed in with $providerLabel.')),
      );
    } else if (state.hasError && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage!)),
      );
    }
  }
}
