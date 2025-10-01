class Bible {
  final String translation;
  final List<Book> books;

  Bible({required this.translation, required this.books});
}

class Book {
  final String name;
  final List<Chapter> chapters;

  Book({required this.name, required this.chapters});
}

class Chapter {
  final int number;
  final List<Verse> verses;

  Chapter({required this.number, required this.verses});
}

class Verse {
  final int number;
  final String text;

  Verse({required this.number, required this.text});
}
