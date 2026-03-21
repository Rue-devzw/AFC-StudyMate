import 'package:afc_studymate/data/drift/app_database.dart';
import 'package:afc_studymate/data/models/enums.dart';
import 'package:afc_studymate/data/models/lesson.dart';
import 'package:afc_studymate/data/repositories/lesson_repository.dart';
import 'package:afc_studymate/data/services/schedule_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAppDatabase extends AppDatabase {
  _FakeAppDatabase(this._lessonsByTrack);

  final Map<Track, List<Lesson>> _lessonsByTrack;

  @override
  Future<List<Lesson>> getLessonsByTrack(Track track) async =>
      _lessonsByTrack[track] ?? const <Lesson>[];
}

class _FakeScheduleService extends ScheduleService {
  _FakeScheduleService(
    this._weekIndexes, {
    this.weekIndexForDate,
  });

  final Map<Track, int> _weekIndexes;
  final int Function(Track track, DateTime date)? weekIndexForDate;

  @override
  int weekIndexForTrack(Track track) => _weekIndexes[track] ?? 0;

  @override
  int weekIndexForTrackAt(Track track, DateTime date) =>
      weekIndexForDate?.call(track, date) ?? _weekIndexes[track] ?? 0;
}

void main() {
  Lesson makeLesson({
    required String id,
    required Track track,
    required String title,
    required int weekIndex,
    int? displayNumber,
  }) {
    return Lesson(
      id: id,
      track: track,
      title: title,
      bibleReferences: const [],
      payload: const {},
      weekIndex: weekIndex,
      displayNumber: displayNumber,
    );
  }

  test('current Sunday lesson follows display numbering for search', () async {
    final repository = LessonRepository(
      database: _FakeAppDatabase({
        Track.search: [
          makeLesson(
            id: 'theme_thoughts',
            track: Track.search,
            title: 'Theme Thoughts',
            weekIndex: 39,
          ),
          makeLesson(
            id: 'theme_thoughts',
            track: Track.search,
            title: 'Theme Thoughts',
            weekIndex: 66,
          ),
          makeLesson(
            id: 'lesson_78',
            track: Track.search,
            title: 'Search 78',
            weekIndex: 77,
            displayNumber: 78,
          ),
          makeLesson(
            id: 'lesson_79',
            track: Track.search,
            title: 'Search 79',
            weekIndex: 81,
            displayNumber: 79,
          ),
          makeLesson(
            id: 'lesson_80',
            track: Track.search,
            title: 'Search 80',
            weekIndex: 82,
            displayNumber: 80,
          ),
          makeLesson(
            id: 'lesson_83',
            track: Track.search,
            title: 'Search 81',
            weekIndex: 83,
            displayNumber: 81,
          ),
        ],
      }),
      scheduleService: _FakeScheduleService({Track.search: 80}),
    );

    final lesson = await repository.getCurrentSundayLesson(Track.search);

    expect(lesson?.id, 'lesson_83');
    expect(lesson?.displayNumber, 81);
  });

  test('current Sunday lesson follows display numbering for answer', () async {
    final repository = LessonRepository(
      database: _FakeAppDatabase({
        Track.answer: [
          makeLesson(
            id: 'answer_79',
            track: Track.answer,
            title: 'Answer 79',
            weekIndex: 78,
            displayNumber: 79,
          ),
          makeLesson(
            id: 'answer_81',
            track: Track.answer,
            title: 'Answer 81',
            weekIndex: 74,
            displayNumber: 81,
          ),
          makeLesson(
            id: 'answer_82',
            track: Track.answer,
            title: 'Answer 82',
            weekIndex: 75,
            displayNumber: 82,
          ),
        ],
      }),
      scheduleService: _FakeScheduleService({Track.answer: 80}),
    );

    final lesson = await repository.getCurrentSundayLesson(Track.answer);

    expect(lesson?.id, 'answer_81');
    expect(lesson?.displayNumber, 81);
  });

  test('current Sunday lesson falls forward when a week is missing', () async {
    final repository = LessonRepository(
      database: _FakeAppDatabase({
        Track.primaryPals: [
          makeLesson(
            id: '18d',
            track: Track.primaryPals,
            title: 'Primary 18d',
            weekIndex: 75,
            displayNumber: 76,
          ),
          makeLesson(
            id: '20a',
            track: Track.primaryPals,
            title: 'Primary 20a',
            weekIndex: 77,
            displayNumber: 78,
          ),
        ],
      }),
      scheduleService: _FakeScheduleService({Track.primaryPals: 76}),
    );

    final lesson = await repository.getCurrentSundayLesson(Track.primaryPals);

    expect(lesson?.id, '20a');
    expect(lesson?.weekIndex, 77);
  });

  test('Sunday lesson for a selected date uses that date week', () async {
    final repository = LessonRepository(
      database: _FakeAppDatabase({
        Track.primaryPals: [
          makeLesson(
            id: '19c',
            track: Track.primaryPals,
            title: 'Primary 19c',
            weekIndex: 80,
            displayNumber: 81,
          ),
          makeLesson(
            id: '19d',
            track: Track.primaryPals,
            title: 'Primary 19d',
            weekIndex: 81,
            displayNumber: 82,
          ),
        ],
      }),
      scheduleService: _FakeScheduleService(
        {Track.primaryPals: 80},
        weekIndexForDate: (track, date) {
          if (track == Track.primaryPals && date == DateTime(2026, 3, 24)) {
            return 81;
          }
          return 80;
        },
      ),
    );

    final lesson = await repository.getSundayLessonForDate(
      Track.primaryPals,
      DateTime(2026, 3, 24),
    );

    expect(lesson?.id, '19d');
    expect(lesson?.weekIndex, 81);
  });
}
