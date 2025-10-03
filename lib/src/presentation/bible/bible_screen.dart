import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/bible/entities.dart';
import '../providers.dart';
import 'book_screen.dart';

class BibleScreen extends ConsumerWidget {
  const BibleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translationsAsync = ref.watch(translationsProvider);
    final booksAsync = ref.watch(booksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bible'),
      ),
      body: Column(
        children: [
          translationsAsync.when(
            data: (translations) {
              final selectedId = ref.watch(selectedTranslationIdProvider);
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButtonFormField<String>(
                  value: selectedId,
                  items: [
                    for (final translation in translations)
                      DropdownMenuItem(
                        value: translation.id,
                        child: Text('${translation.name} (${translation.language.toUpperCase()})'),
                      ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(selectedTranslationIdProvider.notifier).state = value;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Translation',
                    border: OutlineInputBorder(),
                  ),
                ),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(16.0),
              child: LinearProgressIndicator(),
            ),
            error: (error, stack) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Failed to load translations: $error'),
            ),
          ),
          Expanded(
            child: booksAsync.when(
              data: (books) => ListView.separated(
                itemCount: books.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final book = books[index];
                  return ListTile(
                    title: Text(book.name),
                    subtitle: Text('${book.chapterCount} chapters'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookScreen(book: book),
                        ),
                      );
                    },
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Failed to load books: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
