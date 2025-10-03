class SyncOperation {
  final String id;
  final String userId;
  final String opType;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final DateTime? lastTriedAt;
  final int attempts;

  const SyncOperation({
    required this.id,
    required this.userId,
    required this.opType,
    required this.payload,
    required this.createdAt,
    this.lastTriedAt,
    this.attempts = 0,
  });
}

enum SyncEntityType { note, progress, message }

class SyncConflict {
  final SyncEntityType entityType;
  final String entityId;
  final String userId;
  final String reason;
  final Map<String, dynamic>? remoteSnapshot;
  final DateTime detectedAt;

  const SyncConflict({
    required this.entityType,
    required this.entityId,
    required this.userId,
    required this.reason,
    this.remoteSnapshot,
    required this.detectedAt,
  });
}

class SyncStatus {
  final bool isSyncing;
  final int pendingOperations;
  final DateTime? lastSyncedAt;
  final String? lastError;
  final bool lastSyncWasManual;

  const SyncStatus({
    this.isSyncing = false,
    this.pendingOperations = 0,
    this.lastSyncedAt,
    this.lastError,
    this.lastSyncWasManual = false,
  });

  SyncStatus copyWith({
    bool? isSyncing,
    int? pendingOperations,
    DateTime? lastSyncedAt,
    bool clearLastSyncedAt = false,
    String? lastError,
    bool clearLastError = false,
    bool? lastSyncWasManual,
  }) {
    return SyncStatus(
      isSyncing: isSyncing ?? this.isSyncing,
      pendingOperations: pendingOperations ?? this.pendingOperations,
      lastSyncedAt:
          clearLastSyncedAt ? null : (lastSyncedAt ?? this.lastSyncedAt),
      lastError: clearLastError ? null : (lastError ?? this.lastError),
      lastSyncWasManual: lastSyncWasManual ?? this.lastSyncWasManual,
    );
  }
}
