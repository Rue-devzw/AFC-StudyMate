import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/bible_ref.dart';
import '../models/enums.dart';
import '../models/verse.dart';

final bibleServiceProvider = Provider<BibleService>((ref) {
  return BibleService();
});

class BibleService {
  Future<List<Verse>> getPassage(BibleRef ref, Translation translation) async {
    final dbPath = translation == Translation.kjv ? 'assets/db/kjv.db' : 'assets/db/shona_bible.db';
    // In this scaffold implementation we simply return a placeholder verse to
    // demonstrate offline capability without requiring platform-specific
    // SQLite bindings during bootstrapping. The bundled databases are still
    // shipped with the application and can be queried once native builds are
    // configured.
    return <Verse>[
      Verse(ref.book, ref.chapter, ref.verseStart ?? 1,
          'For God so loved the world, that he gave his only begotten Son.'),
      if ((ref.verseEnd ?? ref.verseStart ?? 1) > (ref.verseStart ?? 1))
        Verse(ref.book, ref.chapter, (ref.verseStart ?? 1) + 1,
            'That whosoever believeth in him should not perish, but have everlasting life.'),
    ];
  }

  Future<List<VerseSearchHit>> search(String query, Translation translation) async {
    // This stub returns a single mock result for offline demonstration.
    return <VerseSearchHit>[
      VerseSearchHit(reference: 'John 3:16', preview: 'For God so loved the world...'),
    ];
  }
}
