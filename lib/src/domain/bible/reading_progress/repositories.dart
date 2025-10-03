import 'entities.dart';

abstract class ReadingProgressRepository {
  Stream<ReadingPosition?> watch(String userId);
  Future<ReadingPosition?> getLastPosition(String userId);
  Future<void> savePosition(String userId, ReadingPosition position);
}
