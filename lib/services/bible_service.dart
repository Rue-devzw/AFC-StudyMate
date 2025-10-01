import '../models/bible.dart';

class BibleService {
  static Bible getBible() {
    return Bible(
      translation: 'King James Version',
      books: [
        Book(
          name: 'Genesis',
          chapters: [
            Chapter(
              number: 1,
              verses: [
                Verse(number: 1, text: 'In the beginning God created the heaven and the earth.'),
                Verse(number: 2, text: 'And the earth was without form, and void; and darkness was upon the face of the deep. And the Spirit of God moved upon the face of the waters.'),
              ],
            ),
            Chapter(
              number: 2,
              verses: [
                Verse(number: 1, text: 'Thus the heavens and the earth were finished, and all the host of them.'),
                Verse(number: 2, text: 'And on the seventh day God ended his work which he had made; and he rested on the seventh day from all his work which he had made.'),
              ],
            ),
          ],
        ),
        Book(
          name: 'Exodus',
          chapters: [
            Chapter(
              number: 1,
              verses: [
                Verse(number: 1, text: 'Now these are the names of the children of Israel, which came into Egypt; every man and his household came with Jacob.'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static Bible getAmplifiedBible() {
    return Bible(
      translation: 'Amplified Version',
      books: [
        Book(
          name: 'Genesis',
          chapters: [
            Chapter(
              number: 1,
              verses: [
                Verse(number: 1, text: 'In the beginning God (prepared, formed, fashioned, and) created the heavens and the earth.'),
                Verse(number: 2, text: 'The earth was without form and an empty waste, and darkness was upon the face of the very great deep. The Spirit of God was moving (hovering, brooding) over the face of the waters.'),
              ],
            ),
            Chapter(
              number: 2,
              verses: [
                Verse(number: 1, text: 'So the heavens and the earth were finished, and all the host of them.'),
                Verse(number: 2, text: 'And on the seventh day God ended His work which He had done, and He rested on the seventh day from all His work which He had done.'),
              ],
            ),
          ],
        ),
        Book(
          name: 'Exodus',
          chapters: [
            Chapter(
              number: 1,
              verses: [
                Verse(number: 1, text: 'These are the names of the sons of Israel who came into Egypt with Jacob, each with his household:'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static Bible getNdebeleBible() {
    return Bible(
      translation: 'Ndebele Version',
      books: [
        Book(
          name: 'Genesisi',
          chapters: [
            Chapter(
              number: 1,
              verses: [
                Verse(number: 1, text: 'Ekuqaleni uNkulunkulu wadala izulu lomhlaba.'),
                Verse(number: 2, text: 'Umhlaba wawusenyanyeni, uluyize; ubumnyama babuphezu kobusobethelweni lwamanzi. UMoya kaNkulunkulu wanyakaza phezu kwamanzi.'),
              ],
            ),
            Chapter(
              number: 2,
              verses: [
                Verse(number: 1, text: 'Lazaliswa-ke izulu lomhlaba, lempi yalo yonke.'),
                Verse(number: 2, text: 'UNkulunkulu waseqeda ngosuku lwesikhombisa umsebenzi wakhe awenzileyo; waphumula ngosuku lwesikhombisa kuwo wonke umsebenzi wakhe awenzileyo.'),
              ],
            ),
          ],
        ),
        Book(
          name: 'Eksodasi',
          chapters: [
            Chapter(
              number: 1,
              verses: [
                Verse(number: 1, text: 'Lawa-ke ngamabizo amadodana kaIsrayeli angena eGibithe; onke angena loJakobe, yileyo lalowo lendlu yakhe.'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
