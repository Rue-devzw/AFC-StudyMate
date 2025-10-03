class BibleTranslation {
  final String id;
  final String name;
  final String language;
  final String languageName;
  final String version;
  final String? source;
  final String copyright;
  final DateTime installedAt;

  const BibleTranslation({
    required this.id,
    required this.name,
    required this.language,
    required this.languageName,
    required this.version,
    required this.installedAt,
    required this.copyright,
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

class BibleSearchResult {
  final BibleVerse verse;
  final String snippet;
  final double rank;

  const BibleSearchResult({
    required this.verse,
    required this.snippet,
    required this.rank,
  });
}
