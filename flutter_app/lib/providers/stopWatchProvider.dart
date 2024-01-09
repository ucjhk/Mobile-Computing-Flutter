import 'package:flutter_app/classes/statistics.dart';
import 'package:flutter_app/providers/eSenseManager.dart';
import 'package:flutter_app/providers/postureProvider.dart';
import 'package:flutter_app/providers/statisticsProvider.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stopWatchProvider.g.dart';

///------------------------------------------------------------------------///
/// StopWatch Provider
/// provides the StopwatchState and updates its timer every second
///------------------------------------------------------------------------///

@Riverpod(keepAlive: true)
class StopWatch extends _$StopWatch{
  
  @override
  StopWatchState build() {
    return StopWatchState();
  }

  //calls the updateTime every second
  void updateTimer() async {
    Future<void>.delayed(const Duration(seconds: 1), () {
      if(state.isRunning){
        _updateTimer(ref.read(postureProvider).isGoodPosture);
        updateTimer();
      }
    });
  }

  void start() {
    updateTimer();
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
    state = state.copyWith(isRunning: false, seconds: state.sessionActive ? 0 : state.pause *60);
  }

  // updates the seconds and sets the state based on the time
  void _updateTimer(isGoodPosture){
    //User is in a session
    if(state.sessionActive){

      //finished the session
      if(state.seconds >= state.session * 60){
        //called once if state is switched
        if(state.sessionActive){
          //add the session to the statisticsProvider
          ref.watch(statsProvider.notifier).addSession(SessionStatistic(
            goodPosturePercentage: state.goodPostureTime / (state.session * 60),
            pauseTime: state.pause.toDouble(),
            sessionTime: state.session.toDouble(),
            date: DateTime.now(),
          ));
          //notify the user that the session has ended
          ref.watch(eSenseHandlerProvider.notifier).playASound(sessionEndSoundPath);
        }
        state.goodPostureTime = 0;
        state.sessionActive = false;
        state.seconds = state.pause * 60;
      }

      //not finished the session
      else {
        if(isGoodPosture){
          state.goodPostureTime++;
        }
        state.seconds++;
      }
    }

    //SessionPause state
    else{

      //sessionPause is over
      if(state.seconds <= 0){
        state.sessionActive = true;
        state.seconds = 0;
      }

      //not over
      else {
        state.seconds--;
      }
    }
    state = state.copyWith();
  }
}
///------------------------------------------------------------------------///
/// StopWatchState Class
/// contains the stopwatch state, the session times, and the current times
///------------------------------------------------------------------------///

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
