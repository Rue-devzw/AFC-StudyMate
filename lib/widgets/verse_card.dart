import 'package:flutter/material.dart';

import '../data/models/bible_ref.dart';

class VerseCard extends StatelessWidget {
  const VerseCard({required this.ref, required this.translationLabel, super.key});

  final BibleRef ref;
  final String translationLabel;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${ref.book} ${ref.chapter}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              translationLabel,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 12),
            const Text(
              'Verse text displayed here.',
              textScaler: TextScaler.linear(1.1),
            ),
          ],
        ),
      ),
    );
  }
}
