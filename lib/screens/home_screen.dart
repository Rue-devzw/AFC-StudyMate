import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:share_plus/share_plus.dart';
import '../models/bible.dart';
import '../models/verse_of_the_day.dart';
import '../screens/bible_screen.dart';
import '../screens/chapter_screen.dart';
import '../screens/lessons_screen.dart';
import '../screens/settings_screen.dart';
import '../services/bible_service.dart';
import '../services/reading_progress_service.dart';
import '../services/verse_of_the_day_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const LessonsScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AFC StudyMate'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Lessons'),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    final ReadingProgressService readingProgressService = ReadingProgressService();
    final BibleService bibleService = BibleService();

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/logo.png', height: 120),
              const SizedBox(height: 30),
              const VerseOfTheDayCard(),
              const SizedBox(height: 30),
              AnimationLimiter(
                child: Column(
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 375),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BibleScreen(),
                            ),
                          );
                        },
                        child: const Text('Read Bible'),
                      ),
                      const SizedBox(height: 16),
                      FutureBuilder<Map<String, int?>>(
                        future: readingProgressService.getReadingProgress(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done &&
                              snapshot.data != null &&
                              snapshot.data!['bookId'] != null) {
                            return ElevatedButton(
                              onPressed: () async {
                                final progress = snapshot.data!;
                                final bookId = progress['bookId']!;
                                final chapter = progress['chapter']!;
                                final List<Book> books = await bibleService.loadBooks();
                                final book = books.firstWhere((b) => b.id == bookId);
                                final verses = await bibleService.getVerses(bookId, chapter);

                                if (!mounted) return;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChapterScreen(
                                      bookId: bookId,
                                      chapterNumber: chapter,
                                      bookName: book.name,
                                      verses: verses,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Continue Reading'),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VerseOfTheDayCard extends StatefulWidget {
  const VerseOfTheDayCard({super.key});

  @override
  State<VerseOfTheDayCard> createState() => _VerseOfTheDayCardState();
}

class _VerseOfTheDayCardState extends State<VerseOfTheDayCard> {
  final VerseOfTheDayService _verseOfTheDayService = VerseOfTheDayService();
  Future<VerseOfTheDay>? _verseFuture;

  @override
  void initState() {
    super.initState();
    _verseFuture = _verseOfTheDayService.getVerseOfTheDay();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<VerseOfTheDay>(
          future: _verseFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Failed to load verse.'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No verse available.'));
            } else {
              final verse = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Verse of the Day',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    verse.text,
                    style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16, height: 1.6),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    verse.reference,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: theme.colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    icon: const Icon(Icons.share_outlined),
                    onPressed: () {
                      Share.share(
                        '"${verse.text}" - ${verse.reference}',
                        subject: 'Verse of the Day',
                      );
                    },
                    tooltip: 'Share Verse',
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
