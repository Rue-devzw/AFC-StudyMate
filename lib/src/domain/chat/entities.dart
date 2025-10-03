class ChatMessage {
  final String id;
  final String classId;
  final String userId;
  final String body;
  final DateTime createdAt;
  final bool deleted;
  final bool flagged;

  const ChatMessage({
    required this.id,
    required this.classId,
    required this.userId,
    required this.body,
    required this.createdAt,
    this.deleted = false,
    this.flagged = false,
  });
}
