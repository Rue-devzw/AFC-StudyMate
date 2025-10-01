import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../bible_provider.dart';
import '../models/bible.dart';
import '../services/bible_service.dart';
import 'chapter_screen.dart';

class BookScreen extends StatelessWidget {
  final Book book;

  const BookScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final bibleProvider = Provider.of<BibleProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(book.name)),
      body: FutureBuilder<List<Chapter>>(
        future: BibleService.getChapters(bibleProvider.selectedBibleId, book.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No chapters found for this book.'));
          } else {
            final chapters = snapshot.data!;
            return AnimationLimiter(
              child: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: chapters.length,
                itemBuilder: (context, index) {
                  final chapter = chapters[index];
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
                                  chapterId: chapter.id,
                                  chapterNumber: chapter.number,
                                  bookName: book.name,
                                ),
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
                                chapter.number,
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
            );
          }
        },
      ),
    );
  }
}
