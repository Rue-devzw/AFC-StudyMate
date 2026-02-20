import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/drift/app_database.dart';
import '../../data/models/progress.dart';
import '../../data/services/progress_service.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  static const String routeName = 'profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In a real app, this would be the logged in user's ID
    const userId = 'local_user';
    final asyncProgress = ref.watch(_userProgressProvider(userId));
    final asyncRole = ref.watch(_userRoleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Progress')),
      body: asyncProgress.when(
        data: (progress) {
          final progressService = ref.read(progressServiceProvider);
          final streak = progressService.getStreak(progress);
          final completionCount = progress.length;

          return ListView(
            padding: const EdgeInsets.all(24),
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Role'),
                subtitle: Text(asyncRole.value ?? 'Learner'),
              ),
              ListTile(
                leading: const Icon(Icons.local_fire_department_outlined),
                title: const Text('Current streak'),
                subtitle: Text(
                  '$streak days – ${streak > 0 ? 'keep going!' : 'start today!'}',
                ),
              ),
              ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: const Text('Lessons Completed'),
                subtitle: Text('$completionCount lessons finished'),
              ),
              const ListTile(
                leading: Icon(Icons.badge_outlined),
                title: Text('Badges'),
                subtitle: Text('Starter Star, Faithful Reader'),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

final _userProgressProvider = FutureProvider.family<List<Progress>, String>((
  ref,
  userId,
) {
  return ref.read(progressServiceProvider).getUserProgress(userId);
});

final _userRoleProvider = FutureProvider<String>((ref) async {
  final db = ref.read(appDatabaseProvider);
  final role = await db.getSetting('role');
  return role ?? 'Learner';
});
