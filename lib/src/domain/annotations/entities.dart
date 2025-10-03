class VerseLocation {
  const VerseLocation({
    required this.translationId,
    required this.bookId,
    required this.chapter,
    required this.verse,
  });

  final String translationId;
  final int bookId;
  final int chapter;
  final int verse;
}

class Bookmark {
  const Bookmark({
    required this.id,
    required this.location,
    required this.createdAt,
  });

  final String id;
  final VerseLocation location;
  final DateTime createdAt;
}

class Highlight {
  const Highlight({
    required this.id,
    required this.location,
    required this.colour,
    required this.createdAt,
  });

  final String id;
  final VerseLocation location;
  final String colour;
  final DateTime createdAt;
}

class NoteHistoryEntry {
  const NoteHistoryEntry({
    required this.version,
    required this.text,
    required this.updatedAt,
  });

  final int version;
  final String text;
  final DateTime updatedAt;
}

class Note {
  const Note({
    required this.id,
    required this.location,
    required this.text,
    required this.version,
    required this.updatedAt,
    this.history = const [],
  });

  final String id;
  final VerseLocation location;
  final String text;
  final int version;
  final DateTime updatedAt;
  final List<NoteHistoryEntry> history;

  bool get canUndo => history.length > 1;

  NoteHistoryEntry? get previousVersion {
    if (history.length < 2) {
      return null;
    }
    return history[1];
  }
}
