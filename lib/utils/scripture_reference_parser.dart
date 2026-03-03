import 'package:afc_studymate/data/models/bible_ref.dart';
import 'package:afc_studymate/widgets/linked_verse.dart';
import 'package:flutter/material.dart';

class ScriptureReferenceMatch {
  const ScriptureReferenceMatch({
    required this.reference,
    required this.start,
    required this.end,
    required this.rawText,
    required this.displayText,
  });

  final BibleRef reference;
  final int start;
  final int end;
  final String rawText;
  final String displayText;
}

class ScriptureReferenceParser {
  static const List<String> _canonicalBooks = <String>[
    'Genesis',
    'Exodus',
    'Leviticus',
    'Numbers',
    'Deuteronomy',
    'Joshua',
    'Judges',
    'Ruth',
    '1 Samuel',
    '2 Samuel',
    '1 Kings',
    '2 Kings',
    '1 Chronicles',
    '2 Chronicles',
    'Ezra',
    'Nehemiah',
    'Esther',
    'Job',
    'Psalms',
    'Proverbs',
    'Ecclesiastes',
    'Song of Solomon',
    'Isaiah',
    'Jeremiah',
    'Lamentations',
    'Ezekiel',
    'Daniel',
    'Hosea',
    'Joel',
    'Amos',
    'Obadiah',
    'Jonah',
    'Micah',
    'Nahum',
    'Habakkuk',
    'Zephaniah',
    'Haggai',
    'Zechariah',
    'Malachi',
    'Matthew',
    'Mark',
    'Luke',
    'John',
    'Acts',
    'Romans',
    '1 Corinthians',
    '2 Corinthians',
    'Galatians',
    'Ephesians',
    'Philippians',
    'Colossians',
    '1 Thessalonians',
    '2 Thessalonians',
    '1 Timothy',
    '2 Timothy',
    'Titus',
    'Philemon',
    'Hebrews',
    'James',
    '1 Peter',
    '2 Peter',
    '1 John',
    '2 John',
    '3 John',
    'Jude',
    'Revelation',
  ];

  static final Map<String, String> _canonicalLookup = <String, String>{
    for (final book in _canonicalBooks) book.toLowerCase(): book,
  };

  static final Map<String, int> _romanLookup = <String, int>{
    'I': 1,
    'II': 2,
    'III': 3,
  };

  static final Map<String, String> _bookAliases = <String, String>{
    'psalm': 'Psalms',
    'psalms': 'Psalms',
    'ps': 'Psalms',
    'pss': 'Psalms',
    'song of songs': 'Song of Solomon',
    'canticles': 'Song of Solomon',
    'song of solomon': 'Song of Solomon',
    'solomon': 'Song of Solomon',
    'thessalonians': 'Thessalonians',
    'corinthians': 'Corinthians',
    'timothy': 'Timothy',
    'peter': 'Peter',
    'john': 'John',
    'kings': 'Kings',
    'chronicles': 'Chronicles',
    'samuel': 'Samuel',
  };

  static final RegExp _bookPattern = RegExp(
    r'((?:[1-3]|I{1,3})\s+)?[A-Za-z]+(?:\s+[A-Za-z]+)*\s+\d+(?::\d+(?:[-–]\d+)?(?:,\s?\d+(?:[-–]\d+)?)*)?',
  );

  static final RegExp _fallbackPattern = RegExp(
    r'(?<=;|\(|,)\s*\d+(?::\d+(?:[-–]\d+)?(?:,\s?\d+(?:[-–]\d+)?)*)?',
  );

  static List<ScriptureReferenceMatch> findInText(String text) {
    final matches = <ScriptureReferenceMatch>[];
    final bookMatches = _bookPattern.allMatches(text).toList();
    String? currentBook;

    for (var i = 0; i < bookMatches.length; i++) {
      final match = bookMatches[i];
      final raw = text.substring(match.start, match.end);
      final parsed = _parseReference(raw);
      if (parsed != null) {
        matches.add(
          ScriptureReferenceMatch(
            reference: parsed.reference,
            start: match.start,
            end: match.end,
            rawText: raw,
            displayText: raw.trim(),
          ),
        );
        currentBook = parsed.book;
      }

      final segmentStart = match.end;
      final segmentEnd = i + 1 < bookMatches.length ? bookMatches[i + 1].start : text.length;
      if (currentBook != null && segmentStart < segmentEnd) {
        final segment = text.substring(segmentStart, segmentEnd);
        for (final fallbackMatch in _fallbackPattern.allMatches(segment)) {
          final rawFallback = fallbackMatch.group(0)!;
          final trimmedLeft = rawFallback.trimLeft();
          final leadingWhitespace = rawFallback.length - trimmedLeft.length;
          final start = segmentStart + fallbackMatch.start + leadingWhitespace;
          final trimmed = trimmedLeft.trimRight();
          final end = start + trimmed.length;
          final parsedFallback = _parseReference('$currentBook $trimmed');
          if (parsedFallback != null) {
            matches.add(
              ScriptureReferenceMatch(
                reference: parsedFallback.reference,
                start: start,
                end: end,
                rawText: text.substring(start, end),
                displayText: trimmed,
              ),
            );
          }
        }
      }
    }

    matches.sort((a, b) => a.start.compareTo(b.start));
    return matches;
  }

  static List<BibleRef> parseReferenceList(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return <BibleRef>[];
    }

    final result = <BibleRef>[];
    String? currentBook;
    final segments = raw.split(RegExp(r'[;\n]+'));
    for (final segment in segments) {
      final trimmed = segment.trim();
      if (trimmed.isEmpty) {
        continue;
      }
      final parsed = _parseReference(trimmed, fallbackBook: currentBook);
      if (parsed != null) {
        result.add(parsed.reference);
        currentBook = parsed.book;
      }
    }
    return result;
  }

  static List<InlineSpan> buildLinkedTextSpans(BuildContext context, String text, TextStyle? style) {
    final matches = findInText(text);
    if (matches.isEmpty) {
      return <InlineSpan>[TextSpan(text: text, style: style)];
    }

    final spans = <InlineSpan>[];
    var cursor = 0;
    for (final match in matches) {
      if (match.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, match.start), style: style));
      }
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: LinkedVerse(
            reference: match.reference,
            label: match.displayText,
            style: style,
          ),
        ),
      );
      cursor = match.end;
    }
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor), style: style));
    }
    return spans;
  }

  static _ParsedReference? _parseReference(String raw, {String? fallbackBook}) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final cleaned = trimmed.replaceAll(RegExp('[“”]'), '"').replaceAll('—', '-');
    final firstDigitMatch = RegExp(r'\d').firstMatch(cleaned);
    if (firstDigitMatch == null) {
      return null;
    }
    final firstDigitIndex = firstDigitMatch.start;

    var bookPart = cleaned.substring(0, firstDigitIndex).trim();
    var referencePart = cleaned.substring(firstDigitIndex).trim();

    if (bookPart.isEmpty) {
      if (fallbackBook == null) {
        return null;
      }
      bookPart = fallbackBook;
    }

    final normalizedBook = _normalizeBookName(bookPart);
    if (normalizedBook == null) {
      return null;
    }

    referencePart = referencePart.replaceAll(RegExp(r'[).,;:!?]+$'), '');
    final chapterMatch = RegExp(r'^\d+').firstMatch(referencePart);
    if (chapterMatch == null) {
      return null;
    }
    final chapter = int.parse(chapterMatch.group(0)!);

    int? verseStart;
    int? verseEnd;
    final remainder = referencePart.substring(chapterMatch.end);
    if (remainder.startsWith(':')) {
      final verseNumbers = RegExp(r'\d+').allMatches(remainder.substring(1)).map((match) => int.parse(match.group(0)!)).toList();
      if (verseNumbers.isNotEmpty) {
        verseStart = verseNumbers.first;
        if (verseNumbers.length > 1) {
          verseEnd = verseNumbers.last;
        }
      }
    }

    return _ParsedReference(
      book: normalizedBook,
      reference: BibleRef(book: normalizedBook, chapter: chapter, verseStart: verseStart, verseEnd: verseEnd),
    );
  }

  static String? _normalizeBookName(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final lower = trimmed.toLowerCase();
    if (_canonicalLookup.containsKey(lower)) {
      return _canonicalLookup[lower];
    }
    if (_bookAliases.containsKey(lower)) {
      final alias = _bookAliases[lower]!;
      final canonical = _canonicalLookup[alias.toLowerCase()];
      if (canonical != null) {
        return canonical;
      }
    }

    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.isEmpty) {
      return null;
    }

    int? prefix;
    final first = parts.first;
    if (RegExp(r'^[1-3]$').hasMatch(first)) {
      prefix = int.tryParse(first);
      parts.removeAt(0);
    } else {
      final roman = _romanLookup[first.toUpperCase()];
      if (roman != null) {
        prefix = roman;
        parts.removeAt(0);
      }
    }

    final base = parts.join(' ');
    if (base.isEmpty) {
      return null;
    }
    final baseLower = base.toLowerCase();
    var canonicalBase = _canonicalLookup[baseLower];
    canonicalBase ??= _bookAliases[baseLower];
    if (canonicalBase != null) {
      canonicalBase = _canonicalLookup[canonicalBase.toLowerCase()] ?? canonicalBase;
    }

    if (canonicalBase == null) {
      return null;
    }

    if (prefix != null) {
      final candidate = '$prefix $canonicalBase';
      final canonical = _canonicalLookup[candidate.toLowerCase()];
      if (canonical != null) {
        return canonical;
      }
      return candidate;
    }

    return canonicalBase;
  }
}

class _ParsedReference {
  const _ParsedReference({required this.book, required this.reference});

  final String book;
  final BibleRef reference;
}
