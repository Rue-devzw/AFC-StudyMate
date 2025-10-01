import '../models/bible.dart';

class BibleService {
  static Bible getBible() {
    return Bible(
      translation: 'KJV',
      books: [
        Book(
          name: 'Genesis',
          chapters: [
            Chapter(
              number: 1,
              verses: [
                Verse(
                  number: 1,
                  text:
                      'In the beginning God created the heaven and the earth.',
                ),
                Verse(
                  number: 2,
                  text:
                      'And the earth was without form, and void; and darkness was upon the face of the deep. And the Spirit of God moved upon the face of the waters.',
                ),
                Verse(
                  number: 3,
                  text:
                      'And God said, Let there be light: and there was light.',
                ),
              ],
            ),
            Chapter(number: 2, verses: []),
            // ... other chapters
          ],
        ),
        Book(
          name: 'Exodus',
          chapters: List.generate(
            40,
            (i) => Chapter(number: i + 1, verses: []),
          ),
        ),
        Book(
          name: 'Leviticus',
          chapters: List.generate(
            27,
            (i) => Chapter(number: i + 1, verses: []),
          ),
        ),
        // Add more books as needed
      ],
    );
  }
}
