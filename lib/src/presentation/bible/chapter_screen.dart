import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/bible/entities.dart';
import '../providers.dart';

class ChapterScreen extends ConsumerWidget {
  const ChapterScreen({
    super.key,
    required this.book,
    required this.chapter,
  });

  final BibleBook book;
  final int chapter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translationId = ref.watch(selectedTranslationIdProvider);
    final versesAsync = ref.watch(
      chapterProvider(
        ChapterRequest(
          translationId: translationId,
          bookId: book.id,
          chapter: chapter,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${book.name} $chapter'),
      ),
      body: versesAsync.when(
        data: (verses) => ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          itemCount: verses.length,
          itemBuilder: (context, index) {
            final verse = verses[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${verse.verse}. ',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: verse.text,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Failed to load chapter: $error'),
        ),
      ),
    );
  }
}
