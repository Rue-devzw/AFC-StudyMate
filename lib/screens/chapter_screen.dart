import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../models/bible.dart';
import '../services/reading_progress_service.dart';

class ChapterScreen extends StatefulWidget {
  final int bookId;
  final int chapterNumber;
  final String bookName;
  final List<Verse> verses;

  const ChapterScreen({
    super.key,
    required this.bookId,
    required this.chapterNumber,
    required this.bookName,
    required this.verses,
  });

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  final ReadingProgressService _readingProgressService = ReadingProgressService();

  @override
  void initState() {
    super.initState();
    _saveReadingProgress();
  }

  Future<void> _saveReadingProgress() async {
    await _readingProgressService.saveReadingProgress(
      widget.bookId,
      widget.chapterNumber,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('${widget.bookName} ${widget.chapterNumber}')),
      body: AnimationLimiter(
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: widget.verses.length,
          itemBuilder: (context, index) {
            final verse = widget.verses[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 400),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: RichText(
                      text: TextSpan(
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 18,
                          height: 1.7,
                        ),
                        children: [
                          TextSpan(
                            text: '${verse.verse} ',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(text: verse.text),
                        ],
                      ),
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
