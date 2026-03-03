import 'package:afc_studymate/utils/scripture_reference_parser.dart';

void main() {
  const text = "Let's read 1 Corinthians 13:4-8 and 3 John 1:2.";
  final matches = ScriptureReferenceParser.findInText(text);
  for (final match in matches) {
    print(
      'Found: ${match.displayText} -> Book: ${match.reference.book}, Chapter: ${match.reference.chapter}, Verse Start: ${match.reference.verseStart}',
    );
  }
}
