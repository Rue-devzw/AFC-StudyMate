class ReadingPosition {
  const ReadingPosition({
    required this.translationId,
    required this.bookId,
    required this.chapter,
    required this.verse,
    required this.updatedAt,
  });

  final String translationId;
  final int bookId;
  final int chapter;
  final int verse;
  final DateTime updatedAt;
}
