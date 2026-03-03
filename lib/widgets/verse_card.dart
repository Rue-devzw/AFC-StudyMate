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

class VerseCard extends HookConsumerWidget {
  const VerseCard({
    required this.ref,
    required this.translationLabel,
    super.key,
  });

  final BibleRef ref;
  final String translationLabel;

  @override
  Widget build(BuildContext context, WidgetRef widgetRef) {
    final profileAsync = widgetRef.watch(userProfileProvider);
    final bibleService = widgetRef.read(bibleServiceProvider);
    final translation =
        profileAsync.valueOrNull?.translation ?? Translation.kjv;

    final passageFuture = useMemoized(
      () => bibleService.getPassage(ref, translation),
      <Object?>[ref, translation],
    );
    final passageSnapshot = useFuture(passageFuture);

    final verseText = _buildVerseBody(passageSnapshot.data ?? <Verse>[]);
    final effectiveTranslationLabel = _translationLabel(translation);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          final queryParameters = <String, String>{
            'book': ref.book,
            'chapter': ref.chapter.toString(),
            'translation': translation.name,
          };
          if (ref.verseStart != null) {
            queryParameters['verse'] = ref.verseStart.toString();
          }
          context.pushNamed(
            BibleScreen.routeName,
            queryParameters: queryParameters,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                ref.displayText,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '$translationLabel • $effectiveTranslationLabel',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 12),
              if (passageSnapshot.hasError)
                Text(
                  'Unable to load passage.',
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              else if (!passageSnapshot.hasData)
                const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Text(
                  verseText,
                  textScaler: const TextScaler.linear(1.05),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildVerseBody(List<Verse> verses) {
    if (verses.isEmpty) {
      return 'Passage not available in this translation.';
    }
    return verses.map((verse) => '${verse.verse}. ${verse.text}').join(' ');
  }

  String _translationLabel(Translation translation) {
    switch (translation) {
      case Translation.kjv:
        return 'KJV';
      case Translation.shona:
        return 'Shona';
    }
  }
}
