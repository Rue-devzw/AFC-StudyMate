import 'package:afc_studymate/data/models/discovery_teacher_guide.dart';
import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DiscoveryGuideOption {
  const DiscoveryGuideOption({
    required this.title,
    required this.pdfPath,
    this.startPage = 1,
    this.recommended = false,
  });

  final String title;
  final String pdfPath;
  final int startPage;
  final bool recommended;
}

class DiscoveryGuideRepository {
  const DiscoveryGuideRepository();

  static const List<DiscoveryGuideOption> _allGuides = <DiscoveryGuideOption>[
    DiscoveryGuideOption(
      title: 'Genesis, Exodus, Job',
      pdfPath: 'assets/pdfs/discovery_teachers/GEN-EXO-JOB-DISCOVERY-TG.pdf',
    ),
    DiscoveryGuideOption(
      title: 'Leviticus, Numbers, Deuteronomy, Joshua',
      pdfPath:
          'assets/pdfs/discovery_teachers/LEV-NUM-DEUT-JOSH-DISCOVERY-TG.pdf',
    ),
    DiscoveryGuideOption(
      title: 'Judges, Ruth, Samuel, 1 Kings',
      pdfPath:
          'assets/pdfs/discovery_teachers/JUDG-RUTH-SAM-1-KINGS-DISCOVERY-TG.pdf',
    ),
    DiscoveryGuideOption(
      title: '2 Kings, Nahum, Zephaniah, Jeremiah, Lamentations',
      pdfPath:
          'assets/pdfs/discovery_teachers/2-KINGS-NAH-ZEPH-JER-LAM-DISCOVERY-TG.pdf',
    ),
    DiscoveryGuideOption(
      title: 'Chronicles, Ezra, Nehemiah, Haggai, Zechariah, Malachi',
      pdfPath:
          'assets/pdfs/discovery_teachers/CHR-EZRA-NEH-HAG-ZECH-MAL-DISCOVERY-TG.pdf',
    ),
    DiscoveryGuideOption(
      title: 'Proverbs, Ecclesiastes, Song of Solomon, Psalms',
      pdfPath:
          'assets/pdfs/discovery_teachers/PROV-ECCL-SONG-PSALMS-DISCOVERY-TG.pdf',
    ),
    DiscoveryGuideOption(
      title: 'Joel, Jonah, Amos, Hosea, Micah, Isaiah',
      pdfPath:
          'assets/pdfs/discovery_teachers/JOEL-JON-AMOS-HOS-MIC-ISA-DISCOVERY-TG.pdf',
    ),
    DiscoveryGuideOption(
      title: 'Ezekiel, Daniel, Habakkuk, Obadiah, Esther',
      pdfPath:
          'assets/pdfs/discovery_teachers/EZEK-DAN-HAB-OBAD-ESTH-DISCOVERY-TG.pdf',
    ),
    DiscoveryGuideOption(
      title: 'Luke, Acts, James, Galatians, Romans',
      pdfPath:
          'assets/pdfs/discovery_teachers/LUKE-ACTS-JAMES-GAL-ROM-DISCOVERY-TG.pdf',
    ),
    DiscoveryGuideOption(
      title: 'Mark, Corinthians, Timothy, Titus, Philemon, Peter',
      pdfPath:
          'assets/pdfs/discovery_teachers/MARK-COR-TIM-TIT-PHILEM-PET-DISCOVERY-TG.pdf',
    ),
    DiscoveryGuideOption(
      title:
          'Matthew, Hebrews, Ephesians, Philippians, Colossians, Thessalonians',
      pdfPath:
          'assets/pdfs/discovery_teachers/MATT-HEB-EPH-PHIL-COL-THESS-DISCOVERY-TG.pdf',
    ),
  ];

  static const String _unit7Path =
      'assets/pdfs/discovery_teachers/2-KINGS-NAH-ZEPH-JER-LAM-DISCOVERY-TG.pdf';

  static final Map<String, DiscoveryTeacherGuide> _mapping = {
    'discovery_1': const DiscoveryTeacherGuide(
      lessonId: 'discovery_1',
      pdfPath: _unit7Path,
      startPage: 3,
    ),
    'discovery_2': const DiscoveryTeacherGuide(
      lessonId: 'discovery_2',
      pdfPath: _unit7Path,
      startPage: 9,
    ),
    'discovery_3': const DiscoveryTeacherGuide(
      lessonId: 'discovery_3',
      pdfPath: _unit7Path,
      startPage: 13,
    ),
    'discovery_4': const DiscoveryTeacherGuide(
      lessonId: 'discovery_4',
      pdfPath: _unit7Path,
      startPage: 19,
    ),
    'discovery_5': const DiscoveryTeacherGuide(
      lessonId: 'discovery_5',
      pdfPath: _unit7Path,
      startPage: 25,
    ),
    'discovery_6': const DiscoveryTeacherGuide(
      lessonId: 'discovery_6',
      pdfPath: _unit7Path,
      startPage: 31,
    ),
    'discovery_7': const DiscoveryTeacherGuide(
      lessonId: 'discovery_7',
      pdfPath: _unit7Path,
      startPage: 37,
    ),
    'discovery_8': const DiscoveryTeacherGuide(
      lessonId: 'discovery_8',
      pdfPath: _unit7Path,
      startPage: 43,
    ),
    'discovery_9': const DiscoveryTeacherGuide(
      lessonId: 'discovery_9',
      pdfPath: _unit7Path,
      startPage: 49,
    ),
    'discovery_10': const DiscoveryTeacherGuide(
      lessonId: 'discovery_10',
      pdfPath: _unit7Path,
      startPage: 55,
    ),
    'discovery_11': const DiscoveryTeacherGuide(
      lessonId: 'discovery_11',
      pdfPath: _unit7Path,
      startPage: 61,
    ),
    'discovery_12': const DiscoveryTeacherGuide(
      lessonId: 'discovery_12',
      pdfPath: _unit7Path,
      startPage: 67,
    ),
    'discovery_13': const DiscoveryTeacherGuide(
      lessonId: 'discovery_13',
      pdfPath: _unit7Path,
      startPage: 73,
    ),
  };

  DiscoveryTeacherGuide? getGuideForLesson(String lessonId) {
    return _mapping[lessonId];
  }

  List<DiscoveryGuideOption> getAllGuides() => _allGuides;

  List<DiscoveryGuideOption> getGuideOptionsForLesson(String lessonId) {
    final recommended = getGuideForLesson(lessonId);
    final options = <DiscoveryGuideOption>[];
    if (recommended != null) {
      final guideTitle =
          _allGuides
              .firstWhereOrNull((item) => item.pdfPath == recommended.pdfPath)
              ?.title ??
          'Recommended Guide';
      options.add(
        DiscoveryGuideOption(
          title: 'Recommended for this lesson: $guideTitle',
          pdfPath: recommended.pdfPath,
          startPage: recommended.startPage,
          recommended: true,
        ),
      );
    }
    options.addAll(_allGuides);
    return options;
  }
}

final discoveryGuideRepositoryProvider = Provider<DiscoveryGuideRepository>(
  (ref) {
    return const DiscoveryGuideRepository();
  },
);
