class Verse {
  const Verse(this.book, this.chapter, this.verse, this.text);

  final String book;
  final int chapter;
  final int verse;
  final String text;
}

class VerseSearchHit {
  const VerseSearchHit({
    required this.reference,
    required this.preview,
  });

  final String reference;
  final String preview;
}
