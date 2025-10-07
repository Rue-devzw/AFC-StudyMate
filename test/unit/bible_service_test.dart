import 'package:flutter_test/flutter_test.dart';

import 'package:afc_studymate/data/models/bible_ref.dart';
import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/services/bible_service.dart';

void main() {
  test('loads a passage from bundled bible', () async {
    final service = BibleService();
    final verses = await service.getPassage(
      const BibleRef(book: 'John', chapter: 3, verseStart: 16, verseEnd: 16),
      Translation.kjv,
    );
    expect(verses, isNotEmpty);
  });
}
