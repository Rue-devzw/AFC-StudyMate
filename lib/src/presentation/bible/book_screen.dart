import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/bible/entities.dart';
import 'chapter_screen.dart';

class BookScreen extends ConsumerWidget {
  const BookScreen({super.key, required this.book});

  final BibleBook book;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapters = List<int>.generate(book.chapterCount, (index) => index + 1);

    return Scaffold(
      appBar: AppBar(
        title: Text(book.name),
      ),
      body: ListView.separated(
        itemCount: chapters.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final chapter = chapters[index];
          return ListTile(
            title: Text('Chapter $chapter'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChapterScreen(
                    book: book,
                    chapter: chapter,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
