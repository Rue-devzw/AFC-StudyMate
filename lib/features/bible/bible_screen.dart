import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/bible_ref.dart';
import '../../data/models/enums.dart';
import '../../data/models/verse.dart';
import '../../data/services/bible_service.dart';

class BibleScreen extends HookConsumerWidget {
  const BibleScreen({super.key});

  static const String routeName = 'bible';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passageAsync = ref.watch(_parallelPassageProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Parallel Bible')),
      body: passageAsync.when(
        data: (verses) => _ParallelView(verses: verses),
        error: (error, stackTrace) => Center(child: Text('Unable to open Bible: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

final _parallelPassageProvider = FutureProvider<List<Verse>>((ref) {
  final service = ref.read(bibleServiceProvider);
  const refRange = BibleRef(book: 'John', chapter: 3, verseStart: 16, verseEnd: 17);
  return service.getPassage(refRange, Translation.kjv);
});

class _ParallelView extends StatelessWidget {
  const _ParallelView({required this.verses});

  final List<Verse> verses;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemBuilder: (BuildContext context, int index) {
        final verse = verses[index];
        return ListTile(
          title: Text('${verse.book} ${verse.chapter}:${verse.verse}'),
          subtitle: Text(verse.text),
          trailing: IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Copied ${verse.book} ${verse.chapter}:${verse.verse} to clipboard.')),
              );
            },
          ),
        );
      },
      separatorBuilder: (_, __) => const Divider(),
      itemCount: verses.length,
    );
  }
}
