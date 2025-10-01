import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../bible_provider.dart';
import '../models/bible.dart';
import '../services/bible_service.dart';

class ChapterScreen extends StatelessWidget {
  final String chapterId;
  final String chapterNumber;
  final String bookName;

  const ChapterScreen({
    super.key,
    required this.chapterId,
    required this.chapterNumber,
    required this.bookName,
  });

  @override
  Widget build(BuildContext context) {
    final bibleProvider = Provider.of<BibleProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('$bookName $chapterNumber')),
      body: FutureBuilder<Chapter>(
        future: BibleService.getChapter(bibleProvider.selectedBibleId, chapterId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No content found for this chapter.'));
          } else {
            final chapter = snapshot.data!;
            return AnimationLimiter(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                itemCount: chapter.verses.length,
                itemBuilder: (context, index) {
                  final verse = chapter.verses[index];
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
                                verse.number,
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
            );
          }
        },
      ),
    );
  }
}
