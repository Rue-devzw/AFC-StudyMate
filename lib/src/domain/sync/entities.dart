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
