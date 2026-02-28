import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/drift/app_database.dart';
import '../../data/models/enums.dart';
import '../../data/models/progress.dart';
import '../../data/models/user_profile.dart';
import '../../data/services/progress_service.dart';
import '../../widgets/design_system_widgets.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  static const String routeName = 'profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const userId = 'local_user';
    final asyncProfile = ref.watch(_userProfileProvider(userId));
    final asyncProgress = ref.watch(_userProgressProvider(userId));

    return PremiumScaffold(
      backgroundAsset: 'assets/images/bg_journal.png',
      appBar: AppBar(
        title: const Text(
          'Profile & Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: asyncProfile.when(
          data: (profile) {
            final effectiveProfile =
                profile ??
                const UserProfile(
                  userId: userId,
                  name: 'Learner',
                  role: Role.learner,
                  targetTrack: Track.search,
                  translation: Translation.kjv,
                );

            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _ProfileHeader(profile: effectiveProfile),
                const SizedBox(height: 32),
                Text(
                  'YOUR PROGRESS',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white70,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                asyncProgress.when(
                  data: (progress) {
                    final progressService = ref.read(progressServiceProvider);
                    final streak = progressService.getStreak(progress);
                    return Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.local_fire_department_rounded,
                            label: 'Streak',
                            value: '$streak Days',
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.check_circle_rounded,
                            label: 'Completed',
                            value: '${progress.length}',
                            color: Colors.greenAccent,
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Error loading progress: $e'),
                ),
                const SizedBox(height: 32),
                Text(
                  'PREFERENCES',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white70,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                PremiumGlassCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _ProfileOption(
                        icon: Icons.person_outline_rounded,
                        label: 'Role',
                        value: _formatName(effectiveProfile.role.name),
                        onTap: () =>
                            _showRolePicker(context, ref, effectiveProfile),
                      ),
                      const Divider(height: 1, color: Colors.white10),
                      _ProfileOption(
                        icon: Icons.class_outlined,
                        label: 'Class/Track',
                        value: _trackLabel(effectiveProfile.targetTrack),
                        onTap: () =>
                            _showTrackPicker(context, ref, effectiveProfile),
                      ),
                      const Divider(height: 1, color: Colors.white10),
                      _ProfileOption(
                        icon: Icons.translate_rounded,
                        label: 'Bible Translation',
                        value: effectiveProfile.translation == Translation.kjv
                            ? 'King James Version'
                            : 'Shona',
                        onTap: () => _showTranslationPicker(
                          context,
                          ref,
                          effectiveProfile,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                AppButton(
                  label: 'Save Changes',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully!'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (profileError, _) =>
              Center(child: Text('Error: $profileError')),
        ),
      ),
    );
  }

  String _formatName(String name) {
    if (name.isEmpty) return '';
    return name[0].toUpperCase() + name.substring(1);
  }

  String _trackLabel(Track track) {
    switch (track) {
      case Track.beginners:
        return 'Beginners';
      case Track.primaryPals:
        return 'Primary Pals';
      case Track.answer:
        return 'Answer';
      case Track.search:
        return 'Search';
      default:
        return _formatName(track.name);
    }
  }

  void _showRolePicker(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
  ) {
    _showPicker<Role>(
      context,
      title: 'Select Role',
      items: Role.values,
      selected: profile.role,
      labelBuilder: (r) => _formatName(r.name),
      onSelected: (role) async {
        final db = ref.read(appDatabaseProvider);
        await db.upsertProfile(profile.copyWith(role: role));
        ref.invalidate(_userProfileProvider(profile.userId));
      },
    );
  }

  void _showTrackPicker(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
  ) {
    _showPicker<Track>(
      context,
      title: 'Select Class',
      items: Track.values
          .where((t) => t != Track.daybreak && t != Track.discovery)
          .toList(),
      selected: profile.targetTrack,
      labelBuilder: _trackLabel,
      onSelected: (track) async {
        final db = ref.read(appDatabaseProvider);
        await db.upsertProfile(profile.copyWith(targetTrack: track));
        ref.invalidate(_userProfileProvider(profile.userId));
      },
    );
  }

  void _showTranslationPicker(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
  ) {
    _showPicker<Translation>(
      context,
      title: 'Select Translation',
      items: Translation.values,
      selected: profile.translation,
      labelBuilder: (t) =>
          t == Translation.kjv ? 'King James Version' : 'Shona',
      onSelected: (t) async {
        final db = ref.read(appDatabaseProvider);
        await db.upsertProfile(profile.copyWith(translation: t));
        ref.invalidate(_userProfileProvider(profile.userId));
      },
    );
  }

  void _showPicker<T>(
    BuildContext context, {
    required String title,
    required List<T> items,
    required T selected,
    required String Function(T) labelBuilder,
    required ValueChanged<T> onSelected,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: 1, color: Colors.white10),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = item == selected;
                  return ListTile(
                    title: Text(
                      labelBuilder(item),
                      style: TextStyle(
                        color: isSelected ? Colors.blue : Colors.white,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Colors.blue)
                        : null,
                    onTap: () {
                      onSelected(item);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});
  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white.withOpacity(0.1),
          child: const Icon(
            Icons.person_rounded,
            size: 60,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          profile.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            profile.role.name.toUpperCase(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return PremiumGlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(color: Colors.white38, fontSize: 14),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded, color: Colors.white24),
        ],
      ),
    );
  }
}

final _userProfileProvider = FutureProvider.family<UserProfile?, String>((
  ref,
  userId,
) {
  return ref.read(appDatabaseProvider).getProfile(userId);
});

final _userProgressProvider = FutureProvider.family<List<Progress>, String>((
  ref,
  userId,
) {
  return ref.read(progressServiceProvider).getUserProgress(userId);
});
