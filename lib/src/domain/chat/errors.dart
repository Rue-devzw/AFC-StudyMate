import 'entities.dart';

class ChatModerationException implements Exception {
  const ChatModerationException({
    required this.message,
    required this.actionType,
    required this.actionId,
    this.expiresAt,
    this.reason,
  });

  final String message;
  final ModerationActionType actionType;
  final String actionId;
  final DateTime? expiresAt;
  final String? reason;

  @override
  String toString() => message;
}
