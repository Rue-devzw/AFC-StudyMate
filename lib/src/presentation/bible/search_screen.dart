import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/bible/book_names.dart';
import '../../domain/bible/entities.dart';
import '../providers.dart';

class BibleSearchScreen extends ConsumerStatefulWidget {
  const BibleSearchScreen({super.key});

  @override
  ConsumerState<BibleSearchScreen> createState() => _BibleSearchScreenState();
}

class _BibleSearchScreenState extends ConsumerState<BibleSearchScreen> {
  late final TextEditingController _controller;
  late String _translationId;
  int? _selectedBookId;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _translationId = ref.read(selectedTranslationIdProvider);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translationsAsync = ref.watch(translationsProvider);
    final booksAsync = ref.watch(booksForTranslationProvider(_translationId));

    final bool hasQuery = _query.trim().isNotEmpty;
    final resultsAsync = hasQuery
        ? ref.watch(
            verseSearchResultsProvider(
              VerseSearchRequest(
                translationId: _translationId,
                query: _query,
                bookId: _selectedBookId,
                limit: 50,
              ),
            ),
          )
        : const AsyncValue<List<BibleSearchResult>>.data([]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Bible'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              translationsAsync.when(
                data: (translations) {
                  if (translations.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  if (!translations.any((t) => t.id == _translationId)) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted) return;
                      setState(() {
                        _translationId = translations.first.id;
                        _selectedBookId = null;
                      });
                    });
                  }
                  return DropdownButtonFormField<String>(
                    value: _translationId,
                    decoration: const InputDecoration(
                      labelText: 'Translation',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      for (final translation in translations)
                        DropdownMenuItem(
                          value: translation.id,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(translation.name),
                              Text(
                                '${translation.languageName} · ${translation.language.toUpperCase()}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _translationId = value;
                          _selectedBookId = null;
                        });
                      }
                    },
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: LinearProgressIndicator(),
                ),
                error: (error, stackTrace) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Failed to load translations: $error'),
                ),
              ),
              const SizedBox(height: 12),
              booksAsync.when(
                data: (books) {
                  if (books.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return DropdownButtonFormField<int?>(
                    value: _selectedBookId,
                    decoration: const InputDecoration(
                      labelText: 'Book filter',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('All books'),
                      ),
                      for (final book in books)
                        DropdownMenuItem<int?>(
                          value: book.id,
                          child: Text(book.name),
                        ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedBookId = value;
                      });
                    },
                  );
                },
                loading: () => const SizedBox(
                  height: 4,
                  child: LinearProgressIndicator(),
                ),
                error: (error, stackTrace) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Failed to load books: $error'),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                onChanged: (value) {
                  setState(() {
                    _query = value;
                  });
                },
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  labelText: 'Search verses',
                  hintText: 'Enter keywords or phrases',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _controller.clear();
                              _query = '';
                            });
                          },
                        ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: hasQuery
                    ? resultsAsync.when(
                        data: (results) {
                          if (results.isEmpty) {
                            return const Center(
                              child: Text('No verses matched your search.'),
                            );
                          }
                          return ListView.separated(
                            itemCount: results.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final result = results[index];
                              return _VerseSearchTile(result: result);
                            },
                          );
                        },
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        error: (error, stackTrace) => Center(
                          child: Text('Search failed: $error'),
                        ),
                      )
                    : const Center(
                        child: Text('Start typing to search across the Bible.'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerseSearchTile extends StatelessWidget {
  const _VerseSearchTile({required this.result});

  final BibleSearchResult result;

  @override
  Widget build(BuildContext context) {
    final reference =
        '${bibleBookNameForId(result.verse.bookId)} ${result.verse.chapter}:${result.verse.verse}';
    final snippetSpan = _buildSnippetSpan(context, result.snippet);

    return ListTile(
      title: Text(reference),
      subtitle: Text.rich(snippetSpan),
      trailing: Text(
        result.verse.translationId.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }

  TextSpan _buildSnippetSpan(BuildContext context, String snippet) {
    final normalStyle = Theme.of(context).textTheme.bodyMedium;
    final highlightStyle =
        normalStyle?.copyWith(fontWeight: FontWeight.bold) ?? const TextStyle(fontWeight: FontWeight.bold);
    final sanitized = snippet.replaceAll('&quot;', '"');
    final spans = <TextSpan>[];
    final regex = RegExp(r'<b>(.*?)</b>');
    var lastIndex = 0;

    for (final match in regex.allMatches(sanitized)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(text: sanitized.substring(lastIndex, match.start), style: normalStyle));
      }
      final highlighted = match.group(1) ?? '';
      spans.add(TextSpan(text: highlighted, style: highlightStyle));
      lastIndex = match.end;
    }

    if (lastIndex < sanitized.length) {
      spans.add(TextSpan(text: sanitized.substring(lastIndex), style: normalStyle));
    }

    if (spans.isEmpty) {
      spans.add(TextSpan(text: sanitized, style: normalStyle));
    }

    return TextSpan(children: spans);
  }
}
