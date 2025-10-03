import 'dart:math';

import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:uuid/uuid.dart';

import '../../domain/meetings/entities.dart';
import '../../domain/meetings/repositories.dart';
import '../../domain/meetings/services.dart';
import '../notifications/notification_service.dart';

class JitsiMeetingLauncher implements MeetingLauncher {
  JitsiMeetingLauncher({
    required MeetingRepository repository,
    required NotificationService notificationService,
    JitsiMeet? sdk,
  })  : _repository = repository,
        _notificationService = notificationService,
        _sdk = sdk ?? JitsiMeet();

  final MeetingRepository _repository;
  final NotificationService _notificationService;
  final JitsiMeet _sdk;
  final _uuid = const Uuid();
  final _random = Random();

  @override
  Future<MeetingLaunchResult> launch(MeetingLaunchRequest request) async {
    final now = DateTime.now();
    final roomName = request.roomName ?? _generateRoomName(request);
    final deepLink = Uri.parse('https://meet.jit.si/$roomName');
    final reminderAt = request.scheduledStart == null
        ? null
        : request.scheduledStart!.subtract(const Duration(minutes: 5));
    final link = MeetingLink(
      id: _uuid.v4(),
      contextType: request.contextType,
      contextId: request.contextId,
      roomName: roomName,
      role: request.role,
      url: deepLink,
      title: request.title,
      createdAt: now,
      scheduledStart: request.scheduledStart,
      reminderAt: reminderAt,
    );

    await _repository.saveLink(link);
    if (request.createParticipantLink) {
      final participantLink = link.copyWith(
        id: _uuid.v4(),
        role: MeetingRole.participant,
        url: deepLink,
      );
      await _repository.saveLink(participantLink);
    }

    if (reminderAt != null) {
      await _notificationService.scheduleMeetingReminder(
        link.id,
        link.title,
        request.scheduledStart!,
        role: request.role,
      );
      await _repository.markReminderScheduled(link.id);
    }

    try {
      final options = JitsiMeetConferenceOptions(
        room: roomName,
        userInfo: JitsiMeetUserInfo(
          displayName: request.displayName ?? '',
          email: request.email ?? '',
        ),
        configOverrides: <String, Object?>{
          'subject': request.title,
          'startWithAudioMuted': request.role == MeetingRole.participant,
          'startWithVideoMuted': false,
          'prejoinPageEnabled': request.role != MeetingRole.host,
        },
        featureFlags: <String, Object>{
          'welcomepage.enabled': false,
          'recording.enabled': request.role == MeetingRole.host,
          'live-streaming.enabled': request.role == MeetingRole.host,
        },
      );
      await _sdk.join(options);
      return MeetingLaunchResult(link: link, roomName: roomName);
    } catch (error) {
      return MeetingLaunchResult(
        link: link,
        roomName: roomName,
        wasLaunched: false,
        error: error,
      );
    }
  }

  String _generateRoomName(MeetingLaunchRequest request) {
    final prefix = request.contextType == MeetingContextType.lesson
        ? 'lesson'
        : 'roundtable';
    final suffix = _random.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0');
    return '${prefix}_${request.contextId}_$suffix';
  }
}
