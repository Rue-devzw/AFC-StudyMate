import 'package:afc_studymate/data/drift/app_database.dart';
import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/progress.dart';
import 'package:afc_studymate/data/models/user_profile.dart';
import 'package:afc_studymate/data/providers/progress_providers.dart';
import 'package:afc_studymate/data/services/progress_service.dart';
import 'package:afc_studymate/widgets/design_system_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// ─── Providers ────────────────────────────────────────────────────────────────

const _userId = 'local_user';

final FutureProviderFamily<UserProfile?, String> _userProfileProvider =
    FutureProvider.family<UserProfile?, String>((
      ref,
      userId,
    ) {
      return ref.read(appDatabaseProvider).getProfile(userId);
    });

// ─── ProfileScreen ────────────────────────────────────────────────────────────

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  static const String routeName = 'profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProfile = ref.watch(_userProfileProvider(_userId));
    final asyncProgress = ref.watch(userProgressProvider(_userId));
    final nameController = useTextEditingController();

    return PremiumScaffold(
      backgroundAsset: 'assets/images/bg_journal.png',
      appBar: AppBar(
        title: const Text(
          'Profile & Progress',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth.clamp(0, 860).toDouble();
            return Center(
              child: SizedBox(
                width: width,
                child: asyncProfile.when(
                  data: (profile) {
                    final effectiveProfile =
                        profile ??
                        const UserProfile(
                          userId: _userId,
                          name: 'Learner',
                          role: Role.learner,
                          targetTrack: Track.search,
                          translation: Translation.kjv,
                        );
                    if (nameController.text != effectiveProfile.name) {
                      nameController.text = effectiveProfile.name;
                    }

                    return ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        _ProfileHeader(profile: effectiveProfile),
                        const SizedBox(height: 32),

                        // ── PROGRESS ──────────────────────────────────────────────
                        _sectionLabel(context, 'YOUR PROGRESS'),
                        const SizedBox(height: 16),
                        asyncProgress.when(
                          data: (progress) =>
                              _ProgressSection(progress: progress, ref: ref),
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (e, _) => Text(
                            'Error loading progress: $e',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // ── PREFERENCES ───────────────────────────────────────────
                        _sectionLabel(context, 'PREFERENCES'),
                        const SizedBox(height: 16),
                        PremiumGlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  letterSpacing: 1.2,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: nameController,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Your name',
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        PremiumGlassCard(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: [
                              _ProfileOption(
                                icon: Icons.person_outline_rounded,
                                label: 'Role',
                                value: _formatName(effectiveProfile.role.name),
                                onTap: () => _showRolePicker(
                                  context,
                                  ref,
                                  effectiveProfile,
                                ),
                              ),
                              const Divider(height: 1, color: Colors.white10),
                              _ProfileOption(
                                icon: Icons.class_outlined,
                                label: 'Class/Track',
                                value: effectiveProfile.targetTrack.label,
                                onTap: () => _showTrackPicker(
                                  context,
                                  ref,
                                  effectiveProfile,
                                ),
                              ),
                              const Divider(height: 1, color: Colors.white10),
                              _ProfileOption(
                                icon: Icons.translate_rounded,
                                label: 'Bible Translation',
                                value:
                                    effectiveProfile.translation ==
                                        Translation.kjv
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
                          onPressed: () async {
                            final updated = effectiveProfile.copyWith(
                              name: nameController.text.trim().isEmpty
                                  ? 'Learner'
                                  : nameController.text.trim(),
                            );
                            await ref
                                .read(appDatabaseProvider)
                                .upsertProfile(updated);
                            ref.invalidate(_userProfileProvider(_userId));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profile updated successfully!'),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: standardBottomContentPadding(context)),
                      ],
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (profileError, _) =>
                      Center(child: Text('Error: $profileError')),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Colors.white70,
        letterSpacing: 1.5,
      ),
    );
  }

  String _formatName(String name) {
    if (name.isEmpty) return '';
    return name[0].toUpperCase() + name.substring(1);
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
      labelBuilder: (t) => t.label,
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

// ─── _ProgressSection ─────────────────────────────────────────────────────────

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({required this.progress, required this.ref});
  final List<Progress> progress;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final svc = ref.read(progressServiceProvider);
    final streak = svc.getStreak(progress);
    final bestStreak = svc.getBestStreak(progress);
    final recent = svc.getRecentActivity(progress);

    // Group by lesson type (using track.name)
    final counts = <String, int>{};
    for (final p in progress) {
      final key = _inferLabel(p.lessonId);
      counts[key] = (counts[key] ?? 0) + 1;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Stat row ──────────────────────────────────────────────────────
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.local_fire_department_rounded,
                label: 'Current Streak',
                value: '$streak Days',
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.emoji_events_rounded,
                label: 'Best Streak',
                value: '$bestStreak Days',
                color: const Color(0xFFD4A017),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.check_circle_rounded,
                label: 'Completed',
                value: '${progress.length}',
                color: Colors.greenAccent,
              ),
            ),
          ],
        ),

        // ── Per-track breakdown ───────────────────────────────────────────
        if (counts.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'BY CATEGORY',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white60,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          PremiumGlassCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: counts.entries
                  .map(
                    (e) => _TrackProgressRow(
                      label: e.key,
                      count: e.value,
                      total: progress.length,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],

        // ── Recent activity ───────────────────────────────────────────────
        if (recent.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'RECENT ACTIVITY',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white60,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          PremiumGlassCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: recent.map((p) => _ActivityRow(progress: p)).toList(),
            ),
          ),
        ],

        if (progress.isEmpty) ...[
          const SizedBox(height: 16),
          PremiumGlassCard(
            child: Column(
              children: [
                const Icon(
                  Icons.menu_book_rounded,
                  color: Colors.white38,
                  size: 40,
                ),
                const SizedBox(height: 12),
                Text(
                  'No lessons completed yet.\nStart studying to track your progress!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _inferLabel(String lessonId) {
    if (lessonId.startsWith('search')) return 'Search';
    if (lessonId.startsWith('answer')) return 'The Answer';
    if (lessonId.startsWith('beginners')) return 'Beginners';
    if (lessonId.startsWith('primary')) return 'Primary Pals';
    if (lessonId.startsWith('discovery')) return 'Discovery';
    if (lessonId.startsWith('daybreak')) return 'Daybreak';
    return 'Other';
  }
}

class _TrackProgressRow extends StatelessWidget {
  const _TrackProgressRow({
    required this.label,
    required this.count,
    required this.total,
  });
  final String label;
  final int count;
  final int total;

  @override
  Widget build(BuildContext context) {
    final fraction = total > 0 ? count / total : 0.0;
    final pct = '${(fraction * 100).round()}%';
    final color = _colorForLabel(label);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '$count ($pct)',
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 6,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Color _colorForLabel(String label) {
    switch (label) {
      case 'Daybreak':
        return const Color(0xFFFF6B35);
      case 'Discovery':
        return const Color(0xFF9B5DE5);
      case 'Beginners':
        return const Color(0xFFFF8BA7);
      case 'Primary Pals':
        return const Color(0xFFFFD166);
      case 'The Answer':
        return const Color(0xFF06D6A0);
      case 'Search':
        return const Color(0xFF118AB2);
      default:
        return Colors.blueGrey;
    }
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.progress});
  final Progress progress;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('MMM d, yyyy').format(progress.completedAt);
    return ListTile(
      dense: true,
      leading: const Icon(
        Icons.check_circle_rounded,
        color: Colors.greenAccent,
        size: 20,
      ),
      title: Text(
        progress.lessonId,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        date,
        style: const TextStyle(color: Colors.white38, fontSize: 11),
      ),
    );
  }
}

// ─── Smaller widgets ──────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});
  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white.withValues(alpha: 0.1),
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
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${profile.role.name.toUpperCase()} · ${profile.targetTrack.label}',
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
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white60, fontSize: 10),
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
