import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../bible/bible_screen.dart';
import '../bible/chapter_screen.dart';
import '../../domain/bible/entities.dart';
import '../lessons/lessons_screen.dart';
import '../teacher/teacher_tools_screen.dart';
import '../settings/settings_screen.dart';
import '../providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _HomeDashboard(),
      const LessonsScreen(),
      const TeacherToolsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('AFC StudyMate'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Open settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Lessons'),
          BottomNavigationBarItem(icon: Icon(Icons.manage_accounts), label: 'Teacher'),
        ],
      ),
    );
  }
}

class _HomeDashboard extends ConsumerWidget {
  const _HomeDashboard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verseAsync = ref.watch(verseOfTheDayProvider);
    final readingProgressAsync = ref.watch(readingProgressProvider);
    final readingPosition =
        readingProgressAsync.maybeWhen(data: (value) => value, orElse: () => null);

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 120,
                semanticLabel: 'AFC StudyMate logo',
              ),
              const SizedBox(height: 30),
              Semantics(
                container: true,
                label: 'Verse of the day card',
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: verseAsync.when(
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (error, stack) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Failed to load verse of the day'),
                          const SizedBox(height: 8),
                          Text(error.toString()),
                        ],
                      ),
                      data: (verse) => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Verse of the Day',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            verse.text,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontSize: 16, height: 1.6),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            verse.reference,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: Theme.of(context).colorScheme.primary,
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
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              FocusTraversalGroup(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.menu_book_outlined),
                      label: const Text('Read Bible'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BibleScreen(),
                        ),
                      );
                    },
                  ),
                  if (readingPosition != null)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Continue Reading'),
                      onPressed: () async {
                        final position = readingPosition;
                        ref
                            .read(selectedTranslationIdsProvider.notifier)
                            .setPrimary(position.translationId);
                        final books =
                            await ref.read(getBooksUseCaseProvider)(position.translationId);
                        BibleBook? book;
                        try {
                          book = books.firstWhere((b) => b.id == position.bookId);
                        } catch (_) {
                          book = null;
                        }
                        if (!context.mounted) return;
                        if (book == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Saved reading location is unavailable.'),
                            ),
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChapterScreen(
                              book: book!,
                              chapter: position.chapter,
                            ),
                          ),
                        );
                      },
                    ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.school_outlined),
                    label: const Text('Browse Lessons'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LessonsScreen(),
                        ),
                      );
                    },
                  ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
