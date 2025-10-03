import 'entities.dart';

abstract class ChatRepository {
  Stream<List<ChatMessage>> watchMessages(String classId);
  Future<void> addMessage(ChatMessage message);
  Future<void> flagMessage(String id, {bool flagged});
  Future<void> deleteMessage(String id);
}
