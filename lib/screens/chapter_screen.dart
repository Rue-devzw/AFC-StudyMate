import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../bible_provider.dart';
import '../models/bible.dart';

class ChapterScreen extends StatelessWidget {
  final Chapter chapter;
  final String bookName;

  const ChapterScreen({
    super.key,
    required this.chapter,
    required this.bookName,
  });

  @override
  Widget build(BuildContext context) {
    final bibleProvider = Provider.of<BibleProvider>(context);
    final currentBook = bibleProvider.bible.books.firstWhere((b) => b.name == bookName);
    final currentChapter = currentBook.chapters.firstWhere((c) => c.number == chapter.number);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('$bookName ${chapter.number}')),
      body: AnimationLimiter(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          itemCount: currentChapter.verses.length,
          itemBuilder: (context, index) {
            final verse = currentChapter.verses[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${verse.number}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            verse.text,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              height: 1.6,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
