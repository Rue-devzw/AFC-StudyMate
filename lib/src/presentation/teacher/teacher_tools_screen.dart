import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/accounts/entities.dart';
import '../../domain/lessons/entities.dart';
import '../../domain/meetings/entities.dart';
import '../providers.dart';

final _lessonDraftsProvider =
    StreamProvider.autoDispose<List<LessonDraft>>((ref) {
  final userId = ref.watch(activeUserIdProvider);
  if (userId == null) {
    return Stream<List<LessonDraft>>.empty();
  }
  return ref.watch(watchLessonDraftsUseCaseProvider)(userId);
});

final _pendingDraftsProvider =
    StreamProvider.autoDispose<List<LessonDraft>>((ref) {
  return ref.watch(watchPendingDraftApprovalsUseCaseProvider)();
});

final _roundtableSessionsProvider =
    StreamProvider.autoDispose<List<RoundtableSession>>((ref) {
  final account = ref.watch(activeAccountProvider);
  final classId = account.maybeWhen(
    data: (value) => value?.preferredCohortId,
    orElse: () => null,
  );
  return ref.watch(watchRoundtablesUseCaseProvider)(classId);
});

final _forumThreadsProvider =
    StreamProvider.autoDispose<List<DiscussionThread>>((ref) {
  final account = ref.watch(activeAccountProvider);
  final classId = account.maybeWhen(
    data: (value) => value?.preferredCohortId,
    orElse: () => null,
  );
  if (classId == null) {
    return Stream<List<DiscussionThread>>.empty();
  }
  return ref.watch(watchForumThreadsUseCaseProvider)(classId);
});

final _forumPostsProvider = StreamProvider.autoDispose
    .family<List<DiscussionPost>, String>((ref, threadId) {
  return ref.watch(watchForumPostsUseCaseProvider)(threadId);
});

class TeacherToolsScreen extends ConsumerWidget {
  const TeacherToolsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roles = ref.watch(userRolesProvider);
    if (!roles.contains('teacher')) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'You need teacher permissions to access these tools. '
            'Please contact an administrator.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Teacher Tools'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Lesson Editor'),
              Tab(text: 'Roundtables'),
              Tab(text: 'Forums'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _LessonEditorTab(),
            _RoundtableSchedulerTab(),
            _DiscussionForumTab(),
          ],
        ),
      ),
    );
  }
}

class _LessonEditorTab extends ConsumerStatefulWidget {
  const _LessonEditorTab();

  @override
  ConsumerState<_LessonEditorTab> createState() => _LessonEditorTabState();
}

class _LessonEditorTabState extends ConsumerState<_LessonEditorTab> {
  final _titleController = TextEditingController();
  late QuillController _controller;
  LessonDraft? _selectedDraft;
  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    _controller = QuillController.basic();
    _controller.addListener(_markDirty);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _controller.removeListener(_markDirty);
    _controller.dispose();
    super.dispose();
  }

  void _loadDraft(LessonDraft? draft) {
    _controller.removeListener(_markDirty);
    _controller.dispose();
    _selectedDraft = draft;
    _titleController.text = draft?.title ?? '';
    final delta = draft == null
        ? Document()
        : Document.fromJson(jsonDecode(draft.deltaJson) as List);
    _controller = QuillController(
      document: delta,
      selection: const TextSelection.collapsed(offset: 0),
    );
    _controller.addListener(_markDirty);
    setState(() {
      _dirty = false;
    });
  }

  void _markDirty() {
    if (mounted) {
      setState(() {
        _dirty = true;
      });
    }
  }

  Future<void> _saveDraft(
      BuildContext context, LessonDraftStatus status) async {
    final userId = ref.read(activeUserIdProvider);
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign in to manage drafts.')),
      );
      return;
    }
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty.')),
      );
      return;
    }
    final deltaJson = jsonEncode(_controller.document.toDelta().toJson());
    final now = DateTime.now();
    final draftId = _selectedDraft?.id ?? const Uuid().v4();
    final draft = LessonDraft(
      id: draftId,
      lessonId: _selectedDraft?.lessonId,
      authorId: userId,
      title: title,
      deltaJson: deltaJson,
      status: status,
      approverId:
          status == LessonDraftStatus.draft ? _selectedDraft?.approverId : null,
      reviewerComment: status == LessonDraftStatus.draft
          ? _selectedDraft?.reviewerComment
          : null,
      createdAt: _selectedDraft?.createdAt ?? now,
      updatedAt: now,
    );
    await ref.read(saveLessonDraftUseCaseProvider)(draft);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(status == LessonDraftStatus.submitted
              ? 'Draft submitted for approval.'
              : 'Draft saved locally.'),
        ),
      );
      setState(() {
        _selectedDraft = draft;
        _dirty = false;
      });
    }
  }

  Future<void> _approveDraft(
    BuildContext context,
    LessonDraft draft,
    LessonDraftStatus status,
  ) async {
    final userId = ref.read(activeUserIdProvider);
    if (userId == null) {
      return;
    }
    String? comment;
    if (status == LessonDraftStatus.rejected) {
      comment = await showDialog<String?>(
        context: context,
        builder: (context) {
          final controller = TextEditingController();
          return AlertDialog(
            title: const Text('Provide feedback'),
            content: TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Let the author know what to change.',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, controller.text.trim()),
                child: const Text('Submit'),
              ),
            ],
          );
        },
      );
      if (comment == null) {
        return;
      }
    }
    final updated = draft.copyWith(
      status: status,
      approverId: userId,
      reviewerComment: status == LessonDraftStatus.rejected ? comment : null,
      updatedAt: DateTime.now(),
    );
    await ref.read(saveLessonDraftUseCaseProvider)(updated);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(status == LessonDraftStatus.approved
              ? 'Draft approved and synced.'
              : 'Draft rejected and feedback sent.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final draftsAsync = ref.watch(_lessonDraftsProvider);
    final pendingAsync = ref.watch(_pendingDraftsProvider);
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: draftsAsync.when(
            data: (drafts) => ListView(
              children: [
                ListTile(
                  title: const Text('New draft'),
                  leading: const Icon(Icons.create),
                  onTap: () => _loadDraft(null),
                ),
                for (final draft in drafts)
                  ListTile(
                    selected: _selectedDraft?.id == draft.id,
                    title: Text(draft.title),
                    subtitle: Text(
                      '${draft.status.name} • '
                      '${draft.updatedAt.toLocal()}',
                    ),
                    onTap: () => _loadDraft(draft),
                  ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Pending approvals',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                pendingAsync.when(
                  data: (pending) => Column(
                    children: pending.isEmpty
                        ? [
                            const ListTile(
                              title: Text('No drafts awaiting review.'),
                            ),
                          ]
                        : pending
                            .map(
                              (draft) => ListTile(
                                title: Text(draft.title),
                                subtitle: Text('Author: ${draft.authorId}'),
                                trailing: Wrap(
                                  spacing: 8,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.check_circle,
                                          color: Colors.green),
                                      tooltip: 'Approve draft',
                                      onPressed: () => _approveDraft(context,
                                          draft, LessonDraftStatus.approved),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.cancel,
                                          color: Colors.redAccent),
                                      tooltip: 'Reject draft',
                                      onPressed: () => _approveDraft(
                                        context,
                                        draft,
                                        LessonDraftStatus.rejected,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                  ),
                  error: (error, stackTrace) => ListTile(
                    title: Text('Failed to load approvals: $error'),
                  ),
                  loading: () => const ListTile(
                    title: Text('Loading approvals…'),
                  ),
                ),
              ],
            ),
            error: (error, stackTrace) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Failed to load drafts: $error'),
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
        VerticalDivider(color: Theme.of(context).dividerColor),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Lesson title',
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Column(
                    children: [
                      QuillToolbar.simple(controller: _controller),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: QuillEditor.basic(
                            controller: _controller,
                            configurations: const QuillEditorConfigurations(
                              expands: true,
                              padding: EdgeInsets.all(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _dirty
                          ? () => _saveDraft(context, LessonDraftStatus.draft)
                          : null,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Save Draft'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: () =>
                          _saveDraft(context, LessonDraftStatus.submitted),
                      icon: const Icon(Icons.send),
                      label: const Text('Submit for approval'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RoundtableSchedulerTab extends ConsumerStatefulWidget {
  const _RoundtableSchedulerTab();

  @override
  ConsumerState<_RoundtableSchedulerTab> createState() =>
      _RoundtableSchedulerTabState();
}

class _RoundtableSchedulerTabState
    extends ConsumerState<_RoundtableSchedulerTab> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _urlController = TextEditingController();
  int _reminderMinutes = 30;
  late DateTime _startTime;
  late DateTime _endTime;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startTime = now.add(const Duration(hours: 1));
    _endTime = _startTime.add(const Duration(hours: 1));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  bool _canHost(LocalAccount? account) {
    if (account == null) {
      return false;
    }
    final roles = account.roles.map((role) => role.toLowerCase()).toSet();
    return roles.contains('teacher') ||
        roles.contains('facilitator') ||
        roles.contains('admin');
  }

  Future<void> _pickDateTime(BuildContext context, bool isStart) async {
    final initial = isStart ? _startTime : _endTime;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate == null) {
      return;
    }
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (pickedTime == null) {
      return;
    }
    final combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    setState(() {
      if (isStart) {
        _startTime = combined;
        if (_endTime.isBefore(_startTime)) {
          _endTime = _startTime.add(const Duration(hours: 1));
        }
      } else {
        _endTime = combined;
      }
    });
  }

  Future<void> _createRoundtable(BuildContext context) async {
    final userId = ref.read(activeUserIdProvider);
    final account = ref.read(activeAccountProvider).asData?.value;
    if (userId == null || account == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select an active account to schedule.')),
      );
      return;
    }
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title is required.')),
      );
      return;
    }
    final now = DateTime.now();
    final trimmedUrl = _urlController.text.trim();
    String? hostUrl;
    String? attendeeUrl;
    String? meetingRoom;
    if (trimmedUrl.isNotEmpty) {
      attendeeUrl = trimmedUrl;
      hostUrl = trimmedUrl;
      final uri = Uri.tryParse(trimmedUrl);
      if (uri != null && uri.pathSegments.isNotEmpty) {
        meetingRoom = uri.pathSegments.last;
      }
    }
    final session = RoundtableSession(
      id: const Uuid().v4(),
      title: title,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      classId: account.preferredCohortId,
      startTime: _startTime,
      endTime: _endTime,
      conferencingUrl: attendeeUrl,
      hostConferencingUrl: hostUrl,
      meetingRoom: meetingRoom,
      reminderMinutesBefore: _reminderMinutes,
      createdBy: userId,
      updatedAt: now,
    );
    await ref.read(saveRoundtableUseCaseProvider)(session);
    await ref.read(notificationServiceProvider).scheduleRoundtableReminder(
          session.id,
          session.title,
          session.startTime,
          session.reminderMinutesBefore,
        );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Roundtable scheduled and synced.')),
      );
      _titleController.clear();
      _descriptionController.clear();
      _urlController.clear();
    }
  }

  Future<void> _joinRoundtable(
    BuildContext context,
    RoundtableSession session,
    MeetingRole role,
  ) async {
    final account = ref.read(activeAccountProvider).asData?.value;
    final launcher = ref.read(meetingLauncherProvider);
    final result = await launcher.launch(
      MeetingLaunchRequest(
        contextType: MeetingContextType.roundtable,
        contextId: session.id,
        title: session.title,
        role: role,
        roomName: session.meetingRoom,
        displayName: account?.displayName,
        scheduledStart: session.startTime,
        createParticipantLink: role == MeetingRole.host,
      ),
    );
    if (!mounted) {
      return;
    }
    final message = result.wasLaunched
        ? 'Joining ${role == MeetingRole.host ? 'as host' : 'as attendee'}.'
        : 'Offline - meeting link saved for later.';
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final sessionsAsync = ref.watch(_roundtableSessionsProvider);
    final account = ref.watch(activeAccountProvider).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
    final canHost = _canHost(account);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Session title'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _descriptionController,
            maxLines: 2,
            decoration:
                const InputDecoration(labelText: 'Description (optional)'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _urlController,
            decoration: const InputDecoration(
              labelText: 'Conferencing URL (optional)',
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.schedule),
                label: Text('Start: ${_startTime.toLocal()}'),
                onPressed: () => _pickDateTime(context, true),
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.event),
                label: Text('End: ${_endTime.toLocal()}'),
                onPressed: () => _pickDateTime(context, false),
              ),
              DropdownButton<int>(
                value: _reminderMinutes,
                items: const [
                  DropdownMenuItem(value: 15, child: Text('15 min reminder')),
                  DropdownMenuItem(value: 30, child: Text('30 min reminder')),
                  DropdownMenuItem(value: 60, child: Text('1 hour reminder')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _reminderMinutes = value);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.icon(
              onPressed: () => _createRoundtable(context),
              icon: const Icon(Icons.add_circle),
              label: const Text('Schedule Roundtable'),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: sessionsAsync.when(
              data: (sessions) => ListView.builder(
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final session = sessions[index];
                  return Card(
                    child: ListTile(
                      title: Text(session.title),
                      subtitle: Text(
                        '${session.startTime.toLocal()} — '
                        '${session.endTime.toLocal()}\n'
                        'Reminder: ${session.reminderMinutesBefore} minutes before\n'
                        'Meeting room: '
                        '${session.meetingRoom ?? 'Assigned when host joins'}',
                      ),
                      isThreeLine: true,
                      trailing: Wrap(
                        spacing: 4,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.video_call_outlined),
                            tooltip: 'Host meeting',
                            onPressed: canHost
                                ? () => _joinRoundtable(
                                      context,
                                      session,
                                      MeetingRole.host,
                                    )
                                : null,
                          ),
                          IconButton(
                            icon: const Icon(Icons.group_outlined),
                            tooltip: 'Join meeting',
                            onPressed: session.meetingRoom == null
                                ? null
                                : () => _joinRoundtable(
                                      context,
                                      session,
                                      MeetingRole.participant,
                                    ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel),
                            onPressed: () async {
                              await ref.read(cancelRoundtableUseCaseProvider)(
                                  session.id);
                              await ref
                                  .read(notificationServiceProvider)
                                  .cancelRoundtableReminder(session.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              error: (error, stackTrace) => Center(
                child: Text('Failed to load sessions: $error'),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscussionForumTab extends ConsumerStatefulWidget {
  const _DiscussionForumTab();

  @override
  ConsumerState<_DiscussionForumTab> createState() =>
      _DiscussionForumTabState();
}

class _DiscussionForumTabState extends ConsumerState<_DiscussionForumTab> {
  String? _selectedThreadId;
  final _threadTitleController = TextEditingController();
  final _postBodyController = TextEditingController();

  @override
  void dispose() {
    _threadTitleController.dispose();
    _postBodyController.dispose();
    super.dispose();
  }

  Future<void> _createThread(BuildContext context) async {
    final classId =
        ref.read(activeAccountProvider).asData?.value?.preferredCohortId;
    final userId = ref.read(activeUserIdProvider);
    if (classId == null || userId == null) {
      return;
    }
    final title = _threadTitleController.text.trim();
    if (title.isEmpty) {
      return;
    }
    final thread = DiscussionThread(
      id: const Uuid().v4(),
      classId: classId,
      title: title,
      createdBy: userId,
      status: 'open',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await ref.read(upsertForumThreadUseCaseProvider)(thread);
    setState(() => _selectedThreadId = thread.id);
    _threadTitleController.clear();
  }

  Future<void> _submitPost(BuildContext context) async {
    final threadId = _selectedThreadId;
    if (threadId == null) {
      return;
    }
    final userId = ref.read(activeUserIdProvider);
    if (userId == null) {
      return;
    }
    final roles = ref.read(userRolesProvider);
    final canPublish = roles.contains('teacher') || roles.contains('moderator');
    final body = _postBodyController.text.trim();
    if (body.isEmpty) {
      return;
    }
    final post = DiscussionPost(
      id: const Uuid().v4(),
      threadId: threadId,
      authorId: userId,
      role: roles.isEmpty ? 'member' : roles.first,
      body: body,
      status: canPublish
          ? DiscussionPostStatus.published
          : DiscussionPostStatus.pending,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await ref.read(upsertForumPostUseCaseProvider)(post);
    _postBodyController.clear();
    if (mounted && !canPublish) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post submitted for moderator approval.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final roles = ref.watch(userRolesProvider);
    final threadsAsync = ref.watch(_forumThreadsProvider);
    final postsAsync = _selectedThreadId == null
        ? const AsyncValue<List<DiscussionPost>>.data(<DiscussionPost>[])
        : ref.watch(_forumPostsProvider(_selectedThreadId!));
    final canModerate =
        roles.contains('teacher') || roles.contains('moderator');
    final canPost = roles.contains('teacher') ||
        roles.contains('moderator') ||
        roles.contains('student');

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _threadTitleController,
                  decoration: InputDecoration(
                    labelText: 'New thread title',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add_comment),
                      onPressed: roles.contains('teacher')
                          ? () => _createThread(context)
                          : null,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: threadsAsync.when(
                  data: (threads) => ListView.builder(
                    itemCount: threads.length,
                    itemBuilder: (context, index) {
                      final thread = threads[index];
                      return ListTile(
                        selected: _selectedThreadId == thread.id,
                        title: Text(thread.title),
                        subtitle: Text('Opened by ${thread.createdBy}'),
                        onTap: () => setState(() {
                          _selectedThreadId = thread.id;
                        }),
                      );
                    },
                  ),
                  error: (error, stackTrace) => Center(
                    child: Text('Failed to load threads: $error'),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ],
          ),
        ),
        VerticalDivider(color: Theme.of(context).dividerColor),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              if (!canPost)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Your current role does not allow posting. '
                    'You can still review discussions.',
                    textAlign: TextAlign.center,
                  ),
                ),
              Expanded(
                child: postsAsync.when(
                  data: (posts) => ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          title: Text(post.body),
                          subtitle: Text(
                            '${post.authorId} • ${post.status.name}',
                          ),
                          trailing: canModerate &&
                                  post.status == DiscussionPostStatus.pending
                              ? PopupMenuButton<DiscussionPostStatus>(
                                  onSelected: (status) {
                                    final updated = DiscussionPost(
                                      id: post.id,
                                      threadId: post.threadId,
                                      authorId: post.authorId,
                                      role: post.role,
                                      body: post.body,
                                      status: status,
                                      createdAt: post.createdAt,
                                      updatedAt: DateTime.now(),
                                    );
                                    ref.read(upsertForumPostUseCaseProvider)(
                                        updated);
                                  },
                                  itemBuilder: (context) => const [
                                    PopupMenuItem(
                                      value: DiscussionPostStatus.published,
                                      child: Text('Approve'),
                                    ),
                                    PopupMenuItem(
                                      value: DiscussionPostStatus.rejected,
                                      child: Text('Reject'),
                                    ),
                                  ],
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                  error: (error, stackTrace) => Center(
                    child: Text('Failed to load posts: $error'),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              if (canPost)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _postBodyController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Share a reply',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _selectedThreadId == null
                            ? null
                            : () => _submitPost(context),
                        child: const Text('Post'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
