import 'package:afc_studymate/data/drift/app_database.dart';
import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/journal_entry.dart';
import 'package:afc_studymate/data/models/note.dart';
import 'package:afc_studymate/data/providers/user_providers.dart';
import 'package:afc_studymate/data/repositories/lesson_repository.dart';
import 'package:afc_studymate/data/services/analytics_service.dart';
import 'package:afc_studymate/features/bible/bible_screen.dart';
import 'package:afc_studymate/widgets/design_system_widgets.dart';
import 'package:afc_studymate/widgets/retry_error_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final _journalRefreshProvider = StateProvider<int>((ref) => 0);

final FutureProviderFamily<List<JournalEntry>, Track> _journalEntriesProvider =
    FutureProvider.family<List<JournalEntry>, Track>((ref, track) {
      ref.watch(_journalRefreshProvider);
      return ref
          .read(appDatabaseProvider)
          .getJournalEntries('local_user', track: track);
    });

final _bookmarksProvider = FutureProvider<List<Note>>((ref) async {
  ref.watch(_journalRefreshProvider);
  return ref.read(appDatabaseProvider).getAllNotes('local_user');
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
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedTrack = _tabController.index == 0
        ? Track.daybreak
        : (ref.watch(userProfileProvider).value?.targetTrack ?? Track.search);
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
          tabs: [
            const Tab(text: 'Daybreak'),
            Tab(
              text:
                  ref.watch(userProfileProvider).value?.targetTrack.label ??
                  'Class',
            ),
            const Tab(text: 'My Bookmarks'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const _JournalList(track: Track.daybreak),
          _JournalList(
            track:
                ref.watch(userProfileProvider).value?.targetTrack ??
                Track.search,
          ),
          const _BookmarksList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await _openJournalEditor(
            context,
            ref,
            track: selectedTrack,
          );
          ref.read(_journalRefreshProvider.notifier).state++;
        },
        label: const Text('New Entry'),
        icon: const Icon(Icons.edit_note),
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
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            standardBottomContentPadding(context),
          ), // Clear floating bottom bar
          itemCount: entries.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final entry = entries[index];
            return Dismissible(
              key: ValueKey(entry.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 24),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) async {
                await ref
                    .read(appDatabaseProvider)
                    .deleteJournalEntry(entry.id);
                ref.read(_journalRefreshProvider.notifier).state++;
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Journal entry deleted'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () async {
                          await ref
                              .read(appDatabaseProvider)
                              .upsertJournalEntry(
                                entry,
                              );
                          ref.read(_journalRefreshProvider.notifier).state++;
                        },
                      ),
                    ),
                  );
                }
              },
              child: _JournalEntryCard(
                entry: entry,
                onTap: () async {
                  await _openJournalEditor(
                    context,
                    ref,
                    track: track,
                    existing: entry,
                  );
                  ref.read(_journalRefreshProvider.notifier).state++;
                },
              ),
            );
          },
        );
      },
      loading: () =>
          const Center(child: CircularProgressIndicator(color: Colors.white)),
      error: (e, st) => Center(
        child: RetryErrorCard(
          message: '$e',
          onRetry: () => ref.read(_journalRefreshProvider.notifier).state++,
        ),
      ),
    );
  }
}

class _JournalEntryCard extends ConsumerWidget {
  const _JournalEntryCard({required this.entry, required this.onTap});

  final JournalEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final timestampFormat = DateFormat('EEE, MMM d • h:mm a');
    final isFreeForm =
        entry.prompt == 'personal_reflection' ||
        entry.relatedLessonId.startsWith('freeform_');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: PremiumGlassCard(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<String>(
              future: _resolveLessonTitle(ref),
              builder: (context, snapshot) {
                final title =
                    snapshot.data ??
                    (isFreeForm
                        ? 'Free-form Reflection'
                        : 'Lesson ${entry.relatedLessonId}');
                return Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _MetaChip(text: entry.sourceTrack.label),
                _MetaChip(text: isFreeForm ? 'Free-form' : 'Guided Reflection'),
                if (!isFreeForm) _MetaChip(text: _promptType(entry.prompt)),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Question / Prompt',
              style: theme.textTheme.labelMedium?.copyWith(
                color: Colors.white70,
                letterSpacing: 0.6,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            FutureBuilder<String>(
              future: _resolvePromptText(ref),
              builder: (context, snapshot) {
                final promptText = snapshot.data ?? _cleanPrompt(entry.prompt);
                return Text(
                  promptText,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Colors.white.withOpacity(0.7),
                  ),
                );
              },
            ),
            if (!isFreeForm && _cleanPrompt(entry.prompt) != entry.prompt) ...[
              const SizedBox(height: 6),
              Text(
                'Prompt key: ${entry.prompt}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white54,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Divider(
              color: Colors.white.withOpacity(0.1),
            ),
            const SizedBox(height: 12),
            Text(
              'Response',
              style: theme.textTheme.labelMedium?.copyWith(
                color: Colors.white70,
                letterSpacing: 0.6,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              entry.response,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Created: ${timestampFormat.format(entry.createdAt)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white60,
              ),
            ),
            Text(
              'Updated: ${timestampFormat.format(entry.updatedAt)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _resolveLessonTitle(WidgetRef ref) async {
    if (entry.relatedLessonId.startsWith('freeform_')) {
      return 'Free-form Reflection';
    }
    final lesson = await ref
        .read(lessonRepositoryProvider)
        .getLessonById(entry.relatedLessonId);
    return lesson?.title ?? 'Lesson ${entry.relatedLessonId}';
  }

  Future<String> _resolvePromptText(WidgetRef ref) async {
    if (entry.prompt == 'personal_reflection') {
      return 'Personal Reflection';
    }

    final rawPrompt = entry.prompt.trim();
    if (rawPrompt.isEmpty) {
      return 'No prompt captured';
    }

    // Already a full prompt sentence/value.
    if (rawPrompt.contains(' ') || rawPrompt.length > 36) {
      return _cleanPrompt(rawPrompt);
    }

    final lesson = await ref
        .read(lessonRepositoryProvider)
        .getLessonById(entry.relatedLessonId);
    if (lesson == null) {
      return _cleanPrompt(rawPrompt);
    }

    final questions = lesson.payload['questions'];
    if (questions is List) {
      for (final item in questions) {
        if (item is Map<String, dynamic>) {
          final id = item['id']?.toString();
          final promptText =
              item['prompt']?.toString() ?? item['question']?.toString();
          if (id == rawPrompt && promptText != null && promptText.isNotEmpty) {
            return promptText;
          }
        }
      }

      final idx = _indexFromPromptKey(rawPrompt);
      if (idx != null && idx >= 0 && idx < questions.length) {
        final item = questions[idx];
        if (item is String && item.trim().isNotEmpty) {
          return item.trim();
        }
        if (item is Map<String, dynamic>) {
          final promptText =
              item['prompt']?.toString() ?? item['question']?.toString();
          if (promptText != null && promptText.isNotEmpty) {
            return promptText;
          }
        }
      }
    }

    return _cleanPrompt(rawPrompt);
  }

  int? _indexFromPromptKey(String key) {
    if (key.startsWith('question_')) {
      return int.tryParse(key.replaceFirst('question_', ''));
    }
    if (key.startsWith('q')) {
      return int.tryParse(key.replaceFirst('q', ''));
    }
    return null;
  }

  String _cleanPrompt(String prompt) {
    if (prompt.startsWith('a_closer_look_')) {
      final index = int.tryParse(prompt.replaceFirst('a_closer_look_', ''));
      if (index != null) {
        return 'A Closer Look Reflection #${index + 1}';
      }
      return 'A Closer Look Reflection';
    }
    if (prompt.startsWith('question_')) {
      final index = int.tryParse(prompt.replaceFirst('question_', ''));
      if (index != null) {
        return 'Guided Question #${index + 1}';
      }
      return 'Guided Question';
    }
    if (prompt == 'personal_reflection') {
      return 'Personal Reflection';
    }
    return prompt;
  }

  String _promptType(String prompt) {
    if (prompt.startsWith('a_closer_look_')) return 'A Closer Look';
    if (prompt.startsWith('question_')) return 'Question';
    if (prompt == 'personal_reflection') return 'Personal';
    return 'Prompt';
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.white70,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

Future<void> _openJournalEditor(
  BuildContext context,
  WidgetRef ref, {
  required Track track,
  JournalEntry? existing,
}) async {
  final controller = TextEditingController(text: existing?.response ?? '');
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF1C1C1E),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            existing == null ? 'New Journal Entry' : 'Edit Journal Entry',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            minLines: 6,
            maxLines: 10,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Write your reflection...',
              hintStyle: TextStyle(color: Colors.white54),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () async {
                final text = controller.text.trim();
                if (text.isEmpty) {
                  return;
                }
                final now = DateTime.now();
                final entry =
                    existing ??
                    JournalEntry(
                      id: const Uuid().v4(),
                      userId: 'local_user',
                      relatedLessonId: 'freeform_${now.millisecondsSinceEpoch}',
                      sourceTrack: track,
                      prompt: 'personal_reflection',
                      response: text,
                      createdAt: now,
                      updatedAt: now,
                    );
                await ref
                    .read(appDatabaseProvider)
                    .upsertJournalEntry(
                      entry.copyWith(
                        response: text,
                        updatedAt: now,
                      ),
                    );
                await ref
                    .read(analyticsServiceProvider)
                    .logJournalSaved(
                      source: 'journal_editor',
                      track: track,
                      lessonId: existing?.relatedLessonId,
                    );
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: Text(existing == null ? 'Save Entry' : 'Update Entry'),
            ),
          ),
        ],
      ),
    ),
  );
}

class _BookmarksList extends ConsumerWidget {
  const _BookmarksList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(_bookmarksProvider);
    return bookmarksAsync.when(
      data: (notes) {
        if (notes.isEmpty) {
          return const Center(
            child: Text(
              'No bookmarks yet. Long-press a verse in Bible to add one.',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          );
        }
        return ListView.separated(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            standardBottomContentPadding(context),
          ),
          itemCount: notes.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final note = notes[index];
            final isHighlight = note.text.startsWith('[highlight]');
            final content = note.text
                .replaceFirst('[highlight]', '')
                .replaceFirst('[bookmark]', '')
                .trim();
            return Dismissible(
              key: ValueKey(note.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 24),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) async {
                await ref.read(appDatabaseProvider).deleteNote(note.id);
                ref.read(_journalRefreshProvider.notifier).state++;
              },
              child: PremiumGlassCard(
                borderRadius: BorderRadius.circular(16),
                child: ListTile(
                  leading: Icon(
                    isHighlight ? Icons.highlight_alt : Icons.bookmark,
                    color: isHighlight ? Colors.amberAccent : Colors.lightBlue,
                  ),
                  title: Text(
                    note.ref.displayText,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  onTap: () {
                    context.goNamed(
                      BibleScreen.routeName,
                      queryParameters: {
                        'book': note.ref.book,
                        'chapter': note.ref.chapter.toString(),
                        if (note.ref.verseStart != null)
                          'verse': note.ref.verseStart.toString(),
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
      error: (error, stackTrace) => Center(
        child: RetryErrorCard(
          message: '$error',
          onRetry: () => ref.read(_journalRefreshProvider.notifier).state++,
        ),
      ),
    );
  }
}
