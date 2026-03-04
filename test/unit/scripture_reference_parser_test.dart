import 'package:afc_studymate/utils/scripture_reference_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScriptureReferenceParser numbered books', () {
    test('findInText parses numeric-prefixed book names', () {
      const text =
          'Read 1 Samuel 3:10, 2 Kings 4:1-7, 1 Thessalonians 5:16-18, and 3 John 1:4.';
      final matches = ScriptureReferenceParser.findInText(text);

      expect(matches.length, 4);
      expect(matches[0].reference.book, '1 Samuel');
      expect(matches[0].reference.chapter, 3);
      expect(matches[0].reference.verseStart, 10);

      expect(matches[1].reference.book, '2 Kings');
      expect(matches[1].reference.chapter, 4);
      expect(matches[1].reference.verseStart, 1);
      expect(matches[1].reference.verseEnd, 7);

      expect(matches[2].reference.book, '1 Thessalonians');
      expect(matches[2].reference.chapter, 5);
      expect(matches[2].reference.verseStart, 16);
      expect(matches[2].reference.verseEnd, 18);

      expect(matches[3].reference.book, '3 John');
      expect(matches[3].reference.chapter, 1);
      expect(matches[3].reference.verseStart, 4);
    });

    test('parseReferenceList preserves numeric book prefixes', () {
      final refs = ScriptureReferenceParser.parseReferenceList(
        '1 Samuel 2:1; 2 Kings 6:17; 1 Thessalonians 4:13-14',
      );

      expect(refs.length, 3);
      expect(refs[0].book, '1 Samuel');
      expect(refs[1].book, '2 Kings');
      expect(refs[2].book, '1 Thessalonians');
      expect(refs[2].chapter, 4);
      expect(refs[2].verseStart, 13);
      expect(refs[2].verseEnd, 14);
    });
  });
}
