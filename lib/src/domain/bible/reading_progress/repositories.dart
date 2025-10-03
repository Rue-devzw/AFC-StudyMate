import 'entities.dart';

abstract class ReadingProgressRepository {
  Stream<ReadingPosition?> watch();
  Future<ReadingPosition?> getLastPosition();
  Future<void> savePosition(ReadingPosition position);
}
