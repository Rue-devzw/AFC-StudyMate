import 'package:afc_studymate/data/drift/app_database.dart';
import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/lesson.dart';
import 'package:afc_studymate/data/models/user_profile.dart';
import 'package:afc_studymate/data/repositories/lesson_repository.dart';
import 'package:afc_studymate/data/services/progress_service.dart';
import 'package:afc_studymate/data/services/sync_service.dart';
import 'package:afc_studymate/widgets/design_system_widgets.dart';
import 'package:afc_studymate/widgets/retry_error_card.dart';
import 'package:afc_studymate/widgets/skeleton_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardData {
  const DashboardData({
    required this.profile,
    this.daybreak,
    this.sundaySchool,
    this.discovery,
  });
  final Lesson? daybreak;
  final Lesson? sundaySchool;
  final Lesson? discovery;
  final UserProfile profile;
}

class SyncStatus {
  const SyncStatus({
    required this.lastSyncedAt,
    required this.lastAttemptSucceeded,
  });

  final DateTime? lastSyncedAt;
  final bool lastAttemptSucceeded;
}

const _syncMetaKey = 'last_sync_at';
const _syncSuccessKey = 'last_sync_success';

final _syncRefreshTickProvider = StateProvider<int>((ref) => 0);

final _syncStatusProvider = FutureProvider<SyncStatus>((ref) async {
  ref.watch(_syncRefreshTickProvider);
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(_syncMetaKey);
  final parsed = raw == null ? null : DateTime.tryParse(raw);
  final success = prefs.getBool(_syncSuccessKey) ?? false;
  return SyncStatus(lastSyncedAt: parsed, lastAttemptSucceeded: success);
});

final _dashboardDataProvider = FutureProvider<DashboardData>((ref) async {
  const userId = 'local_user';
  final db = ref.read(appDatabaseProvider);
  final repo = ref.read(lessonRepositoryProvider);

  final daybreak = await repo.getDaybreakLesson();

  final profile =
      await db.getProfile(userId) ??
      const UserProfile(
        userId: userId,
        name: 'Learner',
        role: Role.learner,
        targetTrack: Track.search,
        translation: Translation.kjv,
      );

  final sundaySchool = await repo.getCurrentSundayLesson(profile.targetTrack);
  final discovery = await repo.getDiscoveryLesson();

  return DashboardData(
    daybreak: daybreak,
    sundaySchool: sundaySchool,
    discovery: discovery,
    profile: profile,
  );
});

class TodayScreen extends HookConsumerWidget {
  const TodayScreen({super.key});

  static const String routeName = 'today';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(_dashboardDataProvider);
    final asyncSyncStatus = ref.watch(_syncStatusProvider);
    final theme = Theme.of(context);
    final horizontalPadding = responsiveHorizontalPadding(
      context,
      minPadding: 20,
    );
    final now = DateTime.now();
    final dateString = DateFormat('EEEE, MMM d').format(now);

    return PremiumScaffold(
      backgroundAsset: 'assets/images/bg_dashboard.png',
      body: RefreshIndicator(
        onRefresh: () => _syncNow(context, ref),
        child: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: asyncData.when(
                data: (data) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getGreeting(now.hour, data.profile.name),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      dateString,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                loading: () => Text(
                  _getGreeting(now.hour, ''),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                error: (_, __) => Text(
                  _getGreeting(now.hour, ''),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              stretch: true,
              surfaceTintColor: Colors.transparent,
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 12,
              ),
              sliver: asyncData.when(
                data: (data) => SliverList(
                  delegate: SliverChildListDelegate([
                    _SyncStatusBadge(
                      status: asyncSyncStatus.valueOrNull,
                      onSyncNow: () => _syncNow(context, ref),
                    ),
                    const SizedBox(height: 16),
                    if (data.daybreak != null)
                      _VotdCard(lesson: data.daybreak!),
                    const SizedBox(height: 32),
                    Text(
                      'Daily Reading',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ActionCard(
                      title: 'Daybreak',
                      subtitle: data.daybreak?.title ?? "Today's Devotion",
                      icon: Icons.wb_sunny_rounded,
                      color: Colors.orangeAccent.shade400,
                      onTap: () {
                        context.pushNamed(
                          'daybreak',
                          pathParameters: {
                            'date': DateTime.now().toIso8601String(),
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Study',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ActionCard(
                      title: 'Sunday School',
                      subtitle: data.sundaySchool != null
                          ? '${data.profile.targetTrack.label}: ${data.sundaySchool!.title}'
                          : "This week's lesson",
                      icon: Icons.school_rounded,
                      color: data.profile.targetTrack.color,
                      onTap: () {
                        context.go('/home/sunday-school');
                      },
                    ),
                    const SizedBox(height: 16),
                    _ActionCard(
                      title: 'Discovery',
                      subtitle: data.discovery != null
                          ? 'Lesson ${data.discovery!.weekIndex ?? 0}: ${data.discovery!.title}'
                          : 'Dive deeper mid-week',
                      icon: Icons.explore_rounded,
                      color: Colors.teal.shade300,
                      onTap: () {
                        context.pushNamed('discovery');
                      },
                    ),
                    const SizedBox(height: 16),
                    _ActionCard(
                      title: 'Memory Verse',
                      subtitle: 'Review your verse queue',
                      icon: Icons.style_outlined,
                      color: Colors.pinkAccent.shade200,
                      onTap: () {
                        context.pushNamed('memoryVerses');
                      },
                    ),
                    SizedBox(
                      height: standardBottomContentPadding(context),
                    ), // Clear the floating glass bottom bar
                  ]),
                ),
                loading: () => SliverList(
                  delegate: SliverChildListDelegate(
                    const [
                      SkeletonCard(),
                      SizedBox(height: 12),
                      SkeletonCard(),
                      SizedBox(height: 12),
                      SkeletonCard(),
                    ],
                  ),
                ),
                error: (e, st) => SliverFillRemaining(
                  child: RetryErrorCard(
                    message: '$e',
                    onRetry: () => ref.invalidate(_dashboardDataProvider),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting(int hour, String name) {
    final firstName = name.split(' ').first;
    final suffix = firstName.isNotEmpty && firstName != 'Learner'
        ? ', $firstName!'
        : '!';
    if (hour < 12) return 'Good morning$suffix';
    if (hour < 17) return 'Good afternoon$suffix';
    return 'Good evening$suffix';
  }

  Future<void> _syncNow(BuildContext context, WidgetRef ref) async {
    const userId = 'local_user';
    var success = false;
    try {
      final db = ref.read(appDatabaseProvider);
      final progress = await ref
          .read(progressServiceProvider)
          .getUserProgress(
            userId,
          );
      final notes = await db.getAllNotes(userId);
      await ref.read(syncServiceProvider).syncProgress(userId, progress);
      await ref.read(syncServiceProvider).syncNotes(userId, notes);
      success = true;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sync complete.')),
        );
      }
    } catch (_) {
      success = false;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sync unavailable. Using offline data.'),
          ),
        );
      }
    } finally {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_syncMetaKey, DateTime.now().toIso8601String());
      await prefs.setBool(_syncSuccessKey, success);
      ref.read(_syncRefreshTickProvider.notifier).state++;
    }
  }
}

class _SyncStatusBadge extends StatelessWidget {
  const _SyncStatusBadge({
    required this.status,
    required this.onSyncNow,
  });

  final SyncStatus? status;
  final Future<void> Function() onSyncNow;

  @override
  Widget build(BuildContext context) {
    final last = status?.lastSyncedAt;
    final label = last == null
        ? 'Never synced'
        : 'Last synced ${DateFormat.MMMd().add_jm().format(last)}';
    final ok = status?.lastAttemptSucceeded ?? false;
    return PremiumGlassCard(
      borderRadius: BorderRadius.circular(14),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Icon(
            ok ? Icons.cloud_done : Icons.cloud_off,
            color: ok ? Colors.greenAccent : Colors.orangeAccent,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: onSyncNow,
            child: const Text('Sync now'),
          ),
        ],
      ),
    );
  }
}

class _VotdCard extends StatelessWidget {
  const _VotdCard({required this.lesson});
  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Find a verse snippet or use title
    var verseText = 'Spend time in prayer and reflection today.';
    var reference = 'Verse of the Day';

    if (lesson.bibleReferences.isNotEmpty) {
      final ref = lesson.bibleReferences.first;
      reference = ref.toString();
    }

    final payload = lesson.payload;
    if (payload.containsKey('devotion')) {
      final text = payload['devotion'] as String;

      // Attempt to extract the focus verse which is typically at the start
      // of the devotion text, enclosed in “ ” or " " and followed by a reference in ( ).
      // Example: "“And it came to pass...” (2 Kings 8:5) God is always..."
      final focusVerseMatch = RegExp(
        r'^[\"“](.*?)[\"”]\s*(?:\((.*?)\))?',
      ).firstMatch(text.trim());

      if (focusVerseMatch != null && focusVerseMatch.group(1)!.isNotEmpty) {
        verseText = focusVerseMatch.group(1)!;
        if (focusVerseMatch.group(2) != null) {
          reference = focusVerseMatch.group(2)!;
        }
      } else {
        // Fallback to previous logic if no focus verse pattern is matched
        final paragraphs = text
            .split('\n\n')
            .where((p) => p.trim().isNotEmpty)
            .toList();
        if (paragraphs.isNotEmpty) {
          verseText = paragraphs.first;
          // Strip any trailing references for the fallback
          verseText = verseText.replaceAll(RegExp(r'\s*\([^)]+\)\s*$'), '');
          if (verseText.length > 150) {
            verseText = r'${verseText.substring(0, 147)}...';
          }
        }
      }
    }

    return PremiumGlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VERSE OF THE DAY',
            style: theme.textTheme.labelMedium?.copyWith(
              color: Colors.white.withOpacity(0.8),
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '"$verseText"',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            reference,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PremiumGlassCard(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
