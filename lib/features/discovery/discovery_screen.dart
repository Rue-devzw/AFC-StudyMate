import 'package:afc_studymate/data/drift/app_database.dart';
import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/journal_entry.dart';
import 'package:afc_studymate/data/models/lesson.dart';
import 'package:afc_studymate/data/providers/progress_providers.dart';
import 'package:afc_studymate/data/providers/user_providers.dart';
import 'package:afc_studymate/data/repositories/discovery_guide_repository.dart';
import 'package:afc_studymate/data/repositories/lesson_repository.dart';
import 'package:afc_studymate/data/services/analytics_service.dart';
import 'package:afc_studymate/data/services/bible_service.dart';
import 'package:afc_studymate/data/services/progress_service.dart';
import 'package:afc_studymate/utils/scripture_reference_parser.dart';
import 'package:afc_studymate/widgets/completion_banner.dart';
import 'package:afc_studymate/widgets/design_system_widgets.dart';
import 'package:afc_studymate/widgets/pdf_viewer_screen.dart';
import 'package:afc_studymate/widgets/retry_error_card.dart';
import 'package:afc_studymate/widgets/skeleton_widgets.dart';
import 'package:afc_studymate/widgets/tts_play_button.dart';
import 'package:afc_studymate/widgets/verse_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

class DiscoveryScreen extends HookConsumerWidget {
  const DiscoveryScreen({super.key, this.lessonId});

  static const String routeName = 'discovery';
  final String? lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discoveryAsync = ref.watch(_discoveryLessonProvider(lessonId));
    final lesson = discoveryAsync.valueOrNull;
    final horizontalPadding = responsiveHorizontalPadding(context);

    useEffect(() {
      if (lesson == null) {
        return null;
      }
      Future<void>.microtask(() async {
        await ref
            .read(analyticsServiceProvider)
            .logLessonOpened(
              lessonId: lesson.id,
              track: Track.discovery,
              source: 'discovery_screen',
            );
      });
      return null;
    }, [lesson?.id]);

    return PremiumScaffold(
      backgroundAsset: 'assets/images/bg_discovery.png',
      appBar: AppBar(
        title: const Text('Discovery', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: discoveryAsync.valueOrNull != null
            ? [
                IconButton(
                  icon: const Icon(Icons.view_list, color: Colors.white),
                  tooltip: 'Archive',
                  onPressed: () {
                    context.pushNamed('discoveryArchive');
                  },
                ),
                TtsPlayButton(
                  text: [
                    discoveryAsync.valueOrNull!.title,
                    discoveryAsync.valueOrNull!.payload['keyVerse']
                            as String? ??
                        '',
                    discoveryAsync.valueOrNull!.payload['background']
                            as String? ??
                        '',
                    discoveryAsync.valueOrNull!.payload['conclusion']
                            as String? ??
                        '',
                    (discoveryAsync.valueOrNull!.payload['questions']
                                as List<dynamic>? ??
                            <dynamic>[])
                        .join('\n'),
                  ].join('\n\n'),
                  compact: true,
                ),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  tooltip: 'Share lesson',
                  onPressed: () {
                    final lesson = discoveryAsync.valueOrNull!;
                    Share.share(
                      'Discovery Lesson ${lesson.weekIndex ?? ''}: ${lesson.title}\n\n'
                      '${lesson.payload['keyVerse'] ?? ''}',
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.menu_book_rounded,
                    color: Colors.white,
                  ),
                  tooltip: "Open Teacher's Guides",
                  onPressed: () {
                    final currentLesson = discoveryAsync.valueOrNull!;
                    _openDiscoveryGuidePicker(
                      context: context,
                      repository: ref.read(discoveryGuideRepositoryProvider),
                      lesson: currentLesson,
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
        error: (error, stackTrace) => RetryErrorCard(
          title: 'Unable to load discovery lesson',
          message: '$error',
          onRetry: () => ref.invalidate(_discoveryLessonProvider(lessonId)),
        ),
        loading: () => ListView(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            16,
            horizontalPadding,
            standardBottomContentPadding(context),
          ),
          children: const [
            SkeletonCard(),
            SizedBox(height: 12),
            SkeletonCard(),
            SizedBox(height: 12),
            SkeletonCard(),
          ],
        ),
      ),
    );
  }
}

final FutureProviderFamily<Lesson?, String?> _discoveryLessonProvider =
    FutureProvider.family<Lesson?, String?>((
      ref,
      lessonId,
    ) async {
      final repo = ref.read(lessonRepositoryProvider);
      if (lessonId == null || lessonId.isEmpty) {
        return repo.getDiscoveryLesson();
      }
      return repo.getLessonById(lessonId);
    });

class _DiscoveryContent extends StatelessWidget {
  const _DiscoveryContent({required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final horizontalPadding = responsiveHorizontalPadding(context);
    final keyVerse = lesson.payload['keyVerse'] as String? ?? '';
    final background = lesson.payload['background'] as String? ?? '';
    final conclusion = lesson.payload['conclusion'] as String? ?? '';
    final questions = (lesson.payload['questions'] as List<dynamic>? ?? [])
        .cast<String>();
    final hasBodyContent =
        lesson.bibleReferences.isNotEmpty ||
        keyVerse.isNotEmpty ||
        background.isNotEmpty ||
        questions.isNotEmpty ||
        conclusion.isNotEmpty;

    return ListView(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        24,
        horizontalPadding,
        standardBottomContentPadding(context),
      ),
      children: <Widget>[
        Text(
          'Lesson ${lesson.weekIndex ?? 0}: ${lesson.title}',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        if (!hasBodyContent)
          PremiumGlassCard(
            child: Text(
              'Content for this Discovery lesson is not available yet.',
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
            ),
          ),
        if (!hasBodyContent) const SizedBox(height: 24),
        if (lesson.bibleReferences.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              children: [
                for (final bibleRef in lesson.bibleReferences)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: VerseCard(
                      ref: bibleRef,
                      translationLabel: 'Your selected translation',
                    ),
                  ),
              ],
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
            child: _DiscoveryKeyVerseBlock(rawKeyVerse: keyVerse),
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
            child: _ScriptureLinkedText(
              text: background,
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
                          child: _ScriptureLinkedText(
                            text: questions[i],
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
            child: _ScriptureLinkedText(
              text: conclusion,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],

        Consumer(
          builder: (context, ref, child) {
            return CompletionBanner(
              onTap: () async {
                await ref
                    .read(progressServiceProvider)
                    .recordComplete(
                      userId: localUserId,
                      lessonId: lesson.id,
                      track: Track.discovery,
                    );
                triggerProgressRefresh(ref);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Marked as read!')),
                );
              },
            );
          },
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _ScriptureLinkedText extends StatelessWidget {
  const _ScriptureLinkedText({required this.text, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: style,
        children: ScriptureReferenceParser.buildLinkedTextSpans(
          context,
          text,
          style,
        ),
      ),
    );
  }
}

class _DiscoveryKeyVerseBlock extends HookConsumerWidget {
  const _DiscoveryKeyVerseBlock({required this.rawKeyVerse});

  final String rawKeyVerse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final linkedTextStyle = theme.textTheme.bodyLarge?.copyWith(
      fontStyle: FontStyle.italic,
      color: Colors.white,
    );
    final directRefs = ScriptureReferenceParser.parseReferenceList(rawKeyVerse);

    Widget? resolvedVerseWidget;
    if (directRefs.isNotEmpty) {
      resolvedVerseWidget = Padding(
        padding: const EdgeInsets.only(top: 12),
        child: VerseCard(
          ref: directRefs.first,
          translationLabel: 'Resolved key verse',
        ),
      );
    } else {
      final profile = ref.watch(userProfileProvider).valueOrNull;
      final translation = profile?.translation ?? Translation.kjv;
      final searchQuery = _keyVerseSearchQuery(rawKeyVerse);
      if (searchQuery != null) {
        final searchFuture = useMemoized(
          () => ref.read(bibleServiceProvider).search(searchQuery, translation),
          <Object?>[searchQuery, translation],
        );
        final searchSnapshot = useFuture(searchFuture);
        if (searchSnapshot.hasData && (searchSnapshot.data ?? []).isNotEmpty) {
          final firstHit = searchSnapshot.data!.first;
          final parsed = ScriptureReferenceParser.parseReferenceList(
            firstHit.reference,
          );
          if (parsed.isNotEmpty) {
            resolvedVerseWidget = Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resolved from Bible: ${firstHit.reference}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  VerseCard(
                    ref: parsed.first,
                    translationLabel: 'Resolved key verse',
                  ),
                ],
              ),
            );
          }
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ScriptureLinkedText(text: rawKeyVerse, style: linkedTextStyle),
        ...?resolvedVerseWidget != null
            ? <Widget>[resolvedVerseWidget]
            : null,
      ],
    );
  }

  String? _keyVerseSearchQuery(String value) {
    final cleaned = value
        .replaceAll(RegExp('[“”"()]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (cleaned.isEmpty) {
      return null;
    }
    final words = cleaned.split(' ');
    if (words.length < 4) {
      return null;
    }
    final phrase = words.take(8).join(' ');
    return phrase.length < 12 ? null : phrase;
  }
}

void _openDiscoveryGuidePicker({
  required BuildContext context,
  required DiscoveryGuideRepository repository,
  required Lesson lesson,
}) {
  final options = repository.getGuideOptionsForLesson(lesson.id);
  showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    showDragHandle: true,
    builder: (sheetContext) {
      if (options.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(20),
          child: Text('No Discovery teacher guides are available.'),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          return ListTile(
            leading: Icon(
              option.recommended ? Icons.star_rounded : Icons.picture_as_pdf,
              color: option.recommended ? Colors.amber : null,
            ),
            title: Text(option.title),
            subtitle: Text('Page ${option.startPage}'),
            onTap: () {
              Navigator.of(sheetContext).pop();
              context.pushNamed(
                PdfViewerScreen.routeName,
                queryParameters: {
                  'path': option.pdfPath,
                  'title': option.title,
                  'page': option.startPage.toString(),
                },
              );
            },
          );
        },
      );
    },
  );
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

                    var entryId = uuid;
                    var createdAt = DateTime.now();

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
                    await ref
                        .read(analyticsServiceProvider)
                        .logJournalSaved(
                          source: 'discovery_question',
                          track: Track.discovery,
                          lessonId: widget.lessonId,
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
