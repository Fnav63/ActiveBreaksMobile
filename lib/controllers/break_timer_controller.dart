import 'dart:async';

class BreakTimerController {
  Timer? _timer;
  int _remainingSeconds;
  bool _isRunning = false;
  bool _isPaused = false;

  final void Function(int remainingSeconds) onTick;
  final void Function() onFinished;

  BreakTimerController({
    required int totalSeconds,
    required this.onTick,
    required this.onFinished,
  }) : _remainingSeconds = totalSeconds;

  void start() {
    if (_isRunning) return;

    _isRunning = true;
    _isPaused = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainingSeconds--;
      onTick(_remainingSeconds);

      if (_remainingSeconds <= 0) {
        stop();
        onFinished();
      }
    });
  }

  void pause() {
    if (!_isRunning) return;

    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _isPaused = true;
  }

  void reset(int totalSeconds) {
    stop();
    _remainingSeconds = totalSeconds;
    onTick(_remainingSeconds);
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _isPaused = false;
  }

  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;
}