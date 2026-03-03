import 'package:afc_studymate/data/models/bible_ref.dart';
import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/verse.dart';
import 'package:afc_studymate/data/providers/user_providers.dart';
import 'package:afc_studymate/data/services/bible_service.dart';
import 'package:afc_studymate/features/bible/bible_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LinkedVerse extends HookConsumerWidget {
  const LinkedVerse({
    required this.reference,
    this.label,
    this.style,
    super.key,
  });

  final BibleRef reference;
  final String? label;
  final TextStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final effectiveStyle = (style ?? theme.textTheme.bodyMedium)?.copyWith(
      color: theme.colorScheme.primary,
      decoration: TextDecoration.underline,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _handleTap(context),
      child: Text(
        (label ?? reference.displayText).trim(),
        style: effectiveStyle,
      ),
    );
  }

  void _handleTap(BuildContext context) {
    final rootContext = context;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return _VersePreviewSheet(
          reference: reference,
          rootContext: rootContext,
          onClose: () => Navigator.of(sheetContext).pop(),
        );
      },
    );
  }
}

class _VersePreviewSheet extends HookConsumerWidget {
  const _VersePreviewSheet({
    required this.reference,
    required this.rootContext,
    required this.onClose,
  });

  final BibleRef reference;
  final BuildContext rootContext;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bibleService = ref.read(bibleServiceProvider);
    final profileAsync = ref.watch(userProfileProvider);
    final translation =
        profileAsync.valueOrNull?.translation ?? Translation.kjv;

    final passageFuture = useMemoized(
      () => bibleService.getPassage(reference, translation),
      <Object?>[reference, translation],
    );
    final passageSnapshot = useFuture(passageFuture);

    Widget content;
    if (passageSnapshot.hasError) {
      content = Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text('Unable to preview passage: ${passageSnapshot.error}'),
        ),
      );
    } else if (!passageSnapshot.hasData) {
      content = const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      final verses = passageSnapshot.data ?? <Verse>[];
      if (verses.isEmpty) {
        content = const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text('Passage not available in this translation.'),
          ),
        );
      } else {
        content = SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: verses.map((verse) => _VerseLine(verse: verse)).toList(),
          ),
        );
      }
    }

    final mediaQuery = MediaQuery.of(context);
    final maxHeight = mediaQuery.size.height * 0.5;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: 24 + mediaQuery.viewPadding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(reference.displayText, style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            _translationLabel(translation),
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: content,
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: () {
                onClose();
                final queryParameters = <String, String>{
                  'book': reference.book,
                  'chapter': reference.chapter.toString(),
                  'translation': translation.name,
                };
                final verse = reference.verseStart;
                if (verse != null) {
                  queryParameters['verse'] = verse.toString();
                }
                rootContext.goNamed(
                  BibleScreen.routeName,
                  queryParameters: queryParameters,
                );
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('Go to full text'),
            ),
          ),
        ],
      ),
    );
  }
}

String _translationLabel(Translation translation) {
  switch (translation) {
    case Translation.kjv:
      return 'King James Version';
    case Translation.shona:
      return 'Shona';
  }
}

class _VerseLine extends StatelessWidget {
  const _VerseLine({required this.verse});

  final Verse verse;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle =
        theme.textTheme.bodyLarge ?? const TextStyle(fontSize: 16);
    final verseNumberStyle = textStyle.copyWith(
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.primary,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SelectableText.rich(
        TextSpan(
          children: <InlineSpan>[
            WidgetSpan(
              alignment: PlaceholderAlignment.aboveBaseline,
              baseline: TextBaseline.alphabetic,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text('${verse.verse}', style: verseNumberStyle),
              ),
            ),
            TextSpan(text: verse.text, style: textStyle),
          ],
        ),
      ),
    );
  }
}
