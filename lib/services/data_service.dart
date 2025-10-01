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
        ageGroup: 'Search (High School-Adults)',
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
        ageGroup: 'Search (High School-Adults)',
      ),
      Lesson(
        title: 'God Made the World',
        date: 'October 2, 2024',
        introduction: 'A lesson for the little ones about creation.',
        sections: [
          Section(
            title: 'Day and Night',
            content: 'God made light and darkness.',
          ),
          Section(
            title: 'Sky and Water',
            content: 'God separated the sky from the water.',
          ),
        ],
        ageGroup: 'Beginners (2-5)',
      ),
      Lesson(
        title: 'Noah and the Ark',
        date: 'October 9, 2024',
        introduction: 'The story of Noah and the great flood.',
        sections: [
          Section(
            title: 'Building the Ark',
            content: 'God told Noah to build a big boat.',
          ),
          Section(
            title: 'The Animals',
            content: 'Two of every animal went into the ark.',
          ),
        ],
        ageGroup: 'Primary Pals (1st-3rd Grade)',
      ),
      Lesson(
        title: 'The Ten Commandments',
        date: 'October 16, 2024',
        introduction: 'A lesson on the laws God gave to Moses.',
        sections: [
          Section(
            title: 'The First Four',
            content: 'Loving God.',
          ),
          Section(
            title: 'The Last Six',
            content: 'Loving others.',
          ),
        ],
        ageGroup: 'Answer (4th-8th Grade)',
      ),
      Lesson(
        title: 'The Life of David',
        date: 'October 23, 2024',
        introduction: 'Exploring the life of King David.',
        sections: [
          Section(
            title: 'Shepherd Boy',
            content: 'David as a young shepherd.',
          ),
          Section(
            title: 'King of Israel',
            content: 'David becomes king.',
          ),
        ],
        ageGroup: 'Discovery (High School-Adults)',
      ),
    ];
  }
}
