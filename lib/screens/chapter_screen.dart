import 'package:flutter/material.dart';
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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('$bookName ${chapter.number}')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        itemCount: chapter.verses.length,
        itemBuilder: (context, index) {
          final verse = chapter.verses[index];
          return Padding(
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
          );
        },
      ),
    );
  }
}
