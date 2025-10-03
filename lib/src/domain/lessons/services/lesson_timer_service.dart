import 'dart:async';

class LessonTimerService {
  LessonTimerService();

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _ticker;
  final _tickController = StreamController<int>.broadcast();
  int _accumulatedSeconds = 0;

  Stream<int> get ticks => _tickController.stream;

  bool get isRunning => _stopwatch.isRunning;

  int get elapsedSeconds => _accumulatedSeconds + _stopwatch.elapsed.inSeconds;

  void start() {
    if (_stopwatch.isRunning) {
      return;
    }
    _stopwatch.start();
    _tickController.add(elapsedSeconds);
    _ticker ??= Timer.periodic(const Duration(seconds: 1), (_) {
      _tickController.add(elapsedSeconds);
    });
  }

  void resume() => start();

  int pause() {
    if (!_stopwatch.isRunning) {
      return elapsedSeconds;
    }
    _stopwatch.stop();
    _accumulatedSeconds += _stopwatch.elapsed.inSeconds;
    _stopwatch.reset();
    _tickController.add(elapsedSeconds);
    _ticker?.cancel();
    _ticker = null;
    return _accumulatedSeconds;
  }

  int consume() {
    pause();
    final total = _accumulatedSeconds;
    _accumulatedSeconds = 0;
    _tickController.add(0);
    return total;
  }

  void reset() {
    _stopwatch
      ..stop()
      ..reset();
    _accumulatedSeconds = 0;
    _ticker?.cancel();
    _ticker = null;
    _tickController.add(0);
  }

  void dispose() {
    _ticker?.cancel();
    _tickController.close();
  }
}
