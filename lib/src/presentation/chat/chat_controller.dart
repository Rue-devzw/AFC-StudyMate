import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/chat/entities.dart';
import '../../domain/chat/errors.dart';
import '../../domain/chat/usecases.dart';
import '../../domain/accounts/entities.dart';
import '../providers.dart';

class ChatComposerState {
  final String text;
  final List<ChatAttachment> attachments;
  final bool isSending;
  final String? errorMessage;
  final bool isTyping;

  const ChatComposerState({
    this.text = '',
    this.attachments = const [],
    this.isSending = false,
    this.errorMessage,
    this.isTyping = false,
  });

  bool get canSend => text.trim().isNotEmpty || attachments.isNotEmpty;

  ChatComposerState copyWith({
    String? text,
    List<ChatAttachment>? attachments,
    bool? isSending,
    String? errorMessage,
    bool? isTyping,
  }) {
    return ChatComposerState(
      text: text ?? this.text,
      attachments: attachments ?? this.attachments,
      isSending: isSending ?? this.isSending,
      errorMessage: errorMessage,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

class ChatController extends StateNotifier<ChatComposerState> {
  ChatController(this._ref, this.classId)
      : super(const ChatComposerState()) {
    _activeAccountSub = _ref.listen<AsyncValue<LocalAccount?>>(activeAccountProvider,
        (_, next) {
      next.whenData((account) {
        _currentAccount = account;
      });
    });
  }

  final Ref _ref;
  final String classId;
  LocalAccount? _currentAccount;
  late final ProviderSubscription<AsyncValue<LocalAccount?>> _activeAccountSub;
  Timer? _typingDebounce;

  SendChatMessageUseCase get _sendMessage =>
      _ref.read(sendChatMessageUseCaseProvider);
  UpdateTypingStatusUseCase get _updateTyping =>
      _ref.read(updateTypingStatusUseCaseProvider);

  void setText(String value) {
    state = state.copyWith(text: value, errorMessage: null);
    _markTyping(value.trim().isNotEmpty);
  }

  void addAttachment(ChatAttachment attachment) {
    final next = [...state.attachments, attachment];
    state = state.copyWith(attachments: next, errorMessage: null);
    _markTyping(true);
  }

  void removeAttachment(String attachmentId) {
    final next = state.attachments
        .where((attachment) => attachment.id != attachmentId)
        .toList(growable: false);
    state = state.copyWith(attachments: next, errorMessage: null);
  }

  Future<void> send() async {
    final account = _currentAccount;
    if (account == null) {
      state = state.copyWith(
        errorMessage: 'You need an active profile to send messages.',
      );
      return;
    }
    if (!state.canSend) {
      return;
    }
    final now = DateTime.now();
    final message = ChatMessage(
      id: const Uuid().v4(),
      classId: classId,
      userId: account.id,
      body: state.text.trim(),
      createdAt: now,
      updatedAt: now,
      attachments: state.attachments,
      authorName: account.displayName,
    );
    state = state.copyWith(isSending: true, errorMessage: null);
    try {
      await _sendMessage(message);
      state = const ChatComposerState();
      await _updateTyping(
        classId: classId,
        userId: account.id,
        isTyping: false,
      );
    } catch (error) {
      final errorMessage = error is ChatModerationException
          ? error.message
          : 'Failed to send message: $error';
      state = state.copyWith(
        isSending: false,
        errorMessage: errorMessage,
      );
    }
  }

  void _markTyping(bool typing) {
    if (_currentAccount == null) {
      return;
    }
    final userId = _currentAccount!.id;
    _typingDebounce?.cancel();
    if (typing) {
      if (!state.isTyping) {
        state = state.copyWith(isTyping: true);
        unawaited(
          _updateTyping(
            classId: classId,
            userId: userId,
            isTyping: true,
          ),
        );
      }
      _typingDebounce = Timer(const Duration(seconds: 4), () {
        _markTyping(false);
      });
    } else {
      state = state.copyWith(isTyping: false);
      unawaited(
        _updateTyping(
          classId: classId,
          userId: userId,
          isTyping: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    _typingDebounce?.cancel();
    if (_currentAccount != null) {
      unawaited(
        _updateTyping(
          classId: classId,
          userId: _currentAccount!.id,
          isTyping: false,
        ),
      );
    }
    _activeAccountSub.close();
    super.dispose();
  }
}

final chatComposerControllerProvider = StateNotifierProvider.autoDispose
    .family<ChatController, ChatComposerState, String>((ref, classId) {
  return ChatController(ref, classId);
});

final chatMessagesProvider = StreamProvider.autoDispose
    .family<List<ChatMessage>, String>((ref, classId) {
  final useCase = ref.watch(watchChatMessagesUseCaseProvider);
  return useCase(classId);
});

final typingStatusProvider = StreamProvider.autoDispose
    .family<List<TypingStatus>, String>((ref, classId) {
  final useCase = ref.watch(watchTypingStatusUseCaseProvider);
  return useCase(classId);
});

final moderationActionsProvider = StreamProvider.autoDispose
    .family<List<ModerationAction>, String>((ref, classId) {
  final useCase = ref.watch(watchModerationActionsUseCaseProvider);
  return useCase(classId);
});
