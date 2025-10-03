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
import '../l10n/l10n.dart';

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
        title: Text(context.l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: context.l10n.homeOpenSettingsTooltip,
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
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: context.l10n.homeNavHome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.school),
            label: context.l10n.homeNavLessons,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.manage_accounts),
            label: context.l10n.homeNavTeacher,
          ),
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
                semanticLabel: context.l10n.homeLogoSemanticLabel,
              ),
              const SizedBox(height: 30),
              Semantics(
                container: true,
                label: context.l10n.homeVerseCardSemanticLabel,
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
                          Text(context.l10n.homeVerseLoadError),
                          const SizedBox(height: 8),
                          Text(error.toString()),
                        ],
                      ),
                      data: (verse) => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            context.l10n.homeVerseOfTheDayTitle,
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
                                context.l10n
                                    .homeVerseShareText(verse.text, verse.reference),
                                subject: context.l10n.homeVerseShareSubject,
                              );
                            },
                            tooltip: context.l10n.homeVerseShareTooltip,
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
                      label: Text(context.l10n.homeReadBible),
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
                      label: Text(context.l10n.homeContinueReading),
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
                            SnackBar(
                              content: Text(
                                context.l10n.homeSavedReadingUnavailable,
                              ),
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
                    label: Text(context.l10n.homeBrowseLessons),
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
