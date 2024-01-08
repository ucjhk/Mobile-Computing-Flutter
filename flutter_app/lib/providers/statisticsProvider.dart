import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/classes/statistics.dart';
import 'package:flutter_app/utils/storingFiles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final statisticsProvider = ChangeNotifierProvider<StatisticsNotifier>((ref) {
  return StatisticsNotifier();
});

class StatisticsNotifier extends ChangeNotifier {
  Statistics statistics = Statistics(mostFlowers: 0, lastTime: DateTime.now(), sessions: []);

  StatisticsNotifier() {
    readStatisticsFromFile().then((value) {
      initialize(value);
    });
  }

  void initialize(Statistics value) {
    statistics = value;
    notifyListeners();
  }

  void addSession(SessionStatistic session) {
    statistics.sessions.add(session);
    notifyListeners();
    //TODO async;
    saveToFile();
  }

  void setMostFlowers(int value) {
    statistics.mostFlowers = value;
    //TODO async;
    saveToFile();
    notifyListeners();
  }

  void saveToFile() {
    saveStatisticsToFile(statistics);
  }
}