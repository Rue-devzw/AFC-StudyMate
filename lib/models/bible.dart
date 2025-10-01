class Bible {
  final String id;
  final String name;

  Bible({required this.id, required this.name});

  factory Bible.fromMap(Map<String, dynamic> map) {
    return Bible(
      id: map['id'].toString(),
      name: map['translation'] as String,
    );
  }
}

class Book {
  final int id;
  final String name;
  final int chapterCount;

  Book({required this.id, required this.name, required this.chapterCount});

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['book'] as int,
      name: map['book_name_text'] as String,
      chapterCount: map['chapterCount'] as int,
    );
  }
}

class Verse {
  final int id;
  final int book;
  final String bookName;
  final int chapter;
  final int verse;
  final String text;
  final int translationId;
  final int languageId;

  Verse({
    required this.id,
    required this.book,
    required this.bookName,
    required this.chapter,
    required this.verse,
    required this.text,
    required this.translationId,
    required this.languageId,
  });

  factory Verse.fromMap(Map<String, dynamic> map) {
    return Verse(
      id: map['id'] as int,
      book: map['book'] as int,
      bookName: map['book_name_text'] as String,
      chapter: map['chapter'] as int,
      verse: map['verse'] as int,
      text: map['text'] as String,
      translationId: map['translation_id'] as int,
      languageId: map['language_id'] as int,
    );
  }
}
