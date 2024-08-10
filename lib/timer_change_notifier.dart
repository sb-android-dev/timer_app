import 'dart:async';

import 'package:flutter/foundation.dart';

class TimerChangeNotifier extends ChangeNotifier {
  static final TimerChangeNotifier _instance = TimerChangeNotifier._internal();

  factory TimerChangeNotifier() {
    return _instance;
  }

  TimerChangeNotifier._internal();

  Timer? _timer;

  int _remainingTime = 0;

  Function()? _onComplete;

  int get remainingTime => _remainingTime;

  String get formatedRemainingSeconds => _formatSeconds();

  bool get isRunning => _timer?.isActive ?? false;

  TimerFormat _timerFormat = TimerFormat.mm_ss;



  startTimer(int seconds, {Function()? onComplete, TimerFormat? timerFormat}) {
    _remainingTime = seconds * 1000;
    if(onComplete != null) {
      _onComplete = onComplete;
    }
    if(timerFormat != null) {
      _timerFormat = timerFormat;
    }

    _timer?.cancel();
    resumeTimer();
  }

  resumeTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      updateRemainingTime();
      if (_remainingTime == 0) {
        timer.cancel();
        _onComplete?.call();
      }
    });
  }

  toggleTimer() {
    if(_timer?.isActive == true) {
      stopTimer();
    } else {
      resumeTimer();
    }
  }

  updateRemainingTime() {
    if (_remainingTime > 0) {
      _remainingTime--;
    }
    notifyListeners();
  }

  stopTimer() {
    _timer?.cancel();
  }

  String _formatSeconds() {
    int seconds = remainingTime ~/ 1000;
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    int remainingMilliSeconds = remainingTime % 1000;

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');
    String millisecondsStr = remainingMilliSeconds.toString().padLeft(3, '0');

    switch(_timerFormat) {
      case TimerFormat.mm_ss:
        return '$minutesStr:$secondsStr';
      case TimerFormat.mm_ss_SS:
        return '$minutesStr:$secondsStr.$millisecondsStr';
    }
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }
}

enum TimerFormat {
  mm_ss, mm_ss_SS
}
