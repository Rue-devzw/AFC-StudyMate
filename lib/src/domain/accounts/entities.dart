class LocalAccount {
  final String id;
  final String? displayName;
  final String? avatarUrl;
  final String? preferredCohortId;
  final String? preferredCohortTitle;
  final String? preferredLessonClass;
  final List<String> roles;
  final bool isActive;

  const LocalAccount({
    required this.id,
    this.displayName,
    this.avatarUrl,
    this.preferredCohortId,
    this.preferredCohortTitle,
    this.preferredLessonClass,
    this.roles = const [],
    this.isActive = false,
  });

  LocalAccount copyWith({
    String? id,
    String? displayName,
    String? avatarUrl,
    String? preferredCohortId,
    String? preferredCohortTitle,
    String? preferredLessonClass,
    List<String>? roles,
    bool? isActive,
  }) {
    return LocalAccount(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      preferredCohortId: preferredCohortId ?? this.preferredCohortId,
      preferredCohortTitle: preferredCohortTitle ?? this.preferredCohortTitle,
      preferredLessonClass: preferredLessonClass ?? this.preferredLessonClass,
      roles: roles ?? this.roles,
      isActive: isActive ?? this.isActive,
    );
  }
}

abstract class AuthSession {
  const AuthSession();
}
