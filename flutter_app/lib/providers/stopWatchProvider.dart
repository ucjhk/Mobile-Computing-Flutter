import 'package:flutter/material.dart';
import 'package:flutter_app/providers/postureProvider.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stopWatchProvider = ChangeNotifierProvider<StopWatchNotifier>((ref) {
  return StopWatchNotifier();
});

class StopWatchNotifier extends ChangeNotifier {
  bool sessionActive = true;
  bool isRunning = false;
  //in minutes
  int session = sessionTime;
  int pause = pauseTime;
  //in seconds
  int seconds = 0;

  void setSession(int value){
    session = value;
    notifyListeners();
  }

  void setPause(int value){
    pause = value;
    notifyListeners();
  }

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
        if(sessionActive){
          if(seconds >= session * 60){
            sessionActive = false;
            seconds = pause * 60;
          }
          else {
            seconds++;
          }
        }
        else{
          if(seconds <= 0){
            sessionActive = true;
            seconds = 0;
          }
          else {
            seconds--;
          }
        }
        notifyListeners();
        _updateTimer();
      }
    });
  }
}