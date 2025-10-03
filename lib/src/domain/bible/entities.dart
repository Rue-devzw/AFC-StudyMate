class BibleTranslation {
  final String id;
  final String name;
  final String language;
  final String version;
  final String? source;
  final DateTime installedAt;

  const BibleTranslation({
    required this.id,
    required this.name,
    required this.language,
    required this.version,
    required this.installedAt,
    this.source,
  });
}

class BibleBook {
  final int id;
  final String name;
  final int chapterCount;

  const BibleBook({
    required this.id,
    required this.name,
    required this.chapterCount,
  });
}

class BibleVerse {
  final String translationId;
  final int bookId;
  final int chapter;
  final int verse;
  final String text;

  const BibleVerse({
    required this.translationId,
    required this.bookId,
    required this.chapter,
    required this.verse,
    required this.text,
  });
}
