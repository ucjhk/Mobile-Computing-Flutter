import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_app/providers/postureProvider.dart';
import 'package:flutter_app/providers/statisticsProvider.dart';
import 'package:flutter_app/statistics.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stopWatchProvider.g.dart';

@Riverpod(keepAlive: true)
class StopWatch extends _$StopWatch{
  
  @override
  StopWatchState build() {
    return StopWatchState();
  }

  void _updateTimer() async {
    Future<void>.delayed(Duration(seconds: 1), () {
      if(state.isRunning){
        updateTimer(ref.read(postureProvider).isGoodPosture);
        _updateTimer();
      }
    });
  }

    void start() {
      _updateTimer();
      state = state.copyWith(isRunning: true);
  }

  void setSession(int value){
    state = state.copyWith(session: value);
  }

  void setPause(int value){
    state = state.copyWith(pause: value);
  }

  void stop() {
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    state = state.copyWith(isRunning: false, seconds: 0);
  }

  void updateTimer(isGoodPosture){
        if(state.sessionActive){
          if(state.seconds >= state.session * 60){
            if(state.sessionActive){
              ref.watch(statisticsProvider).addSession(SessionStatistic(
                goodPosturePercentage: state.goodPostureTime / (state.session * 60),
                pauseTime: state.pause.toDouble(),
                sessionTime: state.session.toDouble(),
                day: DateTime.now(),
              ));
            }
            state.sessionActive = false;
            state.seconds = state.pause * 60;
          }
          else {
            if(isGoodPosture){
              state.goodPostureTime++;
            }
            state.seconds++;
          }
        }
        else{
          if(state.seconds <= 0){
            state.sessionActive = true;
            state.seconds = 0;
          }
          else {
            state.seconds--;
          }
        }
        print(state.seconds);
        print(state.goodPostureTime);
        state = state.copyWith();
      }
}

class StopWatchState{
  bool sessionActive = true;
  bool isRunning = false;
  //in minutes
  int session = sessionTime;
  int pause = pauseTime;
  //in seconds
  int seconds = 0;
  int goodPostureTime = 0;


  copyWith({bool? sessionActive, bool? isRunning,int? session,int? pause, int? seconds,int? goodPostureTime}){
    return StopWatchState()
      ..sessionActive = sessionActive ?? this.sessionActive
      ..isRunning = isRunning ?? this.isRunning
      ..session = session ?? this.session
      ..pause = pause ??  this.pause
      ..seconds = seconds ?? this.seconds
      ..goodPostureTime = goodPostureTime ?? this.goodPostureTime;
  }
}


/* final stopWatchProvider = ChangeNotifierProvider.family<StopWatchNotifier, PostureNotifier>((ref, postureProvider) {
  return StopWatchNotifier(postureProvider);
});

class StopWatchNotifier extends ChangeNotifier {

  bool sessionActive = true;
  bool isRunning = false;
  //in minutes
  int session = sessionTime;
  int pause = pauseTime;
  //in seconds
  int seconds = 0;
  int goodPostureTime = 0;

   // Reference to the PostureNotifier provider
  final PostureNotifier postureNotifier;

  // Constructor that takes a PostureNotifier reference
  StopWatchNotifier(this.postureNotifier);

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
            if(postureNotifier.isGoodPosture){
              goodPostureTime++;
            }
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
        print(seconds);
        print(goodPostureTime);
        notifyListeners();
        _updateTimer();
      }
    });
  }
} */