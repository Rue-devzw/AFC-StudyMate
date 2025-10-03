import 'entities.dart';

abstract class MeetingLauncher {
  Future<MeetingLaunchResult> launch(MeetingLaunchRequest request);
}
