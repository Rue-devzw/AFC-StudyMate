import 'package:flutter/material.dart';

import '../../data/models/bible_ref.dart';
import '../../widgets/verse_card.dart';

class DaybreakScreen extends StatelessWidget {
  const DaybreakScreen({required this.date, super.key});

  static const String routeName = 'daybreak';

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final ref = BibleRef(book: 'Psalms', chapter: date.day, verseStart: 1, verseEnd: 6);
    return Scaffold(
      appBar: AppBar(title: Text('Daybreak ${date.day}/${date.month}')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          VerseCard(ref: ref, translationLabel: 'KJV · Shona'),
          const SizedBox(height: 24),
          Text(
            'Take a quiet moment to read, reflect, and pray. The Lord meets us as we pause.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
