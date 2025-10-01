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
    return Scaffold(
      appBar: AppBar(title: Text('$bookName ${chapter.number}')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: chapter.verses.length,
        itemBuilder: (context, index) {
          final verse = chapter.verses[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              '${verse.number} ${verse.text}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        },
      ),
    );
  }
}
