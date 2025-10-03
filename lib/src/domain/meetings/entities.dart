import 'package:collection/collection.dart';

enum MeetingContextType { lesson, roundtable }

extension MeetingContextTypeX on MeetingContextType {
  String get storageValue {
    switch (this) {
      case MeetingContextType.lesson:
        return 'lesson';
      case MeetingContextType.roundtable:
        return 'roundtable';
    }
  }

  static MeetingContextType fromStorage(String value) {
    return MeetingContextType.values.firstWhere(
      (type) => type.storageValue == value,
      orElse: () => MeetingContextType.lesson,
    );
  }
}

enum MeetingRole { host, participant }

extension MeetingRoleX on MeetingRole {
  String get storageValue {
    switch (this) {
      case MeetingRole.host:
        return 'host';
      case MeetingRole.participant:
        return 'participant';
    }
  }

  static MeetingRole fromStorage(String value) {
    return MeetingRole.values.firstWhere(
      (role) => role.storageValue == value,
      orElse: () => MeetingRole.participant,
    );
  }
}

class MeetingLink {
  const MeetingLink({
    required this.id,
    required this.contextType,
    required this.contextId,
    required this.roomName,
    required this.role,
    required this.url,
    required this.title,
    required this.createdAt,
    this.scheduledStart,
    this.reminderAt,
    this.reminderScheduled = false,
    this.recordingStoragePath,
    this.recordingUrl,
    this.recordingIndexedAt,
  });

  final String id;
  final MeetingContextType contextType;
  final String contextId;
  final String roomName;
  final MeetingRole role;
  final Uri url;
  final String title;
  final DateTime createdAt;
  final DateTime? scheduledStart;
  final DateTime? reminderAt;
  final bool reminderScheduled;
  final String? recordingStoragePath;
  final Uri? recordingUrl;
  final DateTime? recordingIndexedAt;

  MeetingLink copyWith({
    String? id,
    MeetingContextType? contextType,
    String? contextId,
    String? roomName,
    MeetingRole? role,
    Uri? url,
    String? title,
    DateTime? createdAt,
    DateTime? scheduledStart,
    bool removeScheduledStart = false,
    DateTime? reminderAt,
    bool removeReminderAt = false,
    bool? reminderScheduled,
    String? recordingStoragePath,
    bool removeRecordingStoragePath = false,
    Uri? recordingUrl,
    bool removeRecordingUrl = false,
    DateTime? recordingIndexedAt,
    bool removeRecordingIndexedAt = false,
  }) {
    return MeetingLink(
      id: id ?? this.id,
      contextType: contextType ?? this.contextType,
      contextId: contextId ?? this.contextId,
      roomName: roomName ?? this.roomName,
      role: role ?? this.role,
      url: url ?? this.url,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      scheduledStart:
          removeScheduledStart ? null : scheduledStart ?? this.scheduledStart,
      reminderAt: removeReminderAt ? null : reminderAt ?? this.reminderAt,
      reminderScheduled: reminderScheduled ?? this.reminderScheduled,
      recordingStoragePath: removeRecordingStoragePath
          ? null
          : recordingStoragePath ?? this.recordingStoragePath,
      recordingUrl:
          removeRecordingUrl ? null : recordingUrl ?? this.recordingUrl,
      recordingIndexedAt: removeRecordingIndexedAt
          ? null
          : recordingIndexedAt ?? this.recordingIndexedAt,
    );
  }
}

class MeetingLaunchRequest {
  const MeetingLaunchRequest({
    required this.contextType,
    required this.contextId,
    required this.title,
    required this.role,
    this.roomName,
    this.displayName,
    this.email,
    this.scheduledStart,
    this.createParticipantLink = false,
  });

  final MeetingContextType contextType;
  final String contextId;
  final String title;
  final MeetingRole role;
  final String? roomName;
  final String? displayName;
  final String? email;
  final DateTime? scheduledStart;
  final bool createParticipantLink;
}

class MeetingLaunchResult {
  const MeetingLaunchResult({
    required this.link,
    required this.roomName,
    this.wasLaunched = true,
    this.error,
  });

  final MeetingLink link;
  final String roomName;
  final bool wasLaunched;
  final Object? error;
}

extension MeetingLinkListX on List<MeetingLink> {
  MeetingLink? latestForRole(MeetingRole role) {
    final filtered = where((link) => link.role == role).toList();
    if (filtered.isEmpty) {
      return null;
    }
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered.first;
  }

  Iterable<MeetingLink> recordings() {
    return where((link) => link.recordingUrl != null).sorted((a, b) {
      final aTime =
          a.recordingIndexedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime =
          b.recordingIndexedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });
  }
}
