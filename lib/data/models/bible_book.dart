import 'package:meta/meta.dart';

import 'enums.dart';

@immutable
class BibleBook {
  const BibleBook({required this.number, required this.name});

  final int number;
  final String name;

  Testament get testament =>
      number <= 39 ? Testament.old : Testament.newTestament;
}
