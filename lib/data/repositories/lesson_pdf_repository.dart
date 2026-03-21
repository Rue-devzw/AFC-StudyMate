import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/lesson.dart';
import 'package:afc_studymate/data/repositories/discovery_pdf_mappings.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';

final lessonPdfRepositoryProvider = Provider<LessonPdfRepository>((ref) {
  return const LessonPdfRepository();
});

@immutable
class LessonPdfDocument {
  const LessonPdfDocument({
    required this.path,
    required this.title,
    this.initialPage,
  });

  final String path;
  final String title;
  final int? initialPage;
}

class LessonPdfRepository {
  const LessonPdfRepository();

  static const Set<int> _primaryFiveLessonUnits = {
    1,
    4,
    7,
    10,
    15,
    18,
    21,
    24,
    27,
    29,
    33,
    36,
  };

  static const List<int> _primaryTeacherPagesForFourLessons = [3, 7, 11, 15];
  static const List<int> _primaryTeacherPagesForFiveLessons = [
    4,
    7,
    11,
    15,
    19,
  ];
  static const List<int> _primaryStudentPagesForFourLessons = [4, 8, 12, 16];
  static const List<int> _primaryStudentPagesForFiveLessons = [
    4,
    8,
    12,
    16,
    20,
  ];

  LessonPdfDocument? teacherGuideForLesson(Lesson lesson) {
    return switch (lesson.track) {
      Track.primaryPals => _primaryTeacherGuideForLesson(lesson),
      Track.answer => _answerTeacherGuideForLesson(lesson),
      Track.search => _searchTeacherGuideForLesson(lesson),
      Track.discovery => _discoveryTeacherGuideForLesson(lesson),
      _ => null,
    };
  }

  LessonPdfDocument? studentPdfForLesson(Lesson lesson) {
    return switch (lesson.track) {
      Track.primaryPals => _primaryStudentPdfForLesson(lesson),
      Track.answer => _answerStudentPdfForLesson(lesson),
      Track.discovery => _discoveryStudentPdfForLesson(lesson),
      _ => null,
    };
  }

  LessonPdfDocument? _primaryTeacherGuideForLesson(Lesson lesson) {
    final unit = _primaryUnitFromLessonId(lesson.id);
    final lessonPosition = _primaryLessonPosition(lesson.id);
    if (unit == null || lessonPosition == null) {
      return null;
    }

    final pages = _primaryFiveLessonUnits.contains(unit)
        ? _primaryTeacherPagesForFiveLessons
        : _primaryTeacherPagesForFourLessons;
    if (lessonPosition >= pages.length) {
      return null;
    }

    return LessonPdfDocument(
      path:
          "collections/Primary Pals/Teacher's Guides/Primary Pals Teacher's Guide Unit $unit.pdf",
      title: "Teacher's Guide: ${lesson.title}",
      initialPage: pages[lessonPosition],
    );
  }

  LessonPdfDocument? _primaryStudentPdfForLesson(Lesson lesson) {
    final unit = _primaryUnitFromLessonId(lesson.id);
    final lessonPosition = _primaryLessonPosition(lesson.id);
    if (unit == null || lessonPosition == null) {
      return null;
    }

    final pages = _primaryFiveLessonUnits.contains(unit)
        ? _primaryStudentPagesForFiveLessons
        : _primaryStudentPagesForFourLessons;
    if (lessonPosition >= pages.length) {
      return null;
    }

    return LessonPdfDocument(
      path: 'collections/Primary Pals/Primary Pals Students/PP Unit $unit.pdf',
      title: '${lesson.title} PDF',
      initialPage: pages[lessonPosition],
    );
  }

  LessonPdfDocument? _answerTeacherGuideForLesson(Lesson lesson) {
    final lessonNumber = _lessonNumber(lesson);
    if (lessonNumber == null) {
      return null;
    }

    final unit = ((lessonNumber - 1) ~/ 13) + 1;
    if (unit > 16) {
      return null;
    }

    final lessonPosition = (lessonNumber - 1) % 13;
    return LessonPdfDocument(
      path:
          "collections/Answer/answer_teachers/Answer Teacher's Guide Unit $unit.pdf",
      title: "Teacher's Guide: ${lesson.title}",
      initialPage: 7 + (lessonPosition * 4),
    );
  }

  LessonPdfDocument? _searchTeacherGuideForLesson(Lesson lesson) {
    final lessonNumber = _lessonNumber(lesson);
    if (lessonNumber == null) {
      return null;
    }

    final proxyLesson = lesson.copyWith(
      track: Track.answer,
      id: 'answer_$lessonNumber',
      displayNumber: lessonNumber,
    );
    return _answerTeacherGuideForLesson(proxyLesson);
  }

  LessonPdfDocument? _answerStudentPdfForLesson(Lesson lesson) {
    final lessonNumber = _lessonNumber(lesson);
    if (lessonNumber == null) {
      return null;
    }

    final unit = ((lessonNumber - 1) ~/ 13) + 1;
    if (unit > 16) {
      return null;
    }

    final lessonPosition = (lessonNumber - 1) % 13;
    final unitString = unit.toString().padLeft(2, '0');
    return LessonPdfDocument(
      path:
          'collections/Answer/Students_Materials/unit_$unitString-compressed.pdf',
      title: '${lesson.title} PDF',
      initialPage: 4 + (lessonPosition * 3),
    );
  }

  LessonPdfDocument? _discoveryTeacherGuideForLesson(Lesson lesson) {
    final location = _resolveDiscoveryLocation(
      lesson: lesson,
      locations: discoveryTeacherGuideLocations,
    );
    if (location == null) {
      return null;
    }

    return LessonPdfDocument(
      path: location.path,
      title: "Teacher's Guide: ${lesson.title}",
      initialPage: location.page,
    );
  }

  LessonPdfDocument? _discoveryStudentPdfForLesson(Lesson lesson) {
    final location = _resolveDiscoveryLocation(
      lesson: lesson,
      locations: discoveryStudentPdfLocations,
    );
    if (location == null) {
      return null;
    }

    return LessonPdfDocument(
      path: location.path,
      title: '${lesson.title} PDF',
      initialPage: location.page,
    );
  }

  DiscoveryPdfLocation? _resolveDiscoveryLocation({
    required Lesson lesson,
    required Map<String, DiscoveryPdfLocation> locations,
  }) {
    final normalizedTitle = lesson.title.trim().toLowerCase();
    if (normalizedTitle == 'unit' ||
        normalizedTitle.startsWith('apostolic faith church')) {
      return null;
    }

    final direct = locations[lesson.id];
    if (direct != null) {
      return direct;
    }

    final match = RegExp(r'^discovery_(\d+)$').firstMatch(lesson.id);
    final index = int.tryParse(match?.group(1) ?? '');
    if (index == null) {
      return null;
    }

    for (var fallback = index - 1; fallback >= 0; fallback--) {
      final candidate = locations['discovery_$fallback'];
      if (candidate != null) {
        return candidate;
      }
    }
    return null;
  }

  int? _lessonNumber(Lesson lesson) {
    final displayNumber = lesson.displayNumber;
    if (displayNumber != null) {
      return displayNumber;
    }

    final match = RegExp(r'(\d+)$').firstMatch(lesson.id);
    return int.tryParse(match?.group(1) ?? '');
  }

  int? _primaryUnitFromLessonId(String lessonId) {
    final match = RegExp(r'^(\d+)[a-z]$', caseSensitive: false).firstMatch(
      lessonId,
    );
    return int.tryParse(match?.group(1) ?? '');
  }

  int? _primaryLessonPosition(String lessonId) {
    final match = RegExp(r'^\d+([a-z])$', caseSensitive: false).firstMatch(
      lessonId,
    );
    final letter = match?.group(1)?.toLowerCase();
    if (letter == null || letter.isEmpty) {
      return null;
    }
    return letter.codeUnitAt(0) - 'a'.codeUnitAt(0);
  }
}
