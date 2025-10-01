import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../bible_provider.dart';
import '../models/bible.dart';
import 'chapter_screen.dart';

class BookScreen extends StatelessWidget {
  final Book book;

  const BookScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final bibleProvider = Provider.of<BibleProvider>(context);
    final currentBook = bibleProvider.bible.books.firstWhere((b) => b.name == book.name);

    return Scaffold(
      appBar: AppBar(title: Text(currentBook.name)),
      body: AnimationLimiter(
        child: GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1.0,
          ),
          itemCount: currentBook.chapters.length,
          itemBuilder: (context, index) {
            final chapter = currentBook.chapters[index];
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 375),
              columnCount: 4,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChapterScreen(
                              chapter: chapter, bookName: currentBook.name),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          chapter.number.toString(),
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
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
