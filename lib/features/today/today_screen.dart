import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/drift/app_database.dart';
import '../../data/models/enums.dart';
import '../../data/models/lesson.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/lesson_repository.dart';
import '../../widgets/design_system_widgets.dart';

class DashboardData {
  const DashboardData({
    this.daybreak,
    this.sundaySchool,
    this.discovery,
    required this.profile,
  });
  final Lesson? daybreak;
  final Lesson? sundaySchool;
  final Lesson? discovery;
  final UserProfile profile;
}

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
    final theme = Theme.of(context);
    final now = DateTime.now();
    final greeting = _getGreeting(now.hour);
    final dateString = DateFormat('EEEE, MMM d').format(now);

    return PremiumScaffold(
      backgroundAsset: 'assets/images/bg_dashboard.png',
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  greeting,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                Text(
                  dateString,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            stretch: true,
            surfaceTintColor: Colors.transparent,
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            sliver: asyncData.when(
              data: (data) => SliverList(
                delegate: SliverChildListDelegate([
                  if (data.daybreak != null) _VotdCard(lesson: data.daybreak!),
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
                    subtitle: data.daybreak?.title ?? 'Today\'s Devotion',
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
                        ? '${_trackLabel(data.profile.targetTrack)}: ${data.sundaySchool!.title}'
                        : 'This week\'s lesson',
                    icon: Icons.school_rounded,
                    color: Colors.blueAccent.shade200,
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
                  const SizedBox(height: 60),
                ]),
              ),
              loading: () => const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
              error: (e, st) => SliverFillRemaining(
                child: Center(
                  child: Text(
                    'Error: $e',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting(int hour) {
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _trackLabel(Track track) {
    switch (track) {
      case Track.beginners:
        return 'Beginners';
      case Track.primaryPals:
        return 'Primary Pals';
      case Track.search:
        return 'Search';
      default:
        return track.name[0].toUpperCase() + track.name.substring(1);
    }
  }
}

class _VotdCard extends StatelessWidget {
  const _VotdCard({required this.lesson});
  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Find a verse snippet or use title
    String verseText = 'Spend time in prayer and reflection today.';
    String reference = 'Verse of the Day';

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
            verseText = '\${verseText.substring(0, 147)}...';
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
              letterSpacing: 2.0,
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
