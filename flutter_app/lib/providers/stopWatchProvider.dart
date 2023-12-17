import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stopWatchProvider = ChangeNotifierProvider<StopWatchNotifier>((ref) {
  return StopWatchNotifier();
});

class StopWatchNotifier extends ChangeNotifier {
  bool isRunning = false;
  int seconds = 0;

  void start() {
    isRunning = true;
    _updateTimer();
  }

  void stop() {
    isRunning = false;
    notifyListeners();
  }

  void reset() {
    isRunning = false;
    seconds = 0;
    notifyListeners();
  }

  void _updateTimer() async {
    Future<void>.delayed(Duration(seconds: 1), () {
      if (isRunning) {
        seconds++;
        notifyListeners();
        _updateTimer();
      }
    });
  }
}