import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/enums.dart';
import '../../data/models/verse.dart';
import '../../data/services/bible_service.dart';

class BibleScreen extends HookConsumerWidget {
  const BibleScreen({super.key});

  static const String routeName = 'bible';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bibleService = ref.read(bibleServiceProvider);
    final translation = useState(Translation.kjv);
    final selectedBook = useState<String?>(null);
    final selectedChapter = useState<int>(1);

    final booksFuture = useMemoized(
      () => bibleService.getBooks(translation.value),
      <Object?>[translation.value],
    );
    final booksSnapshot = useFuture(booksFuture);

    useEffect(() {
      final books = booksSnapshot.data;
      if (books == null || books.isEmpty) {
        selectedBook.value = null;
        return null;
      }
      if (selectedBook.value == null || !books.contains(selectedBook.value)) {
        selectedBook.value = books.first;
        selectedChapter.value = 1;
      }
      return null;
    }, <Object?>[booksSnapshot.data]);

    final chapterCountFuture = useMemoized(
      () {
        final book = selectedBook.value;
        if (book == null) {
          return Future<int>.value(0);
        }
        return bibleService.getChapterCount(book, translation.value);
      },
      <Object?>[selectedBook.value, translation.value],
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
        final book = selectedBook.value;
        if (book == null) {
          return Future<List<Verse>>.value(<Verse>[]);
        }
        return bibleService.getChapter(book, selectedChapter.value, translation.value);
      },
      <Object?>[selectedBook.value, selectedChapter.value, translation.value],
    );
    final passageSnapshot = useFuture(passageFuture);

    final verses = passageSnapshot.data ?? <Verse>[];
    final isLoading = booksSnapshot.connectionState != ConnectionState.done ||
        chapterCountSnapshot.connectionState != ConnectionState.done ||
        passageSnapshot.connectionState != ConnectionState.done;

    return Scaffold(
      appBar: AppBar(title: const Text('Bible Reader')),
      body: Column(
        children: <Widget>[
          if (isLoading) const LinearProgressIndicator(minHeight: 2),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _TranslationSelector(
                  translation: translation.value,
                  onChanged: (value) {
                    translation.value = value;
                    selectedBook.value = null;
                    selectedChapter.value = 1;
                  },
                ),
                const SizedBox(height: 12),
                _BookSelector(
                  snapshot: booksSnapshot,
                  value: selectedBook.value,
                  onChanged: (value) {
                    selectedBook.value = value;
                    selectedChapter.value = 1;
                  },
                ),
                const SizedBox(height: 12),
                _ChapterSelector(
                  snapshot: chapterCountSnapshot,
                  value: selectedChapter.value,
                  onChanged: (value) => selectedChapter.value = value,
                  onPrevious: () {
                    if (selectedChapter.value > 1) {
                      selectedChapter.value = selectedChapter.value - 1;
                    }
                  },
                  onNext: () {
                    final count = chapterCountSnapshot.data;
                    if (count != null && selectedChapter.value < count) {
                      selectedChapter.value = selectedChapter.value + 1;
                    }
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Builder(
              builder: (BuildContext context) {
                if (booksSnapshot.hasError) {
                  return _ErrorView(message: 'Unable to load books: ${booksSnapshot.error}');
                }
                if (chapterCountSnapshot.hasError) {
                  return _ErrorView(
                    message: 'Unable to load chapters for ${selectedBook.value}: ${chapterCountSnapshot.error}',
                  );
                }
                if (passageSnapshot.hasError) {
                  return _ErrorView(message: 'Unable to load passage: ${passageSnapshot.error}');
                }
                if (verses.isEmpty) {
                  return const Center(child: Text('Select a book and chapter to begin reading.'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (BuildContext context, int index) {
                    final verse = verses[index];
                    return _VerseCard(verse: verse);
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: verses.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TranslationSelector extends StatelessWidget {
  const _TranslationSelector({required this.translation, required this.onChanged});

  final Translation translation;
  final ValueChanged<Translation> onChanged;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(labelText: 'Translation', border: OutlineInputBorder()),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Translation>(
          value: translation,
          isExpanded: true,
          items: Translation.values
              .map(
                (translation) => DropdownMenuItem<Translation>(
                  value: translation,
                  child: Text(_translationLabel(translation)),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ),
    );
  }
}

class _BookSelector extends StatelessWidget {
  const _BookSelector({required this.snapshot, required this.value, required this.onChanged});

  final AsyncSnapshot<List<String>> snapshot;
  final String? value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasError) {
      return _ErrorField(message: 'Could not load books.');
    }
    if (snapshot.connectionState != ConnectionState.done) {
      return const _LoadingField(label: 'Book');
    }

    final books = snapshot.data ?? <String>[];
    if (books.isEmpty) {
      return const _ErrorField(message: 'No books available in this translation.');
    }

    return InputDecorator(
      decoration: const InputDecoration(labelText: 'Book', border: OutlineInputBorder()),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value ?? books.first,
          isExpanded: true,
          items: books
              .map(
                (book) => DropdownMenuItem<String>(
                  value: book,
                  child: Text(book),
                ),
              )
              .toList(),
          onChanged: (selected) {
            if (selected != null) {
              onChanged(selected);
            }
          },
        ),
      ),
    );
  }
}

class _ChapterSelector extends StatelessWidget {
  const _ChapterSelector({
    required this.snapshot,
    required this.value,
    required this.onChanged,
    required this.onPrevious,
    required this.onNext,
  });

  final AsyncSnapshot<int> snapshot;
  final int value;
  final ValueChanged<int> onChanged;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasError) {
      return _ErrorField(message: 'Could not load chapters.');
    }
    if (snapshot.connectionState != ConnectionState.done) {
      return const _LoadingField(label: 'Chapter');
    }

    final count = snapshot.data ?? 0;
    if (count == 0) {
      return const _ErrorField(message: 'No chapters available for this book.');
    }

    final chapters = List<int>.generate(count, (index) => index + 1);

    return Row(
      children: <Widget>[
        Expanded(
          child: InputDecorator(
            decoration: const InputDecoration(labelText: 'Chapter', border: OutlineInputBorder()),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: value.clamp(1, count),
                isExpanded: true,
                items: chapters
                    .map(
                      (chapter) => DropdownMenuItem<int>(
                        value: chapter,
                        child: Text(chapter.toString()),
                      ),
                    )
                    .toList(),
                onChanged: (selected) {
                  if (selected != null) {
                    onChanged(selected);
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        IconButton.filledTonal(
          icon: const Icon(Icons.chevron_left),
          onPressed: value > 1 ? onPrevious : null,
          tooltip: 'Previous chapter',
        ),
        const SizedBox(width: 8),
        IconButton.filledTonal(
          icon: const Icon(Icons.chevron_right),
          onPressed: value < count ? onNext : null,
          tooltip: 'Next chapter',
        ),
      ],
    );
  }
}

class _VerseCard extends StatelessWidget {
  const _VerseCard({required this.verse});

  final Verse verse;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    '${verse.book} ${verse.chapter}:${verse.verse}',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copy verse',
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: '${verse.book} ${verse.chapter}:${verse.verse} — ${verse.text}'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Copied ${verse.book} ${verse.chapter}:${verse.verse}'),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            SelectableText(
              verse.text,
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}

class _ErrorField extends StatelessWidget {
  const _ErrorField({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(border: OutlineInputBorder()),
      child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

class _LoadingField extends StatelessWidget {
  const _LoadingField({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      child: const SizedBox(
        height: 40,
        child: Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
        ),
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
