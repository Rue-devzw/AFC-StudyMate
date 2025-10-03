import 'entities.dart';

abstract class MeetingRepository {
  Stream<List<MeetingLink>> watchLinks(
    MeetingContextType contextType,
    String contextId, {
    MeetingRole? role,
  });

  Stream<List<MeetingLink>> watchPendingReminders();

  Future<List<MeetingLink>> fetchLinks(
    MeetingContextType contextType,
    String contextId, {
    MeetingRole? role,
  });

  Future<void> saveLink(MeetingLink link);

  Future<void> markReminderScheduled(String id);

  Future<void> saveRecording(
    MeetingContextType contextType,
    String contextId, {
    required Uri recordingUrl,
    required String storagePath,
    DateTime? indexedAt,
  });
}
