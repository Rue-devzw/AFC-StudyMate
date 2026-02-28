import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/drift/app_database.dart';
import '../../data/models/enums.dart';
import '../../data/models/journal_entry.dart';
import '../../data/repositories/lesson_repository.dart';
import '../../widgets/design_system_widgets.dart';

final _journalEntriesProvider =
    FutureProvider.family<List<JournalEntry>, Track>((ref, track) {
      return ref
          .read(appDatabaseProvider)
          .getJournalEntries('local_user', track: track);
    });

class JournalScreen extends StatefulHookConsumerWidget {
  const JournalScreen({super.key});

  static const String routeName = 'journal';

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      backgroundAsset: 'assets/images/bg_journal.png',
      appBar: AppBar(
        title: const Text(
          'My Journal',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.white.withOpacity(0.6),
          ),
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Daybreak'),
            Tab(text: 'Search'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _JournalList(track: Track.daybreak),
          _JournalList(track: Track.search),
        ],
      ),
    );
  }
}

class _JournalList extends ConsumerWidget {
  const _JournalList({required this.track});

  final Track track;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(_journalEntriesProvider(track));

    return entriesAsync.when(
      data: (entries) {
        if (entries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  track == Track.daybreak
                      ? Icons.wb_sunny_outlined
                      : Icons.menu_book_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Icon(
                  track == Track.daybreak
                      ? Icons.wb_sunny_outlined
                      : Icons.menu_book_outlined,
                  size: 64,
                  color: Colors.white.withOpacity(0.4),
                ),
                const SizedBox(height: 16),
                Text(
                  'No reflections yet.',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your saved thoughts will appear here.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: entries.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final entry = entries[index];
            return _JournalEntryCard(entry: entry);
          },
        );
      },
      loading: () =>
          const Center(child: CircularProgressIndicator(color: Colors.white)),
      error: (e, st) => Center(
        child: Text(
          'Error loading journal: $e',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class _JournalEntryCard extends ConsumerWidget {
  const _JournalEntryCard({required this.entry});

  final JournalEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // We can fetch lesson title to display as header
    final lessonAsync = _fetchLessonInfo(
      ref,
      entry.relatedLessonId,
      entry.sourceTrack,
    );

    return PremiumGlassCard(
      borderRadius: BorderRadius.circular(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: lessonAsync.when(
                  data: (title) => Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  loading: () => const SizedBox(
                    height: 20,
                    width: 100,
                    child: LinearProgressIndicator(
                      color: Colors.white,
                      backgroundColor: Colors.white24,
                    ),
                  ),
                  error: (_, __) => Text(
                    'Lesson ${entry.relatedLessonId}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Text(
                DateFormat.yMMMd().format(entry.createdAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _cleanPrompt(entry.prompt),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 12),
          Divider(
            color: Colors.white.withOpacity(0.1),
          ),
          const SizedBox(height: 12),
          Text(
            entry.response,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  AsyncValue<String> _fetchLessonInfo(
    WidgetRef ref,
    String lessonId,
    Track track,
  ) {
    // Basic implementation trying to fetch from repository cache
    try {
      if (track == Track.search) {
        final futureProvider = FutureProvider<String>((ref) async {
          final repo = ref.read(lessonRepositoryProvider);
          final lessons = await repo.getLessonsForTrack(Track.search);
          final lesson = lessons.firstWhere((l) => l.id == lessonId);
          return lesson.title;
        });
        return ref.watch(futureProvider);
      } else if (track == Track.daybreak) {
        final futureProvider = FutureProvider<String>((ref) async {
          final repo = ref.read(lessonRepositoryProvider);
          final lesson = await repo.getDaybreakLesson();
          // Better to fetch by ID, assuming repo has method.
          if (lesson != null && lesson.id == lessonId) {
            return lesson.title;
          }
          return 'Daybreak Devotion';
        });
        return ref.watch(futureProvider);
      }
    } catch (_) {}
    return AsyncValue.data(lessonId);
  }

  String _cleanPrompt(String prompt) {
    if (prompt.startsWith('a_closer_look_')) {
      return "A Closer Look Reflection";
    }
    if (prompt == 'personal_reflection') {
      return "Personal Reflection";
    }
    return prompt;
  }
}
