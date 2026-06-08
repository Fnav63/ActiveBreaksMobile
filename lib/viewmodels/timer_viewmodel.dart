import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/active_break.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';

enum TimerState { idle, running, paused, finished }

class TimerViewModel extends ChangeNotifier {
  final NotificationService _notificationService;
  final StorageService _storageService;

  TimerViewModel({
    required NotificationService notificationService,
    required StorageService storageService,
  })  : _notificationService = notificationService,
        _storageService = storageService;

  Timer? _timer;
  TimerState _state = TimerState.idle;
  int _remainingSeconds = 0;
  int _totalSeconds = 0;
  ActiveBreak? _currentBreak;

  TimerState get state => _state;
  int get remainingSeconds => _remainingSeconds;
  int get totalSeconds => _totalSeconds;
  ActiveBreak? get currentBreak => _currentBreak;
  bool get isRunning => _state == TimerState.running;
  bool get isPaused => _state == TimerState.paused;
  bool get isFinished => _state == TimerState.finished;
  bool get isIdle => _state == TimerState.idle;

  double get progress => _totalSeconds == 0
      ? 0.0
      : (_totalSeconds - _remainingSeconds) / _totalSeconds;

  String get formattedTime {
    final m = _remainingSeconds ~/ 60;
    final s = _remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void loadBreak(ActiveBreak activeBreak) {
    _currentBreak = activeBreak;
    _totalSeconds = activeBreak.durationSeconds;
    _remainingSeconds = activeBreak.durationSeconds;
    _state = TimerState.idle;
    _timer?.cancel();
    notifyListeners();
  }

  void start() {
    if (_state == TimerState.running) return;
    _state = TimerState.running;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        _onFinished();
        return;
      }
      _remainingSeconds--;
      notifyListeners();
    });
  }

  void pause() {
    if (_state != TimerState.running) return;
    _timer?.cancel();
    _state = TimerState.paused;
    notifyListeners();
  }

  void resume() {
    if (_state != TimerState.paused) return;
    start();
  }

  void reset() {
    _timer?.cancel();
    _remainingSeconds = _totalSeconds;
    _state = TimerState.idle;
    notifyListeners();
  }

  Future<void> _onFinished() async {
    _timer?.cancel();
    _remainingSeconds = 0;
    _state = TimerState.finished;
    notifyListeners();

    if (_currentBreak != null) {
      await _storageService.addCompletedBreak(_currentBreak!.title);
      await _notificationService
          .showBreakCompletedNotification(_currentBreak!.title);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}