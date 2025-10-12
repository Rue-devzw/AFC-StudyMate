import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/bible_book.dart';
import '../../data/models/bible_ref.dart';
import '../../data/models/enums.dart';
import '../../data/models/verse.dart';
import '../../data/services/bible_service.dart';

class BibleScreen extends HookConsumerWidget {
  const BibleScreen({
    super.key,
    this.initialBook,
    this.initialChapter,
    this.highlightVerse,
  });

  static const String routeName = 'bible';

  final String? initialBook;
  final int? initialChapter;
  final int? highlightVerse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bibleService = ref.read(bibleServiceProvider);

    final translation = useState(Translation.kjv);
    final selectedBookNumber = useState<int?>(null);
    final selectedChapter = useState(initialChapter ?? 1);
    final fontScale = useState(1.0);
    final readingFontStyle = useState(ReadingFontStyle.serif);
    final hasAppliedInitialSelection = useRef<bool>(false);

    final booksFuture = useMemoized(
      () => bibleService.getBooks(translation.value),
      <Object?>[translation.value],
    );
    final booksSnapshot = useFuture(booksFuture);

    final normalizedInitialBook = initialBook?.toLowerCase();
    final initialChapterNumber = initialChapter;
    useEffect(() {
      final books = booksSnapshot.data;
      if (books == null || books.isEmpty) {
        selectedBookNumber.value = null;
        return null;
      }

      if (!hasAppliedInitialSelection.value) {
        if (normalizedInitialBook != null) {
          final match = books.firstWhereOrNull(
            (book) => book.name.toLowerCase() == normalizedInitialBook,
          );
          if (match != null) {
            selectedBookNumber.value = match.number;
            selectedChapter.value = initialChapterNumber ?? selectedChapter.value;
            hasAppliedInitialSelection.value = true;
            return null;
          }
        }

        final current = selectedBookNumber.value;
        if (current == null || books.firstWhereOrNull((book) => book.number == current) == null) {
          selectedBookNumber.value = books.first.number;
        }
        hasAppliedInitialSelection.value = true;
      } else {
        final current = selectedBookNumber.value;
        if (current == null || books.firstWhereOrNull((book) => book.number == current) == null) {
          selectedBookNumber.value = books.first.number;
          selectedChapter.value = 1;
        }
      }
      return null;
    }, <Object?>[booksSnapshot.data, normalizedInitialBook, initialChapterNumber]);

    final selectedBook = booksSnapshot.data?.firstWhereOrNull(
      (book) => book.number == selectedBookNumber.value,
    );

    final chapterCountFuture = useMemoized(
      () {
        final book = selectedBook;
        if (book == null) {
          return Future<int>.value(0);
        }
        return bibleService.getChapterCount(book.name, translation.value);
      },
      <Object?>[selectedBook?.number, translation.value],
    );
    final chapterCountSnapshot = useFuture(chapterCountFuture);

    useEffect(() {
      final count = chapterCountSnapshot.data;
      if (count == null || count == 0) {
        return null;
      }
      if (selectedChapter.value > count) {
        selectedChapter.value = 1;
      }
      return null;
    }, <Object?>[chapterCountSnapshot.data]);

    final passageFuture = useMemoized(
      () {
        final book = selectedBook;
        if (book == null) {
          return Future<List<Verse>>.value(<Verse>[]);
        }
        return bibleService.getChapter(book.name, selectedChapter.value, translation.value);
      },
      <Object?>[selectedBook?.number, selectedChapter.value, translation.value],
    );
    final passageSnapshot = useFuture(passageFuture);

    final verses = passageSnapshot.data ?? <Verse>[];
    final isLoading = booksSnapshot.connectionState != ConnectionState.done ||
        chapterCountSnapshot.connectionState != ConnectionState.done ||
        passageSnapshot.connectionState != ConnectionState.done;

    final title = selectedBook != null ? '${selectedBook.name} ${selectedChapter.value}' : 'Bible';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          TextButton.icon(
            onPressed: booksSnapshot.hasData && (booksSnapshot.data?.isNotEmpty ?? false)
                ? () async {
                    final books = booksSnapshot.data;
                    if (books == null || books.isEmpty) {
                      return;
                    }
                    final result = await showModalBottomSheet<_PassageSelectionResult>(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      builder: (BuildContext context) {
                        return _PassageSelectorSheet(
                          books: books,
                          initialBookNumber: selectedBookNumber.value,
                          initialChapter: selectedChapter.value,
                          translation: translation.value,
                          bibleService: bibleService,
                        );
                      },
                    );

                    if (result != null) {
                      selectedBookNumber.value = result.book.number;
                      selectedChapter.value = result.chapter;
                    }
                  }
                : null,
            icon: const Icon(Icons.menu_book_outlined),
            label: const Text('Passage'),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.onPrimary,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search Bible',
            onPressed: () async {
              final result = await showSearch<BibleRef?>(
                context: context,
                delegate: _BibleSearchDelegate(
                  bibleService: bibleService,
                  translation: translation.value,
                ),
              );
              if (result == null) {
                return;
              }

              final books = booksSnapshot.data;
              final match = books?.firstWhereOrNull(
                (book) => book.name.toLowerCase() == result.book.toLowerCase(),
              );

              if (match == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Unable to open ${result.book} in this translation.')),
                );
                return;
              }

              selectedBookNumber.value = match.number;
              selectedChapter.value = result.chapter;
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          if (isLoading) const LinearProgressIndicator(minHeight: 2),
          Expanded(
            child: Builder(
              builder: (BuildContext context) {
                if (booksSnapshot.hasError) {
                  return _CenteredMessage('Unable to load books: ${booksSnapshot.error}');
                }
                if (chapterCountSnapshot.hasError) {
                  return _CenteredMessage(
                    'Unable to load chapters for ${selectedBook?.name ?? 'this book'}: ${chapterCountSnapshot.error}',
                  );
                }
                if (passageSnapshot.hasError) {
                  return _CenteredMessage('Unable to load passage: ${passageSnapshot.error}');
                }
                if ((booksSnapshot.data?.isEmpty ?? true)) {
                  return const _CenteredMessage('No books available for this translation.');
                }
                if (verses.isEmpty) {
                  return const _CenteredMessage('Select a passage to begin reading.');
                }

                final textStyle = _readingTextStyle(context, fontScale.value, readingFontStyle.value);
                final verseNumberStyle = textStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                );

                final highlightVerseNumber = highlightVerse;
                final shouldHighlightBook = normalizedInitialBook != null &&
                    selectedBook?.name.toLowerCase() == normalizedInitialBook &&
                    (initialChapterNumber == null || selectedChapter.value == initialChapterNumber);

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                  itemBuilder: (BuildContext context, int index) {
                    final verse = verses[index];
                    final verseText = SelectableText.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          WidgetSpan(
                            baseline: TextBaseline.alphabetic,
                            alignment: PlaceholderAlignment.aboveBaseline,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                '${verse.verse}',
                                style: verseNumberStyle,
                              ),
                            ),
                          ),
                          TextSpan(text: verse.text, style: textStyle),
                        ],
                      ),
                    );
                    if (highlightVerseNumber == null || !shouldHighlightBook || verse.verse != highlightVerseNumber) {
                      return verseText;
                    }
                    return Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: verseText,
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemCount: verses.length,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: _DisplayOptionsBar(
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              useSafeArea: true,
              builder: (BuildContext context) {
                return _DisplayOptionsSheet(
                  fontScale: fontScale.value,
                  onFontScaleChanged: (value) => fontScale.value = value,
                  fontStyle: readingFontStyle.value,
                  onFontStyleChanged: (value) => readingFontStyle.value = value,
                  translation: translation.value,
                  onTranslationChanged: (value) {
                    translation.value = value;
                    selectedBookNumber.value = null;
                    selectedChapter.value = 1;
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

TextStyle _readingTextStyle(BuildContext context, double scale, ReadingFontStyle style) {
  final base = Theme.of(context).textTheme.bodyLarge ?? const TextStyle(fontSize: 16, height: 1.5);
  final baseSize = base.fontSize ?? 16;
  final fontFamilyFallback = style == ReadingFontStyle.serif
      ? const <String>['Noto Serif', 'Merriweather', 'Times New Roman', 'serif']
      : base.fontFamilyFallback;

  return base.copyWith(
    fontSize: baseSize * scale,
    height: 1.6,
    fontFamilyFallback: fontFamilyFallback,
  );
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _DisplayOptionsBar extends StatelessWidget {
  const _DisplayOptionsBar({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: FilledButton.tonalIcon(
        onPressed: onPressed,
        icon: const Icon(Icons.text_fields),
        label: const Text('Display options'),
      ),
    );
  }
}

class _DisplayOptionsSheet extends StatefulWidget {
  const _DisplayOptionsSheet({
    required this.fontScale,
    required this.onFontScaleChanged,
    required this.fontStyle,
    required this.onFontStyleChanged,
    required this.translation,
    required this.onTranslationChanged,
  });

  final double fontScale;
  final ValueChanged<double> onFontScaleChanged;
  final ReadingFontStyle fontStyle;
  final ValueChanged<ReadingFontStyle> onFontStyleChanged;
  final Translation translation;
  final ValueChanged<Translation> onTranslationChanged;

  @override
  State<_DisplayOptionsSheet> createState() => _DisplayOptionsSheetState();
}

class _DisplayOptionsSheetState extends State<_DisplayOptionsSheet> {
  late double _fontScale = widget.fontScale;
  late ReadingFontStyle _fontStyle = widget.fontStyle;
  late Translation _translation = widget.translation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Reading preferences', style: theme.textTheme.titleLarge),
          const SizedBox(height: 24),
          Text('Font size', style: theme.textTheme.titleMedium),
          Slider(
            value: _fontScale,
            min: 0.8,
            max: 1.6,
            divisions: 8,
            label: '${(_fontScale * 100).round()}%',
            onChanged: (value) {
              setState(() => _fontScale = value);
              widget.onFontScaleChanged(value);
            },
          ),
          const SizedBox(height: 16),
          Text('Font style', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<ReadingFontStyle>(
            segments: const <ButtonSegment<ReadingFontStyle>>[
              ButtonSegment(value: ReadingFontStyle.serif, label: Text('Serif')),
              ButtonSegment(value: ReadingFontStyle.sans, label: Text('Sans-serif')),
            ],
            selected: <ReadingFontStyle>{_fontStyle},
            onSelectionChanged: (selection) {
              final value = selection.first;
              setState(() => _fontStyle = value);
              widget.onFontStyleChanged(value);
            },
          ),
          const SizedBox(height: 16),
          Text('Translation', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<Translation>(
            value: _translation,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: Translation.values
                .map(
                  (translation) => DropdownMenuItem<Translation>(
                    value: translation,
                    child: Text(_translationLabel(translation)),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) {
                return;
              }
              setState(() => _translation = value);
              widget.onTranslationChanged(value);
            },
          ),
        ],
      ),
    );
  }
}

String _translationLabel(Translation translation) {
  switch (translation) {
    case Translation.kjv:
      return 'King James Version (KJV)';
    case Translation.shona:
      return 'Shona Bible';
  }
}

class _PassageSelectorSheet extends HookWidget {
  const _PassageSelectorSheet({
    required this.books,
    required this.initialBookNumber,
    required this.initialChapter,
    required this.translation,
    required this.bibleService,
  });

  final List<BibleBook> books;
  final int? initialBookNumber;
  final int initialChapter;
  final Translation translation;
  final BibleService bibleService;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeBookNumber = useState<int?>(initialBookNumber ?? books.first.number);

    final initialTabIndex = _tabIndexFor(activeBookNumber.value ?? books.first.number);
    final tabController = useTabController(initialLength: 2, initialIndex: initialTabIndex);

    useEffect(() {
      final bookNumber = activeBookNumber.value;
      if (bookNumber != null) {
        final index = _tabIndexFor(bookNumber);
        if (tabController.index != index) {
          tabController.index = index;
        }
      }
      return null;
    }, <Object?>[activeBookNumber.value]);

    final selectedChapter = useState(initialChapter);

    useEffect(() {
      if (activeBookNumber.value == initialBookNumber) {
        selectedChapter.value = initialChapter;
      } else {
        selectedChapter.value = 1;
      }
      return null;
    }, <Object?>[activeBookNumber.value]);

    final activeBook = books.firstWhereOrNull((book) => book.number == activeBookNumber.value) ?? books.first;

    final chapterCountFuture = useMemoized(
      () => bibleService.getChapterCount(activeBook.name, translation),
      <Object?>[activeBook.number, translation],
    );
    final chapterCountSnapshot = useFuture(chapterCountFuture);

    final oldTestamentBooks = useMemoized(
      () => books.where((book) => book.testament == Testament.old).toList(),
      <Object?>[books],
    );
    final newTestamentBooks = useMemoized(
      () =>
          books.where((book) => book.testament == Testament.newTestament).toList(),
      <Object?>[books],
    );

    final handleColor = theme.colorScheme.onSurfaceVariant.withOpacity(0.3);

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 12),
            Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: handleColor,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 16),
            Text('Select passage', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            TabBar(
              controller: tabController,
              tabs: const <Widget>[
                Tab(text: 'Old Testament'),
                Tab(text: 'New Testament'),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: TabBarView(
                      controller: tabController,
                      children: <Widget>[
                        _BookGrid(
                          books: oldTestamentBooks,
                          activeBook: activeBook,
                          onSelected: (book) => activeBookNumber.value = book.number,
                        ),
                        _BookGrid(
                          books: newTestamentBooks,
                          activeBook: activeBook,
                          onSelected: (book) => activeBookNumber.value = book.number,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Chapters in ${activeBook.name}',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    flex: 4,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Builder(
                        key: ValueKey<int?>(activeBook.number),
                        builder: (BuildContext context) {
                          if (chapterCountSnapshot.hasError) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'Unable to load chapters for ${activeBook.name}.',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                          if (chapterCountSnapshot.connectionState != ConnectionState.done) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          final count = chapterCountSnapshot.data ?? 0;
                          if (count == 0) {
                            return const Center(child: Text('No chapters available.'));
                          }

                          return _ChapterGrid(
                            chapterCount: count,
                            selectedChapter: selectedChapter.value,
                            onSelected: (chapter) {
                              Navigator.of(context).pop(
                                _PassageSelectionResult(book: activeBook, chapter: chapter),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _BookGrid extends StatelessWidget {
  const _BookGrid({
    required this.books,
    required this.activeBook,
    required this.onSelected,
  });

  final List<BibleBook> books;
  final BibleBook activeBook;
  final ValueChanged<BibleBook> onSelected;

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return const Center(child: Text('No books available.'));
    }

    final theme = Theme.of(context);

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.8,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: books.length,
      itemBuilder: (BuildContext context, int index) {
        final book = books[index];
        final isSelected = activeBook.number == book.number;
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: isSelected ? theme.colorScheme.primaryContainer : null,
            foregroundColor: isSelected ? theme.colorScheme.onPrimaryContainer : null,
          ),
          onPressed: () => onSelected(book),
          child: Text(
            book.name,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}

class _ChapterGrid extends StatelessWidget {
  const _ChapterGrid({
    required this.chapterCount,
    required this.selectedChapter,
    required this.onSelected,
  });

  final int chapterCount;
  final int selectedChapter;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: chapterCount,
      itemBuilder: (BuildContext context, int index) {
        final chapter = index + 1;
        final isSelected = selectedChapter == chapter;
        return FilledButton.tonal(
          style: FilledButton.styleFrom(
            backgroundColor: isSelected ? theme.colorScheme.primary : null,
            foregroundColor: isSelected ? theme.colorScheme.onPrimary : null,
          ),
          onPressed: () => onSelected(chapter),
          child: Text('$chapter'),
        );
      },
    );
  }
}

class _PassageSelectionResult {
  const _PassageSelectionResult({required this.book, required this.chapter});

  final BibleBook book;
  final int chapter;
}

class _BibleSearchDelegate extends SearchDelegate<BibleRef?> {
  _BibleSearchDelegate({required this.bibleService, required this.translation})
      : super(searchFieldLabel: 'Search Bible');

  final BibleService bibleService;
  final Translation translation;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildResultList();

  @override
  Widget buildSuggestions(BuildContext context) => _buildResultList();

  Widget _buildResultList() {
    final trimmedQuery = query.trim();
    if (trimmedQuery.length < 3) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Enter at least three characters to search.'),
        ),
      );
    }

    return FutureBuilder<List<VerseSearchHit>>(
      future: bibleService.search(trimmedQuery, translation),
      builder: (BuildContext context, AsyncSnapshot<List<VerseSearchHit>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Search failed: ${snapshot.error}'));
        }
        final results = snapshot.data ?? <VerseSearchHit>[];
        if (results.isEmpty) {
          return const Center(child: Text('No verses found.'));
        }
        return ListView.separated(
          itemCount: results.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (BuildContext context, int index) {
            final hit = results[index];
            return ListTile(
              title: Text(hit.reference),
              subtitle: Text(
                hit.preview,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                final reference = _parseReference(hit.reference);
                if (reference == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Unable to open ${hit.reference}')),
                  );
                  return;
                }
                close(context, reference);
              },
            );
          },
        );
      },
    );
  }

  BibleRef? _parseReference(String reference) {
    final match = RegExp(r'^(.+)\s+(\d+):(\d+)$').firstMatch(reference.trim());
    if (match == null) {
      return null;
    }

    final book = match.group(1)!.trim();
    final chapter = int.tryParse(match.group(2)!);
    if (chapter == null) {
      return null;
    }

    final verse = int.tryParse(match.group(3)!);
    return BibleRef(book: book, chapter: chapter, verseStart: verse, verseEnd: verse);
  }
}

enum ReadingFontStyle { serif, sans }

int _tabIndexFor(int bookNumber) => bookNumber <= 39 ? 0 : 1;
