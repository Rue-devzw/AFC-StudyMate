import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../data/drift/app_database.dart';
import '../../data/models/enums.dart';
import '../../data/models/journal_entry.dart';
import '../../data/models/lesson.dart';
import '../../data/repositories/lesson_repository.dart';
import '../../widgets/completion_banner.dart';
import '../../widgets/design_system_widgets.dart';
import '../../widgets/verse_card.dart';

class DiscoveryScreen extends HookConsumerWidget {
  const DiscoveryScreen({super.key});

  static const String routeName = 'discovery';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discoveryAsync = ref.watch(_discoveryLessonProvider);

    return PremiumScaffold(
      backgroundAsset: 'assets/images/bg_discovery.png',
      appBar: AppBar(
        title: const Text('Discovery', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: discoveryAsync.valueOrNull != null
            ? [
                FutureBuilder(
                  future: ref
                      .read(appDatabaseProvider)
                      .getTeacherGuide(discoveryAsync.valueOrNull!.id),
                  builder: (context, snapshot) {
                    final guide = snapshot.data;
                    if (guide == null) {
                      return const SizedBox.shrink();
                    }
                    return IconButton(
                      icon: const Icon(Icons.school, color: Colors.white),
                      tooltip: "View Teacher's Guide",
                      onPressed: () {
                        context.pushNamed(
                          'teacher-guide',
                          extra: guide,
                          queryParameters: {
                            'title':
                                "${discoveryAsync.valueOrNull!.title} Teacher's Guide",
                          },
                        );
                      },
                    );
                  },
                ),
              ]
            : null,
      ),
      body: discoveryAsync.when(
        data: (lesson) => lesson == null
            ? const Center(
                child: Text(
                  'No Discovery lesson scheduled yet.',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : _DiscoveryContent(lesson: lesson),
        error: (error, stackTrace) => Center(
          child: Text(
            'Unable to load: $error',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.white)),
      ),
    );
  }
}

final _discoveryLessonProvider = FutureProvider<Lesson?>((ref) {
  return ref.read(lessonRepositoryProvider).getDiscoveryLesson();
});

class _DiscoveryContent extends StatelessWidget {
  const _DiscoveryContent({required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final keyVerse = lesson.payload['keyVerse'] as String? ?? '';
    final background = lesson.payload['background'] as String? ?? '';
    final conclusion = lesson.payload['conclusion'] as String? ?? '';
    final questions = (lesson.payload['questions'] as List<dynamic>? ?? [])
        .cast<String>();

    return ListView(
      padding: const EdgeInsets.all(24),
      children: <Widget>[
        Text(
          'Lesson ${lesson.weekIndex ?? 0}: ${lesson.title}',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        if (lesson.bibleReferences.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: VerseCard(
              ref: lesson.bibleReferences.first,
              translationLabel: 'Parallel (KJV/Shona)',
            ),
          ),

        if (keyVerse.isNotEmpty) ...[
          Text(
            'Key Verse',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          PremiumGlassCard(
            child: Text(
              keyVerse,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],

        if (background.isNotEmpty) ...[
          Text(
            'Background',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          PremiumGlassCard(
            child: Text(
              background,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],

        if (questions.isNotEmpty) ...[
          Text(
            'Questions',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < questions.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PremiumGlassCard(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${i + 1}. ',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            questions[i],
                            style: theme.textTheme.bodyMedium?.copyWith(
                              height: 1.5,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _DiscoveryJournalInput(
                    lessonId: lesson.id,
                    questionId: 'question_$i',
                    prompt: questions[i],
                  ),
                ],
              ),
            ),
        ],

        if (conclusion.isNotEmpty) ...[
          Text(
            'Conclusion',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          PremiumGlassCard(
            child: Text(
              conclusion,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],

        CompletionBanner(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Marked as read!')),
            );
          },
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _DiscoveryJournalInput extends StatefulHookConsumerWidget {
  const _DiscoveryJournalInput({
    required this.lessonId,
    required this.questionId,
    required this.prompt,
  });

  final String lessonId;
  final String questionId;
  final String prompt;

  @override
  ConsumerState<_DiscoveryJournalInput> createState() =>
      _DiscoveryJournalInputState();
}

class _DiscoveryJournalInputState
    extends ConsumerState<_DiscoveryJournalInput> {
  final TextEditingController _controller = TextEditingController();
  bool _hasAttemptedLoad = false;
  bool _isSaving = false;
  bool _saved = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!_hasAttemptedLoad) {
      _hasAttemptedLoad = true;
      Future.microtask(() async {
        final db = ref.read(appDatabaseProvider);
        final entries = await db.getJournalEntries(
          'local_user',
          track: Track.discovery,
        );
        final myEntry = entries.firstWhere(
          (e) =>
              e.relatedLessonId == widget.lessonId && e.prompt == widget.prompt,
          orElse: () => throw StateError('Not found'),
        );
        _controller.text = myEntry.response;
      }).catchError((_) {});
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _controller,
            maxLines: null,
            minLines: 3,
            decoration: const InputDecoration(
              hintText: 'Capture your thoughts here',
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none,
            ),
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
            onChanged: (_) {
              if (_saved) setState(() => _saved = false);
            },
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: _isSaving
                ? null
                : () async {
                    if (_controller.text.trim().isEmpty) return;

                    setState(() {
                      _isSaving = true;
                    });

                    final db = ref.read(appDatabaseProvider);
                    final uuid = const Uuid().v4();

                    String entryId = uuid;
                    DateTime createdAt = DateTime.now();

                    try {
                      final entries = await db.getJournalEntries(
                        'local_user',
                        track: Track.discovery,
                      );
                      final existing = entries.firstWhere(
                        (e) =>
                            e.relatedLessonId == widget.lessonId &&
                            e.prompt == widget.prompt,
                      );
                      entryId = existing.id;
                      createdAt = existing.createdAt;
                    } catch (_) {}

                    await db.upsertJournalEntry(
                      JournalEntry(
                        id: entryId,
                        userId: 'local_user',
                        relatedLessonId: widget.lessonId,
                        sourceTrack: Track.discovery,
                        prompt: widget.prompt,
                        response: _controller.text.trim(),
                        createdAt: createdAt,
                        updatedAt: DateTime.now(),
                      ),
                    );

                    if (mounted) {
                      setState(() {
                        _isSaving = false;
                        _saved = true;
                      });

                      Future.delayed(const Duration(seconds: 2), () {
                        if (mounted) {
                          setState(() {
                            _saved = false;
                          });
                        }
                      });
                    }
                  },
            icon: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(
                    _saved ? Icons.check_circle : Icons.save,
                    color: Colors.white,
                  ),
            label: Text(
              _saved ? 'Saved' : 'Save',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
