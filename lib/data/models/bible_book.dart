import 'package:afc_studymate/data/models/enums.dart';
import 'package:meta/meta.dart';

@immutable
class BibleBook {
  const BibleBook({required this.number, required this.name});

  final int number;
  final String name;

  Testament get testament =>
      number <= 39 ? Testament.old : Testament.newTestament;
}
