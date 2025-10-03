import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/bible/entities.dart';
import '../providers.dart';
import 'book_screen.dart';
import 'search_screen.dart';

class BibleScreen extends ConsumerWidget {
  const BibleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translationsAsync = ref.watch(translationsProvider);
    final booksAsync = ref.watch(booksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bible'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BibleSearchScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          translationsAsync.when(
            data: (translations) {
              final selectedIds = ref.watch(selectedTranslationIdsProvider);
              final notifier = ref.read(selectedTranslationIdsProvider.notifier);
              final availableIds = translations.map((t) => t.id).toSet();
              if (selectedIds.isEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  notifier.setAll([translations.first.id]);
                });
              } else if (selectedIds.any((id) => !availableIds.contains(id))) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  notifier.setAll(selectedIds.where(availableIds.contains));
                });
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Translations',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final translation in translations)
                          FilterChip(
                            selected: selectedIds.contains(translation.id),
                            onSelected: (value) {
                              notifier.toggle(translation.id);
                            },
                            label: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
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
                    ),
                    const SizedBox(height: 12),
                    if (selectedIds.isNotEmpty)
                      DropdownButtonFormField<String>(
                        value: selectedIds.first,
                        items: [
                          for (final id in selectedIds)
                            DropdownMenuItem(
                              value: id,
                              child: Text(
                                translations
                                    .firstWhere((element) => element.id == id)
                                    .name,
                              ),
                            ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            notifier.setPrimary(value);
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'Primary column',
                          border: OutlineInputBorder(),
                        ),
                      ),
                  ],
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
