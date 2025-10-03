class LocalAccount {
  final String id;
  final String? displayName;
  final String? avatarUrl;
  final String? preferredCohortId;
  final String? preferredCohortTitle;
  final String? preferredLessonClass;
  final bool isActive;

  const LocalAccount({
    required this.id,
    this.displayName,
    this.avatarUrl,
    this.preferredCohortId,
    this.preferredCohortTitle,
    this.preferredLessonClass,
    this.isActive = false,
  });

  LocalAccount copyWith({
    String? id,
    String? displayName,
    String? avatarUrl,
    String? preferredCohortId,
    String? preferredCohortTitle,
    String? preferredLessonClass,
    bool? isActive,
  }) {
    return LocalAccount(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      preferredCohortId: preferredCohortId ?? this.preferredCohortId,
      preferredCohortTitle: preferredCohortTitle ?? this.preferredCohortTitle,
      preferredLessonClass: preferredLessonClass ?? this.preferredLessonClass,
      isActive: isActive ?? this.isActive,
    );
  }
}

abstract class AuthSession {
  const AuthSession();
}
