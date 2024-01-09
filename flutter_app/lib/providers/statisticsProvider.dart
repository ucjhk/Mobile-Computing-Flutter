import 'package:flutter_app/classes/statistics.dart';
import 'package:flutter_app/utils/storingFiles.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'statisticsProvider.g.dart';

///------------------------------------------------------------------------///
/// Statistics Provider
/// provides the statistics and save them if a new session is added
///------------------------------------------------------------------------///

@Riverpod(keepAlive: true)
class Stats extends _$Stats{

  @override
  Statistics build() {
    return Statistics(mostFlowers: 0, sessions: [], lastTime: DateTime.now());
  }

  void initialize(Statistics value) {
    state = value;
  }

  void addSession(SessionStatistic session) {
    state.sessions.add(session);
    state = state.copyWith();
    saveToFile();
  }

  void setMostFlowers(int value) {
    state.mostFlowers = value;
    saveToFile();
  }

  void saveToFile() {
    saveStatisticsToFile(state);
  }

}