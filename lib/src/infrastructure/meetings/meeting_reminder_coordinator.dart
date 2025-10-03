import 'dart:async';

import '../../domain/meetings/entities.dart';
import '../../domain/meetings/repositories.dart';
import '../notifications/notification_service.dart';

class MeetingReminderCoordinator {
  MeetingReminderCoordinator(
    this._repository,
    this._notificationService,
  ) {
    _subscription = _repository.watchPendingReminders().listen(_handle);
  }

  final MeetingRepository _repository;
  final NotificationService _notificationService;
  StreamSubscription<List<MeetingLink>>? _subscription;

  Future<void> dispose() async {
    await _subscription?.cancel();
  }

  Future<void> _handle(List<MeetingLink> links) async {
    for (final link in links) {
      if (link.reminderAt == null || link.reminderScheduled) {
        continue;
      }
      if (link.reminderAt!.isBefore(DateTime.now())) {
        await _repository.markReminderScheduled(link.id);
        continue;
      }
      await _notificationService.scheduleMeetingReminder(
        link.id,
        link.title,
        link.scheduledStart ?? link.reminderAt!,
        role: link.role,
      );
      await _repository.markReminderScheduled(link.id);
    }
  }
}
