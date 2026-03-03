import 'package:meta/meta.dart';


@immutable
class BibleRef {
  const BibleRef({
    required this.book,
    required this.chapter,
    this.verseStart,
    this.verseEnd,
  });

  factory BibleRef.fromJson(Map<String, dynamic> json) {
    return BibleRef(
      book: json['book'] as String,
      chapter: json['chapter'] as int,
      verseStart: json['verseStart'] as int?,
      verseEnd: json['verseEnd'] as int?,
    );
  }

  final String book;
  final int chapter;
  final int? verseStart;
  final int? verseEnd;

  BibleRef copyWith({
    String? book,
    int? chapter,
    int? verseStart,
    int? verseEnd,
  }) {
    return BibleRef(
      book: book ?? this.book,
      chapter: chapter ?? this.chapter,
      verseStart: verseStart ?? this.verseStart,
      verseEnd: verseEnd ?? this.verseEnd,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'book': book,
        'chapter': chapter,
        'verseStart': verseStart,
        'verseEnd': verseEnd,
      };

  String get displayText {
    final buffer = StringBuffer('$book $chapter');

    if (verseStart != null) {
      buffer.write(':${verseStart!}');

      final end = verseEnd;
      if (end != null && end != verseStart) {
        buffer.write('-$end');
      }
    }

    return buffer.toString();
  }

  @override
  int get hashCode => Object.hash(book, chapter, verseStart, verseEnd);

  @override
  bool operator ==(Object other) {
    return other is BibleRef &&
        other.book == book &&
        other.chapter == chapter &&
        other.verseStart == verseStart &&
        other.verseEnd == verseEnd;
  }

  @override
  String toString() => 'BibleRef($book $chapter:$verseStart-$verseEnd)';
}
