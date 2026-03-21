import 'package:afc_studymate/data/drift/app_database.dart';
import 'package:afc_studymate/data/models/bible_ref.dart';
import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/journal_entry.dart';
import 'package:afc_studymate/data/models/lesson.dart';
import 'package:afc_studymate/data/providers/progress_providers.dart';
import 'package:afc_studymate/data/providers/user_providers.dart';
import 'package:afc_studymate/data/repositories/lesson_pdf_repository.dart';
import 'package:afc_studymate/data/repositories/lesson_repository.dart';
import 'package:afc_studymate/data/services/analytics_service.dart';
import 'package:afc_studymate/data/services/bible_service.dart';
import 'package:afc_studymate/data/services/progress_service.dart';
import 'package:afc_studymate/utils/scripture_reference_parser.dart';
import 'package:afc_studymate/widgets/completion_banner.dart';
import 'package:afc_studymate/widgets/design_system_widgets.dart';
import 'package:afc_studymate/widgets/lesson_display_options.dart';
import 'package:afc_studymate/widgets/linked_verse.dart';
import 'package:afc_studymate/widgets/pdf_viewer_screen.dart';
import 'package:afc_studymate/widgets/retry_error_card.dart';
import 'package:afc_studymate/widgets/skeleton_widgets.dart';
import 'package:afc_studymate/widgets/tts_play_button.dart';
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
    final fontScale = ref.watch(lessonReadingFontScaleProvider);
    final fontStyle = ref.watch(lessonReadingFontStyleProvider);
    final repository = ref.read(lessonPdfRepositoryProvider);
    final studentPdf = lesson == null
        ? null
        : repository.studentPdfForLesson(lesson);
    final teacherGuide = lesson == null
        ? null
        : repository.teacherGuideForLesson(lesson);
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
      backgroundSlot: PremiumBackgroundSlots.discovery,
      appBar: AppBar(
        title: const Text('Discovery', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.text_fields_rounded, color: Colors.white),
            tooltip: 'Reading controls',
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (sheetContext) {
                  return LessonDisplayOptionsSheet(
                    fontScale: fontScale,
                    onFontScaleChanged: (value) {
                      ref.read(lessonReadingFontScaleProvider.notifier).state =
                          value;
                    },
                    fontStyle: fontStyle,
                    onFontStyleChanged: (value) {
                      ref.read(lessonReadingFontStyleProvider.notifier).state =
                          value;
                    },
                  );
                },
              );
            },
          ),
          if (discoveryAsync.valueOrNull != null) ...[
            IconButton(
              icon: const Icon(Icons.view_list, color: Colors.white),
              tooltip: 'Archive',
              onPressed: () {
                context.pushNamed('discoveryArchive');
              },
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
          ],
        ],
      ),
      body: discoveryAsync.when(
        data: (lesson) => lesson == null
            ? const Center(
                child: Text(
                  'No Discovery lesson scheduled yet.',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : LessonReadingScope(
                preferences: LessonReadingPreferences(
                  fontScale: fontScale,
                  fontStyle: fontStyle,
                ),
                child: _DiscoveryContent(
                  lesson: lesson,
                  studentPdf: studentPdf,
                  teacherGuide: teacherGuide,
                ),
              ),
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
  const _DiscoveryContent({
    required this.lesson,
    required this.studentPdf,
    required this.teacherGuide,
  });

  final Lesson lesson;
  final LessonPdfDocument? studentPdf;
  final LessonPdfDocument? teacherGuide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final horizontalPadding = responsiveHorizontalPadding(context);
    const accentColor = Color(0xFF7AE5A9);
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
        20,
        horizontalPadding,
        standardBottomContentPadding(context),
      ),
      children: <Widget>[
        _DiscoveryHeroCard(
          lesson: lesson,
          scriptureCount: lesson.bibleReferences.length,
          questionCount: questions.length,
          accentColor: accentColor,
        ),
        const SizedBox(height: 18),
        PremiumGlassCard(
          borderRadius: BorderRadius.circular(28),
          opacity: 0.12,
          borderOpacity: 0.22,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Learning Path',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Read, reflect, respond',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white60,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Move through the scripture focus, sit with the background, then capture your own responses while the lesson is fresh.',
                style: lessonReadingTextStyle(
                  context,
                  baseStyle: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.88),
                    height: 1.55,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _DiscoveryActionButton(
                    icon: Icons.play_circle_outline,
                    label: 'Listen',
                    child: TtsPlayButton(
                      text: [
                        lesson.title,
                        keyVerse,
                        background,
                        conclusion,
                        questions.join('\n'),
                      ].join('\n\n'),
                    ),
                  ),
                  _DiscoveryActionButton(
                    icon: Icons.picture_as_pdf_outlined,
                    label: 'Lesson PDF',
                    enabled: studentPdf != null,
                    onTap: studentPdf == null
                        ? null
                        : () {
                            context.pushNamed(
                              PdfViewerScreen.routeName,
                              queryParameters: {
                                'path': studentPdf!.path,
                                'title': studentPdf!.title,
                                if (studentPdf!.initialPage != null)
                                  'page': studentPdf!.initialPage.toString(),
                              },
                            );
                          },
                  ),
                  _DiscoveryActionButton(
                    icon: Icons.menu_book_rounded,
                    label: "Teacher's Guide",
                    enabled: teacherGuide != null,
                    onTap: teacherGuide == null
                        ? null
                        : () {
                            context.pushNamed(
                              PdfViewerScreen.routeName,
                              queryParameters: {
                                'path': teacherGuide!.path,
                                'title': teacherGuide!.title,
                                if (teacherGuide!.initialPage != null)
                                  'page': teacherGuide!.initialPage.toString(),
                              },
                            );
                          },
                  ),
                  _DiscoveryActionButton(
                    icon: Icons.share_outlined,
                    label: 'Share',
                    onTap: () {
                      Share.share(
                        'Discovery Lesson ${lesson.weekIndex ?? ''}: ${lesson.title}\n\n$keyVerse',
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        if (!hasBodyContent)
          PremiumGlassCard(
            borderRadius: BorderRadius.circular(24),
            child: Text(
              'Content for this Discovery lesson is not available yet.',
              style: lessonReadingTextStyle(
                context,
                baseStyle: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        if (!hasBodyContent) const SizedBox(height: 24),
        if (lesson.bibleReferences.isNotEmpty) ...[
          _DiscoverySectionCard(
            eyebrow: 'Scripture Focus',
            title: 'Read the passage before answering',
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final bibleRef in lesson.bibleReferences)
                  _DiscoveryPassageLink(reference: bibleRef),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
        if (keyVerse.isNotEmpty) ...[
          _DiscoverySectionCard(
            eyebrow: 'Key Verse',
            title: 'Hold this truth at the center of the lesson',
            child: _DiscoveryKeyVerseBlock(rawKeyVerse: keyVerse),
          ),
          const SizedBox(height: 24),
        ],
        if (background.isNotEmpty) ...[
          _DiscoverySectionCard(
            eyebrow: 'Background',
            title: 'Let the story and setting shape your understanding',
            child: AppDropCapText(
              text: background,
              style: lessonReadingTextStyle(
                context,
                baseStyle: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.65,
                  color: Colors.white.withOpacity(0.92),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
        if (questions.isNotEmpty) ...[
          const _DiscoverySectionHeader(
            eyebrow: 'Reflect & Respond',
            title: 'Turn the lesson into personal understanding',
            subtitle:
                'Each question gives you space to think, write, and keep your reflections for later.',
          ),
          const SizedBox(height: 18),
          for (int i = 0; i < questions.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: _DiscoveryQuestionCard(
                index: i + 1,
                question: questions[i],
                lessonId: lesson.id,
              ),
            ),
        ],
        if (conclusion.isNotEmpty) ...[
          _DiscoverySectionCard(
            eyebrow: 'Takeaway',
            title: 'Leave with one clear spiritual takeaway',
            child: _ScriptureLinkedText(
              text: conclusion,
              style: lessonReadingTextStyle(
                context,
                baseStyle: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                  color: Colors.white.withOpacity(0.92),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
        Consumer(
          builder: (context, ref, child) {
            final completedAsync = ref.watch(
              isLessonCompletedProvider(lesson.id),
            );
            final isCompleted = completedAsync.valueOrNull ?? false;
            return PremiumGlassCard(
              borderRadius: BorderRadius.circular(28),
              opacity: 0.16,
              borderOpacity: 0.26,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isCompleted ? 'Lesson Completed' : 'Complete This Lesson',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isCompleted
                        ? 'You have already marked this lesson as read. You can still revisit the questions and journal responses anytime.'
                        : 'When you have finished reading and reflecting, save your progress so Discovery stays consistent across the app.',
                    style: lessonReadingTextStyle(
                      context,
                      baseStyle: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                        height: 1.55,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Opacity(
                    opacity: isCompleted ? 0.78 : 1,
                    child: IgnorePointer(
                      ignoring: isCompleted,
                      child: CompletionBanner(
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
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _DiscoveryHeroCard extends StatelessWidget {
  const _DiscoveryHeroCard({
    required this.lesson,
    required this.scriptureCount,
    required this.questionCount,
    required this.accentColor,
  });

  final Lesson lesson;
  final int scriptureCount;
  final int questionCount;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor.withOpacity(0.36),
            const Color(0xFF0C3023).withOpacity(0.92),
            const Color(0xFF071914).withOpacity(0.98),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.18),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                const _HeroBadge(label: 'This Week', icon: Icons.auto_awesome),
                _HeroBadge(
                  label: 'Lesson ${lesson.weekIndex ?? 0}',
                  icon: Icons.explore_outlined,
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              lesson.title,
              style: lessonReadingTextStyle(
                context,
                baseStyle: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'A guided mid-week lesson designed to help learners slow down, engage scripture, and write down what the Spirit is teaching them.',
              style: lessonReadingTextStyle(
                context,
                baseStyle: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.84),
                  height: 1.55,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _HeroMetric(
                  label: 'Scripture Focus',
                  value: scriptureCount.toString(),
                ),
                _HeroMetric(
                  label: 'Reflection Prompts',
                  value: questionCount.toString(),
                ),
                const _HeroMetric(
                  label: 'Goal',
                  value: 'Understand and respond',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DiscoverySectionHeader extends StatelessWidget {
  const _DiscoverySectionHeader({
    required this.eyebrow,
    required this.title,
    this.subtitle,
  });

  final String eyebrow;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: theme.textTheme.labelLarge?.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: lessonReadingTextStyle(
            context,
            baseStyle: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: lessonReadingTextStyle(
              context,
              baseStyle: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white70,
                height: 1.5,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _DiscoverySectionCard extends StatelessWidget {
  const _DiscoverySectionCard({
    required this.eyebrow,
    required this.title,
    required this.child,
  });

  final String eyebrow;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PremiumGlassCard(
      borderRadius: BorderRadius.circular(28),
      opacity: 0.13,
      borderOpacity: 0.22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DiscoverySectionHeader(eyebrow: eyebrow, title: title),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _DiscoveryActionButton extends StatelessWidget {
  const _DiscoveryActionButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.enabled = true,
    this.child,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool enabled;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final textColor = enabled ? Colors.white : Colors.white38;
    return Opacity(
      opacity: enabled ? 1 : 0.72,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child:
            child ??
            InkWell(
              onTap: enabled ? onTap : null,
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: textColor, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      label,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}

class _DiscoveryQuestionCard extends StatelessWidget {
  const _DiscoveryQuestionCard({
    required this.index,
    required this.question,
    required this.lessonId,
  });

  final int index;
  final String question;
  final String lessonId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PremiumGlassCard(
      borderRadius: BorderRadius.circular(28),
      opacity: 0.14,
      borderOpacity: 0.22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.12),
                  border: Border.all(color: Colors.white.withOpacity(0.14)),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$index',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reflection Prompt',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _ScriptureLinkedText(
                      text: question,
                      style: lessonReadingTextStyle(
                        context,
                        baseStyle: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.white.withOpacity(0.1),
          ),
          const SizedBox(height: 18),
          _DiscoveryJournalInput(
            lessonId: lessonId,
            questionId: 'question_$index',
            prompt: question,
          ),
        ],
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.11),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 15),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 120),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscoveryPassageLink extends StatelessWidget {
  const _DiscoveryPassageLink({required this.reference});

  final BibleRef reference;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF10332A).withOpacity(0.78),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFA6FFD0).withOpacity(0.24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.open_in_new_rounded,
            size: 16,
            color: Color(0xFFA6FFD0),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: LinkedVerse(
              reference: reference,
              style: lessonReadingTextStyle(
                context,
                baseStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFFA6FFD0),
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline,
                  decorationColor: const Color(0xFFA6FFD0),
                ),
              ),
            ),
          ),
        ],
      ),
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
    final linkedTextStyle = lessonReadingTextStyle(
      context,
      baseStyle: theme.textTheme.bodyLarge?.copyWith(
        fontStyle: FontStyle.italic,
        color: Colors.white,
      ),
    );
    final directRefs = ScriptureReferenceParser.parseReferenceList(rawKeyVerse);

    Widget? resolvedVerseWidget;
    if (directRefs.isNotEmpty) {
      resolvedVerseWidget = Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final reference in directRefs)
              _DiscoveryPassageLink(reference: reference),
          ],
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
              child: _DiscoveryPassageLink(
                reference: parsed.first,
              ),
            );
          }
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: _ScriptureLinkedText(
            text: rawKeyVerse,
            style: linkedTextStyle,
          ),
        ),
        if (resolvedVerseWidget != null) ...[resolvedVerseWidget],
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
        Text(
          'Your Reflection',
          style: theme.textTheme.labelLarge?.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Write what stood out, what challenged you, or how you want to respond.',
          style: lessonReadingTextStyle(
            context,
            baseStyle: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white60,
              height: 1.45,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.14)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: _controller,
            maxLines: null,
            minLines: 4,
            decoration: const InputDecoration(
              hintText: 'Capture your thoughts here',
              border: InputBorder.none,
            ),
            style: lessonReadingTextStyle(
              context,
              baseStyle: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                height: 1.55,
              ),
            ),
            onChanged: (_) {
              if (_saved) setState(() => _saved = false);
            },
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.tonalIcon(
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
              _saved ? 'Reflection Saved' : 'Save Reflection',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.12),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
