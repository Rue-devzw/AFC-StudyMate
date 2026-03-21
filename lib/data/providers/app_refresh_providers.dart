import 'package:hooks_riverpod/hooks_riverpod.dart';

final appDataRefreshTickProvider = StateProvider<int>((ref) => 0);

void triggerAppDataRefresh(WidgetRef ref) {
  final notifier = ref.read(appDataRefreshTickProvider.notifier);
  notifier.state = notifier.state + 1;
}
