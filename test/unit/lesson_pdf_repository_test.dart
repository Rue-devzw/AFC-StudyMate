import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/lesson.dart';
import 'package:afc_studymate/data/repositories/lesson_pdf_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const repository = LessonPdfRepository();

  Lesson makeLesson({
    required String id,
    required Track track,
    required String title,
    int? displayNumber,
  }) {
    return Lesson(
      id: id,
      track: track,
      title: title,
      bibleReferences: const [],
      payload: const {},
      displayNumber: displayNumber,
    );
  }

  test('primary pals teacher guide opens correct unit and page', () {
    final lesson = makeLesson(
      id: '1c',
      track: Track.primaryPals,
      title: 'Jesus Died for Us',
    );

    final guide = repository.teacherGuideForLesson(lesson);
    expect(
      guide?.path,
      "collections/Primary Pals/Teacher's Guides/Primary Pals Teacher's Guide Unit 1.pdf",
    );
    expect(guide?.initialPage, 11);
  });

  test('answer and search share teacher guide PDFs', () {
    final answerLesson = makeLesson(
      id: 'answer_79',
      track: Track.answer,
      title: 'Answer 79',
      displayNumber: 79,
    );
    final searchLesson = makeLesson(
      id: 'lesson_79',
      track: Track.search,
      title: 'Search 79',
      displayNumber: 79,
    );

    final answerGuide = repository.teacherGuideForLesson(answerLesson);
    final searchGuide = repository.teacherGuideForLesson(searchLesson);

    expect(
      answerGuide?.path,
      "collections/Answer/answer_teachers/Answer Teacher's Guide Unit 7.pdf",
    );
    expect(answerGuide?.initialPage, 7);
    expect(searchGuide?.path, answerGuide?.path);
    expect(searchGuide?.initialPage, answerGuide?.initialPage);
  });

  test('discovery inserted lesson resolves to mapped pdf section', () {
    final lesson = makeLesson(
      id: 'discovery_30',
      track: Track.discovery,
      title: 'This lesson is the first of three on Biblical prophecy',
    );

    final guide = repository.teacherGuideForLesson(lesson);
    final studentPdf = repository.studentPdfForLesson(lesson);

    expect(
      guide?.path,
      "collections/Discovery/Discovery Teacher's Guide/EZEK-DAN-HAB-OBAD-ESTH-DISCOVERY-TG.pdf",
    );
    expect(guide?.initialPage, 9);
    expect(
      studentPdf?.path,
      'collections/Discovery/Discovery Students/EZEK-DAN-HAB-OBAD-ESTH-DISCOVERY.pdf',
    );
    expect(studentPdf?.initialPage, 5);
  });

  test('search lessons do not expose student PDFs without files', () {
    final lesson = makeLesson(
      id: 'lesson_79',
      track: Track.search,
      title: 'Search 79',
      displayNumber: 79,
    );

    expect(repository.studentPdfForLesson(lesson), isNull);
  });
}
