import 'entities.dart';

abstract class ChatRepository {
  Stream<List<ChatMessage>> watchMessages(String classId);
  Stream<List<TypingStatus>> watchTyping(String classId);
  Stream<List<ModerationAction>> watchModerationActions(String classId);
  Future<void> addMessage(ChatMessage message);
  Future<void> flagMessage(
    String id, {
    bool flagged = true,
    String? moderatorId,
    String? reason,
  });
  Future<void> deleteMessage(
    String id, {
    String? moderatorId,
    String? reason,
  });
  Future<void> muteUser({
    required String classId,
    required String userId,
    required Duration duration,
    required String moderatorId,
    String? reason,
  });
  Future<void> banUser({
    required String classId,
    required String userId,
    required String moderatorId,
    String? reason,
  });
  Future<void> unbanOrUnmute({
    required String actionId,
    required String moderatorId,
    String? notes,
  });
  Future<void> submitAppeal(ModerationAppeal appeal);
  Future<void> updateTyping({
    required String classId,
    required String userId,
    required bool isTyping,
  });
}
