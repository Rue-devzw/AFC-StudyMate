import '../models/lesson.dart';

class DataService {
  static List<Lesson> getLessons() {
    return [
      Lesson(
        title: 'The Fall of Man',
        date: 'October 2, 2024',
        introduction:
            'This lesson explores the biblical account of the fall of man, its consequences, and God\'s plan for redemption.',
        sections: [
          Section(
            title: 'The Temptation',
            content: 'Genesis 3:1-5 details the serpent\'s temptation of Eve.',
          ),
          Section(
            title: 'The Disobedience',
            content:
                'Genesis 3:6-8 describes Adam and Eve\'s disobedience and their immediate sense of shame.',
          ),
          Section(
            title: 'The Consequences',
            content:
                'Genesis 3:9-24 outlines the curses pronounced on the serpent, the woman, and the man, and their expulsion from the Garden of Eden.',
          ),
        ],
      ),
      Lesson(
        title: 'The Call of Abraham',
        date: 'October 9, 2024',
        introduction:
            'This lesson examines God\'s covenant with Abraham and the beginning of the nation of Israel.',
        sections: [
          Section(
            title: 'God\'s Promise',
            content:
                'Genesis 12:1-3 records God\'s call to Abram, promising to make him a great nation.',
          ),
          Section(
            title: 'Abraham\'s Journey',
            content:
                'Genesis 12:4-9 describes Abraham\'s obedience and his journey to the land of Canaan.',
          ),
        ],
      ),
    ];
  }
}
