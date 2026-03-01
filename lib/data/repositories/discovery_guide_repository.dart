import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/discovery_teacher_guide.dart';

class DiscoveryGuideRepository {
  const DiscoveryGuideRepository();

  static const String _unit7Path =
      'collections/Discovery/Discovery Teacher\'s Guide/2-KINGS-NAH-ZEPH-JER-LAM-DISCOVERY-TG.pdf';

  static final Map<String, DiscoveryTeacherGuide> _mapping = {
    'discovery_1': DiscoveryTeacherGuide(
      lessonId: 'discovery_1',
      pdfPath: _unit7Path,
      startPage: 3,
    ),
    'discovery_2': DiscoveryTeacherGuide(
      lessonId: 'discovery_2',
      pdfPath: _unit7Path,
      startPage: 9,
    ),
    'discovery_3': DiscoveryTeacherGuide(
      lessonId: 'discovery_3',
      pdfPath: _unit7Path,
      startPage: 13,
    ),
    'discovery_4': DiscoveryTeacherGuide(
      lessonId: 'discovery_4',
      pdfPath: _unit7Path,
      startPage: 19,
    ),
    'discovery_5': DiscoveryTeacherGuide(
      lessonId: 'discovery_5',
      pdfPath: _unit7Path,
      startPage: 25,
    ),
    'discovery_6': DiscoveryTeacherGuide(
      lessonId: 'discovery_6',
      pdfPath: _unit7Path,
      startPage: 31,
    ),
    'discovery_7': DiscoveryTeacherGuide(
      lessonId: 'discovery_7',
      pdfPath: _unit7Path,
      startPage: 37,
    ),
    'discovery_8': DiscoveryTeacherGuide(
      lessonId: 'discovery_8',
      pdfPath: _unit7Path,
      startPage: 43,
    ),
    'discovery_9': DiscoveryTeacherGuide(
      lessonId: 'discovery_9',
      pdfPath: _unit7Path,
      startPage: 49,
    ),
    'discovery_10': DiscoveryTeacherGuide(
      lessonId: 'discovery_10',
      pdfPath: _unit7Path,
      startPage: 55,
    ),
    'discovery_11': DiscoveryTeacherGuide(
      lessonId: 'discovery_11',
      pdfPath: _unit7Path,
      startPage: 61,
    ),
    'discovery_12': DiscoveryTeacherGuide(
      lessonId: 'discovery_12',
      pdfPath: _unit7Path,
      startPage: 67,
    ),
    'discovery_13': DiscoveryTeacherGuide(
      lessonId: 'discovery_13',
      pdfPath: _unit7Path,
      startPage: 73,
    ),
  };

  DiscoveryTeacherGuide? getGuideForLesson(String lessonId) {
    return _mapping[lessonId];
  }
}

final discoveryGuideRepositoryProvider = Provider<DiscoveryGuideRepository>((
  ref,
) {
  return const DiscoveryGuideRepository();
});
