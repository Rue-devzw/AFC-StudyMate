import 'package:afc_studymate/data/models/progress.dart';
import 'package:afc_studymate/data/services/progress_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const localUserId = 'local_user';

final progressRefreshTickProvider = StateProvider<int>((ref) => 0);

void triggerProgressRefresh(WidgetRef ref) {
  final notifier = ref.read(progressRefreshTickProvider.notifier);
  notifier.state = notifier.state + 1;
}

final FutureProviderFamily<List<Progress>, String> userProgressProvider = FutureProvider.family<List<Progress>, String>((
  ref,
  userId,
) async {
  ref.watch(progressRefreshTickProvider);
  return ref.read(progressServiceProvider).getUserProgress(userId);
});

final FutureProviderFamily<bool, String> isLessonCompletedProvider = FutureProvider.family<bool, String>((
  ref,
  lessonId,
) async {
  ref.watch(progressRefreshTickProvider);
  return ref
      .read(progressServiceProvider)
      .isLessonCompleted(localUserId, lessonId);
});
