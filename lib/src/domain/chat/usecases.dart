import 'entities.dart';
import 'repositories.dart';

class WatchChatMessagesUseCase {
  final ChatRepository _repository;

  const WatchChatMessagesUseCase(this._repository);

  Stream<List<ChatMessage>> call(String classId) =>
      _repository.watchMessages(classId);
}

class WatchTypingStatusUseCase {
  final ChatRepository _repository;

  const WatchTypingStatusUseCase(this._repository);

  Stream<List<TypingStatus>> call(String classId) =>
      _repository.watchTyping(classId);
}

class WatchModerationActionsUseCase {
  final ChatRepository _repository;

  const WatchModerationActionsUseCase(this._repository);

  Stream<List<ModerationAction>> call(String classId) =>
      _repository.watchModerationActions(classId);
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

  Future<void> call(
    String id, {
    bool flagged = true,
    String? moderatorId,
    String? reason,
  }) =>
      _repository.flagMessage(
        id,
        flagged: flagged,
        moderatorId: moderatorId,
        reason: reason,
      );
}

class DeleteChatMessageUseCase {
  final ChatRepository _repository;

  const DeleteChatMessageUseCase(this._repository);

  Future<void> call(
    String id, {
    String? moderatorId,
    String? reason,
  }) =>
      _repository.deleteMessage(
        id,
        moderatorId: moderatorId,
        reason: reason,
      );
}

class MuteUserUseCase {
  final ChatRepository _repository;

  const MuteUserUseCase(this._repository);

  Future<void> call({
    required String classId,
    required String userId,
    required Duration duration,
    required String moderatorId,
    String? reason,
  }) =>
      _repository.muteUser(
        classId: classId,
        userId: userId,
        duration: duration,
        moderatorId: moderatorId,
        reason: reason,
      );
}

class BanUserUseCase {
  final ChatRepository _repository;

  const BanUserUseCase(this._repository);

  Future<void> call({
    required String classId,
    required String userId,
    required String moderatorId,
    String? reason,
  }) =>
      _repository.banUser(
        classId: classId,
        userId: userId,
        moderatorId: moderatorId,
        reason: reason,
      );
}

class ResolveModerationActionUseCase {
  final ChatRepository _repository;

  const ResolveModerationActionUseCase(this._repository);

  Future<void> call({
    required String actionId,
    required String moderatorId,
    String? notes,
  }) =>
      _repository.unbanOrUnmute(
        actionId: actionId,
        moderatorId: moderatorId,
        notes: notes,
      );
}

class SubmitModerationAppealUseCase {
  final ChatRepository _repository;

  const SubmitModerationAppealUseCase(this._repository);

  Future<void> call(ModerationAppeal appeal) =>
      _repository.submitAppeal(appeal);
}

class UpdateTypingStatusUseCase {
  final ChatRepository _repository;

  const UpdateTypingStatusUseCase(this._repository);

  Future<void> call({
    required String classId,
    required String userId,
    required bool isTyping,
  }) =>
      _repository.updateTyping(
        classId: classId,
        userId: userId,
        isTyping: isTyping,
      );
}
