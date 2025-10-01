import 'dart:convert';

class Bible {
  final String id;
  final String translation;
  final List<Book> books;

  Bible({required this.id, required this.translation, required this.books});

  factory Bible.fromJson(Map<String, dynamic> json) {
    return Bible(
      id: json['id'],
      translation: json['name'] ?? json['abbreviation'] ?? '',
      books: json.containsKey('books') && json['books'] != null
          ? (json['books'] as List).map((b) => Book.fromJson(b)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': translation,
        'books': books.map((b) => b.toJson()).toList(),
      };
}

class Book {
  final String id;
  final String name;
  final List<Chapter> chapters;

  Book({required this.id, required this.name, required this.chapters});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      name: json['name'],
      chapters: json.containsKey('chapters') && json['chapters'] != null
          ? (json['chapters'] as List).map((c) => Chapter.fromJson(c)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'chapters': chapters.map((c) => c.toJson()).toList(),
      };
}

class Chapter {
  final String id;
  final String number;
  final List<Verse> verses;

  Chapter({required this.id, required this.number, required this.verses});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    var verses = <Verse>[];
    if (json.containsKey('content')) {
      dynamic content = json['content'];
      if (content is String) {
        try {
          content = jsonDecode(content);
        } catch (e) {
          content = [];
        }
      }

      if (content is List) {
        for (var item in content) {
          if (item['type'] == 'para') {
            for (var innerItem in item['items']) {
              if (innerItem['type'] == 'verse') {
                verses.add(Verse.fromJson(innerItem));
              }
            }
          }
        }
      }
    } else if (json.containsKey('verses')) {
      verses = (json['verses'] as List).map((v) => Verse.fromJson(v)).toList();
    }

    return Chapter(
      id: json['id'],
      number: json['number'] ?? (json['reference'] ?? '').split(' ').last,
      verses: verses,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'number': number,
        'verses': verses.map((v) => v.toJson()).toList(),
      };
}

class Verse {
  final String id;
  final String number;
  final String text;

  Verse({required this.id, required this.number, required this.text});

  factory Verse.fromJson(Map<String, dynamic> json) {
    String textContent = '';
    String verseNumber = '';

    if (json.containsKey('items')) {
      final items = json['items'] as List;
      if (items.isNotEmpty) {
        final firstItem = items.first;
        if (firstItem['type'] == 'text') {
          verseNumber = firstItem['text'].trim();
        }

        for (var i = 1; i < items.length; i++) {
          final item = items[i];
          if (item['type'] == 'text') {
            textContent += item['text'];
          }
        }
      }
    } else if (json.containsKey('text')) {
      textContent = json['text'];
    }

    return Verse(
      id: json['id'],
      number: verseNumber,
      text: textContent.trim(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'number': number,
        'text': text,
      };
}
