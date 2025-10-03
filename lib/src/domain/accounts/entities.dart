class LocalAccount {
  final String id;
  final String? displayName;
  final String? avatarUrl;

  const LocalAccount({
    required this.id,
    this.displayName,
    this.avatarUrl,
  });
}

abstract class AuthSession {
  const AuthSession();
}
