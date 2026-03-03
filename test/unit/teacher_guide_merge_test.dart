import 'package:afc_studymate/data/drift/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mergeTeacherGuides concatenates chunks and avoids duplicates', () {
    final merged = mergeTeacherGuides([
      {
        'lesson_id': 'answer_1',
        'content': 'Part A',
        'pdf_path': 'a.pdf',
      },
      {
        'lesson_id': 'answer_1',
        'content': 'Part B',
        'pdf_path': 'a.pdf',
      },
      {
        'lesson_id': 'answer_1',
        'content': 'Part B',
        'pdf_path': 'a.pdf',
      },
    ]);

    expect(merged, contains('answer_1'));
    expect(merged['answer_1']!.content, 'Part A\n\nPart B');
  });
}
