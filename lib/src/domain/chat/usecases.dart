import 'entities.dart';
import 'repositories.dart';

class WatchChatMessagesUseCase {
  final ChatRepository _repository;

  const WatchChatMessagesUseCase(this._repository);

  Stream<List<ChatMessage>> call(String classId) =>
      _repository.watchMessages(classId);
}

class SendChatMessageUseCase {
  final ChatRepository _repository;

  const SendChatMessageUseCase(this._repository);

  Future<void> call(ChatMessage message) =>
      _repository.addMessage(message);
}

class FlagChatMessageUseCase {
  final ChatRepository _repository;

  const FlagChatMessageUseCase(this._repository);

  Future<void> call(String id, {bool flagged = true}) =>
      _repository.flagMessage(id, flagged: flagged);
}

class DeleteChatMessageUseCase {
  final ChatRepository _repository;

  const DeleteChatMessageUseCase(this._repository);

  Future<void> call(String id) => _repository.deleteMessage(id);
}
