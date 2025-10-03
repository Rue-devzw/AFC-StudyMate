import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../domain/chat/entities.dart';
import '../../domain/chat/usecases.dart';
import '../../domain/accounts/entities.dart';
import '../providers.dart';
import 'chat_controller.dart';

class ChatRoomScreen extends ConsumerWidget {
  const ChatRoomScreen({
    super.key,
    required this.classId,
    required this.className,
  });

  final String classId;
  final String className;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(chatMessagesProvider(classId));
    final typingAsync = ref.watch(typingStatusProvider(classId));
    final composerState = ref.watch(chatComposerControllerProvider(classId));
    final controller = ref.read(chatComposerControllerProvider(classId).notifier);
    final accountAsync = ref.watch(activeAccountProvider);

    final messages = messagesAsync.value ?? const <ChatMessage>[];
    final typingUsers = typingAsync.value ?? const <TypingStatus>[];

    final Map<String, String> userDisplayNames = {
      for (final message in messages)
        if (message.authorName != null && message.authorName!.isNotEmpty)
          message.userId: message.authorName!,
    };

    final typingNames = typingUsers
        .where((status) => status.isTyping)
        .map((status) {
          if (status.userId == accountAsync.asData?.value?.id) {
            return 'You';
          }
          return userDisplayNames[status.userId] ?? 'Someone';
        })
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Class Chat · $className'),
        actions: [
          IconButton(
            icon: const Icon(Icons.report),
            tooltip: 'Submit appeal',
            onPressed: () async {
              final account = accountAsync.asData?.value;
              if (account == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Create a profile to submit appeals.')),
                );
                return;
              }
              await showDialog<void>(
                context: context,
                builder: (context) {
                  final idController = TextEditingController();
                  final reasonController = TextEditingController();
                  return AlertDialog(
                    title: const Text('Appeal moderation action'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: idController,
                          decoration: const InputDecoration(
                            labelText: 'Action ID',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: reasonController,
                          decoration: const InputDecoration(
                            labelText: 'Why should this be reviewed?'
                                ' (shared with moderators)',
                          ),
                          maxLines: 4,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (idController.text.trim().isEmpty ||
                              reasonController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Provide an action ID and your message.'),
                              ),
                            );
                            return;
                          }
                          final appeal = ModerationAppeal(
                            id: const Uuid().v4(),
                            actionId: idController.text.trim(),
                            classId: classId,
                            userId: account.id,
                            message: reasonController.text.trim(),
                            createdAt: DateTime.now(),
                          );
                          await ref
                              .read(submitModerationAppealUseCaseProvider)
                              .call(appeal);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Appeal submitted. Moderators will review it.'),
                              ),
                            );
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: messagesAsync.when(
                data: (messages) {
                  if (messages.isEmpty) {
                    return const Center(
                      child: Text('No messages yet. Start the conversation!'),
                    );
                  }
                  return _MessageList(
                    messages: messages,
                    classId: classId,
                    accountAsync: accountAsync,
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Failed to load messages: $error'),
                  ),
                ),
              ),
            ),
            if (typingNames.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${typingNames.join(', ')} is typing…',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            _ComposerBar(
              state: composerState,
              controller: controller,
              onPickAttachments: () => _pickAttachments(context, controller),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAttachments(
    BuildContext context,
    ChatController controller,
  ) async {
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (result == null || result.files.isEmpty) {
        return;
      }
      for (final file in result.files) {
        final path = file.path;
        if (path == null) {
          continue;
        }
        final extension = p.extension(path).toLowerCase();
        final type = _attachmentType(extension);
        final attachment = ChatAttachment(
          id: const Uuid().v4(),
          type: type,
          name: file.name,
          url: '',
          localPath: path,
          sizeBytes: file.size,
        );
        controller.addAttachment(attachment);
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to add attachment: $error')),
        );
      }
    }
  }

  String _attachmentType(String extension) {
    switch (extension) {
      case '.png':
      case '.jpg':
      case '.jpeg':
      case '.gif':
      case '.bmp':
        return 'image';
      case '.pdf':
        return 'document';
      case '.mp3':
      case '.m4a':
      case '.wav':
        return 'audio';
      case '.mp4':
      case '.mov':
      case '.avi':
        return 'video';
      default:
        return 'file';
    }
  }
}

class _MessageList extends ConsumerWidget {
  const _MessageList({
    required this.messages,
    required this.classId,
    required this.accountAsync,
  });

  final List<ChatMessage> messages;
  final String classId;
  final AsyncValue<LocalAccount?> accountAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = accountAsync.asData?.value;
    return ListView.builder(
      reverse: false,
      padding: const EdgeInsets.all(16.0),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMine = account?.id == message.userId;
        return Align(
          alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
          child: _MessageBubble(
            message: message,
            isMine: isMine,
            classId: classId,
            account: account,
          ),
        );
      },
    );
  }
}

class _MessageBubble extends ConsumerWidget {
  const _MessageBubble({
    required this.message,
    required this.isMine,
    required this.classId,
    required this.account,
  });

  final ChatMessage message;
  final bool isMine;
  final String classId;
  final LocalAccount? account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bubbleColor = isMine
        ? theme.colorScheme.primary.withOpacity(0.12)
        : theme.colorScheme.surfaceVariant;
    final textColor = isMine ? theme.colorScheme.onPrimaryContainer : null;

    final children = <Widget>[
      if (message.authorName != null && message.authorName!.isNotEmpty)
        Text(
          message.authorName!,
          style: theme.textTheme.bodySmall
              ?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
        ),
      if (message.deleted)
        Text(
          'This message was removed',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontStyle: FontStyle.italic,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        )
      else
        Text(
          message.body,
          style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
        ),
      if (message.attachments.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            children: message.attachments
                .map((attachment) => ActionChip(
                      avatar: Icon(_attachmentIcon(attachment.type), size: 18),
                      label: Text(attachment.name),
                      onPressed: attachment.url.isEmpty
                          ? null
                          : () async {
                              final uri = Uri.parse(attachment.url);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri, mode: LaunchMode.externalApplication);
                              }
                            },
                    ))
                .toList(),
          ),
        ),
      Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatTimestamp(message.createdAt),
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (message.flagged)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(Icons.flag, color: theme.colorScheme.error, size: 16),
              ),
          ],
        ),
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ...children,
          Align(
            alignment: Alignment.centerRight,
            child: PopupMenuButton<_MessageAction>(
              tooltip: 'Moderation tools',
              icon: const Icon(Icons.more_horiz, size: 18),
              onSelected: (value) => _handleAction(context, ref, value),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: _MessageAction.flag,
                  child: Text('Flag message'),
                ),
                const PopupMenuItem(
                  value: _MessageAction.delete,
                  child: Text('Delete message'),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: _MessageAction.mute,
                  child: Text('Mute user (15 min)'),
                ),
                const PopupMenuItem(
                  value: _MessageAction.ban,
                  child: Text('Ban user'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _attachmentIcon(String type) {
    switch (type) {
      case 'image':
        return Icons.image_outlined;
      case 'document':
        return Icons.description_outlined;
      case 'audio':
        return Icons.audiotrack;
      case 'video':
        return Icons.videocam_outlined;
      default:
        return Icons.attach_file;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final timeOfDay = TimeOfDay.fromDateTime(timestamp.toLocal());
    final hour = timeOfDay.hourOfPeriod == 0 ? 12 : timeOfDay.hourOfPeriod;
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    final suffix = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:$minute $suffix';
  }

  Future<void> _handleAction(
    BuildContext context,
    WidgetRef ref,
    _MessageAction action,
  ) async {
    final accountId = account?.id;
    if (accountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Moderation tools require an active profile.')),
      );
      return;
    }
    switch (action) {
      case _MessageAction.flag:
        final reason = await _promptModerationReason(context, 'Flag reason');
        if (reason == null) {
          return;
        }
        await ref.read(flagChatMessageUseCaseProvider).call(
              message.id,
              flagged: true,
              moderatorId: accountId,
              reason: reason,
            );
        break;
      case _MessageAction.delete:
        final reason = await _promptModerationReason(context, 'Delete reason');
        if (reason == null) {
          return;
        }
        await ref.read(deleteChatMessageUseCaseProvider).call(
              message.id,
              moderatorId: accountId,
              reason: reason,
            );
        break;
      case _MessageAction.mute:
        await ref.read(muteUserUseCaseProvider).call(
              classId: classId,
              userId: message.userId,
              duration: const Duration(minutes: 15),
              moderatorId: accountId,
              reason: 'Muted via chat UI',
            );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Muted ${message.authorName ?? message.userId}.')),
        );
        break;
      case _MessageAction.ban:
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Ban user?'),
            content: Text(
              'Ban ${message.authorName ?? message.userId} from this class chat?'
              ' This action can be appealed.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Ban'),
              ),
            ],
          ),
        );
        if (confirm == true) {
          await ref.read(banUserUseCaseProvider).call(
                classId: classId,
                userId: message.userId,
                moderatorId: accountId,
                reason: 'Banned via chat UI',
              );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Banned ${message.authorName ?? message.userId}.')),
          );
        }
        break;
    }
  }

  Future<String?> _promptModerationReason(
    BuildContext context,
    String label,
  ) async {
    final controller = TextEditingController();
    return showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(label),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Provide context for the action',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class _ComposerBar extends StatefulWidget {
  const _ComposerBar({
    required this.state,
    required this.controller,
    required this.onPickAttachments,
  });

  final ChatComposerState state;
  final ChatController controller;
  final VoidCallback onPickAttachments;

  @override
  State<_ComposerBar> createState() => _ComposerBarState();
}

class _ComposerBarState extends State<_ComposerBar> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.state.text);
  }

  @override
  void didUpdateWidget(covariant _ComposerBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.text != _textController.text) {
      _textController.value = TextEditingValue(
        text: widget.state.text,
        selection: TextSelection.collapsed(offset: widget.state.text.length),
      );
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: const [
            BoxShadow(blurRadius: 4, color: Colors.black12, offset: Offset(0, -2)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state.attachments.isNotEmpty)
              SizedBox(
                height: 72,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: state.attachments
                      .map(
                        (attachment) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Chip(
                            label: Text(attachment.name),
                            avatar: Icon(_attachmentPreviewIcon(attachment.type)),
                            onDeleted: () => widget.controller.removeAttachment(attachment.id),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: widget.onPickAttachments,
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    onChanged: widget.controller.setText,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Write a message…',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                state.isSending
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.send),
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: state.canSend ? widget.controller.send : null,
                      ),
              ],
            ),
            if (state.errorMessage != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    state.errorMessage!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _attachmentPreviewIcon(String type) {
    switch (type) {
      case 'image':
        return Icons.image;
      case 'document':
        return Icons.picture_as_pdf;
      case 'audio':
        return Icons.audiotrack;
      case 'video':
        return Icons.videocam;
      default:
        return Icons.insert_drive_file;
    }
  }
}

enum _MessageAction { flag, delete, mute, ban }
