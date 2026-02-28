import 'package:afc_studymate/data/models/enums.dart';

class UserProfile {
  const UserProfile({
    required this.userId,
    required this.name,
    required this.role,
    required this.targetTrack,
    required this.translation,
  });

  final String userId;
  final String name;
  final Role role;
  final Track targetTrack;
  final Translation translation;

  UserProfile copyWith({
    String? userId,
    String? name,
    Role? role,
    Track? targetTrack,
    Translation? translation,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      role: role ?? this.role,
      targetTrack: targetTrack ?? this.targetTrack,
      translation: translation ?? this.translation,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'userId': userId,
    'name': name,
    'role': role.name,
    'targetTrack': targetTrack.name,
    'translation': translation.name,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'] as String,
      name: json['name'] as String? ?? 'User',
      role: Role.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => Role.learner,
      ),
      targetTrack: Track.values.firstWhere(
        (e) => e.name == json['targetTrack'],
        orElse: () => Track.search,
      ),
      translation: Translation.values.firstWhere(
        (e) => e.name == json['translation'],
        orElse: () => Translation.kjv,
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          name == other.name &&
          role == other.role &&
          targetTrack == other.targetTrack &&
          translation == other.translation;

  @override
  int get hashCode =>
      userId.hashCode ^
      name.hashCode ^
      role.hashCode ^
      targetTrack.hashCode ^
      translation.hashCode;
}
