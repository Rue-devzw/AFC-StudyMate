import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/memory_verse.dart';
import 'package:afc_studymate/data/models/verse.dart';
import 'package:afc_studymate/data/services/bible_service.dart';
import 'package:afc_studymate/data/services/memory_verse_service.dart';
import 'package:afc_studymate/utils/scripture_reference_parser.dart';
import 'package:afc_studymate/widgets/design_system_widgets.dart';
import 'package:afc_studymate/widgets/retry_error_card.dart';
import 'package:afc_studymate/widgets/skeleton_widgets.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

final _memoryQueueProvider = FutureProvider<List<MemoryVerse>>((ref) {
  return ref.read(memoryVerseServiceProvider).getDueQueue();
});

class MemoryVerseScreen extends ConsumerStatefulWidget {
  const MemoryVerseScreen({super.key});

  static const routeName = 'memoryVerses';

  @override
  ConsumerState<MemoryVerseScreen> createState() => _MemoryVerseScreenState();
}

class _MemoryVerseScreenState extends ConsumerState<MemoryVerseScreen> {
  var _index = 0;
  var _showAnswer = false;

  @override
  Widget build(BuildContext context) {
    final queueAsync = ref.watch(_memoryQueueProvider);

    return PremiumScaffold(
      backgroundAsset: 'assets/images/bg_dashboard.png',
      appBar: AppBar(
        title: const Text(
          'Memory Verse Review',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            tooltip: 'Share memory verse',
            onPressed: () {
              final queue = queueAsync.valueOrNull;
              if (queue == null || queue.isEmpty) {
                Share.share('Memory verse review in StudyMate');
                return;
              }
              final verse = queue[_index.clamp(0, queue.length - 1)];
              Share.share(
                'Memory Verse: ${verse.ref.displayText}\n'
                'Translation: ${verse.translation.name.toUpperCase()}',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            tooltip: 'Add verse',
            onPressed: () => _openAddVerseSheet(context),
          ),
        ],
      ),
      body: queueAsync.when(
        data: (queue) {
          if (queue.isEmpty) {
            return Center(
              child: PremiumGlassCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'No verses due right now.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Add a verse to begin your review queue.',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => _openAddVerseSheet(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Verse'),
                    ),
                  ],
                ),
              ),
            );
          }

          final verse = queue[_index.clamp(0, queue.length - 1)];

          return Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              standardBottomContentPadding(context),
            ),
            child: Column(
              children: [
                Text(
                  'Due: ${queue.length} • Card ${_index + 1} of ${queue.length}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _showAnswer = !_showAnswer;
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: PremiumGlassCard(
                      child: _MemoryCard(
                        verse: verse,
                        showAnswer: _showAnswer,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _showAnswer
                      ? 'Rate your recall'
                      : 'Tap card to reveal verse text',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _ReviewButton(
                      label: 'Again',
                      onPressed: () => _review(
                        verse,
                        MemoryVerseReviewAction.again,
                        queue.length,
                      ),
                    ),
                    _ReviewButton(
                      label: 'Hard',
                      onPressed: () => _review(
                        verse,
                        MemoryVerseReviewAction.hard,
                        queue.length,
                      ),
                    ),
                    _ReviewButton(
                      label: 'Good',
                      onPressed: () => _review(
                        verse,
                        MemoryVerseReviewAction.good,
                        queue.length,
                      ),
                    ),
                    _ReviewButton(
                      label: 'Easy',
                      onPressed: () => _review(
                        verse,
                        MemoryVerseReviewAction.easy,
                        queue.length,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            standardBottomContentPadding(context),
          ),
          children: const [
            SkeletonCard(),
            SizedBox(height: 12),
            SkeletonCard(),
          ],
        ),
        error: (error, stackTrace) => RetryErrorCard(
          message: '$error',
          onRetry: () => ref.invalidate(_memoryQueueProvider),
        ),
      ),
    );
  }

  Future<void> _review(
    MemoryVerse verse,
    MemoryVerseReviewAction action,
    int queueLength,
  ) async {
    await ref.read(memoryVerseServiceProvider).reviewVerse(verse, action);
    setState(() {
      _showAnswer = false;
      if (_index >= queueLength - 1) {
        _index = 0;
      } else {
        _index++;
      }
    });
    ref.invalidate(_memoryQueueProvider);
  }

  Future<void> _openAddVerseSheet(BuildContext context) async {
    final controller = TextEditingController();
    var translation = Translation.kjv;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
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
                const Text(
                  'Add Memory Verse',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'e.g. John 3:16',
                    hintStyle: TextStyle(color: Colors.white54),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButton<Translation>(
                  value: translation,
                  dropdownColor: const Color(0xFF1C1C1E),
                  style: const TextStyle(color: Colors.white),
                  items: const [
                    DropdownMenuItem(
                      value: Translation.kjv,
                      child: Text('KJV'),
                    ),
                    DropdownMenuItem(
                      value: Translation.shona,
                      child: Text('Shona'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    setSheetState(() {
                      translation = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      final parsed =
                          ScriptureReferenceParser.parseReferenceList(
                            controller.text.trim(),
                          );
                      if (parsed.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Enter a valid reference.'),
                          ),
                        );
                        return;
                      }
                      final verse = MemoryVerse(
                        id: const Uuid().v4(),
                        ref: parsed.first,
                        translation: translation,
                        dueDate: DateTime.now(),
                      );
                      await ref
                          .read(memoryVerseServiceProvider)
                          .addVerse(verse);
                      if (!mounted) return;
                      Navigator.pop(context);
                      ref.invalidate(_memoryQueueProvider);
                    },
                    child: const Text('Add to Queue'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MemoryCard extends ConsumerWidget {
  const _MemoryCard({
    required this.verse,
    required this.showAnswer,
  });

  final MemoryVerse verse;
  final bool showAnswer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final label = verse.ref.displayText;

    if (!showAnswer) {
      return Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return FutureBuilder<List<Verse>>(
      future: ref
          .read(bibleServiceProvider)
          .getPassage(
            verse.ref,
            verse.translation,
          ),
      builder: (context, snapshot) {
        final text =
            snapshot.data?.map((v) => v.text).join(' ') ??
            'Could not load verse text.';
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Next due: ${_nextDueLabel(verse)}',
                style: const TextStyle(color: Colors.white60),
              ),
            ],
          ),
        );
      },
    );
  }

  String _nextDueLabel(MemoryVerse verse) {
    final due = verse.dueDate;
    if (due == null) return 'Now';
    final diff = due.difference(DateTime.now()).inDays;
    if (diff <= 0) return 'Now';
    return 'in $diff day${diff == 1 ? '' : 's'}';
  }
}

class _ReviewButton extends StatelessWidget {
  const _ReviewButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: Text(label),
    );
  }
}
