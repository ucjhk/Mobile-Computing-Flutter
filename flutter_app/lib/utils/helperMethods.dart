import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/components/gardenComponents.dart';
import 'package:flutter_app/statistics.dart';
import 'package:tuple/tuple.dart';

int getFirstGarbageInList(List<Widget> list){
  for(int i = 0; i < list.length; i++){
    if(list[i] is GarbageWidget || list[i] is BigGarbageWidget){
      return i;
    }
  }
  return -1;
}

int getObjectCount<T extends GardenObjectWidget>(List<Widget> list){
  int count = 0;
  for(int i = 0; i < list.length; i++){
    if(list[i] is T){
      count++;
    }
  }
  return count;
}

  Map<DateTime, List<SessionStatistic>> groupByDate(List<SessionStatistic> sessions) {
    Map<DateTime, List<SessionStatistic>> groupedSessions = {};

    // Group sessions by date
    for (var session in sessions) {
      DateTime date = DateTime(session.date.year, session.date.month, session.date.day);
      if (!groupedSessions.containsKey(date)) {
        groupedSessions[date] = [];
      }
      groupedSessions[date]!.add(session);
    }

    return groupedSessions;
  }

List<double> sessionsGoodPosture(List<SessionStatistic> sessions) {
    List<double> result = [];
    for (var entry in sessions) {
      double value = entry.goodPosturePercentage;
      result.add((value * 100).round().toDouble());
    }
    return result;
}

  List<double> sessionsAverageGoodPosture(List<SessionStatistic> sessions) {
    var groupedSessions = groupByDate(sessions);
    List<double> result = [];
    for (var entry in groupedSessions.entries) {
      double sum = entry.value.fold(0, (previousValue, element) => previousValue + element.goodPosturePercentage);
      double average = sum / entry.value.length;

      result.add((average * 100).round().toDouble());
    }
    return result;
  }

   List<double> summedTime(List<SessionStatistic> sessions) {
    var groupedSessions = groupByDate(sessions);
    List<double> result = [];
    for (var entry in groupedSessions.entries) {
      double sum = entry.value.fold(0, (previousValue, element) => previousValue + element.sessionTime);

      result.add(sum);
    }
    return result;
  }

enum TimeValues{
  seconds,
  minutes,
  hours;

  @override
  String toString(){
    switch(this){
      case TimeValues.seconds:
        return 's';
      case TimeValues.minutes:
        return 'min';
      case TimeValues.hours:
        return 'h';
    }
  }
}

Tuple2<double,TimeValues> convertTime(double time, TimeValues currentTime){
  double convertedTime = time;
  TimeValues convertedTimeValue = currentTime;
  switch(currentTime){
    case TimeValues.seconds:
      if(time >= 60){
        convertedTime = time / 60;
        convertedTimeValue = TimeValues.minutes;
      }
      break;
    case TimeValues.minutes:
      if(time >= 60){
        convertedTime = time / 60;
        convertedTimeValue = TimeValues.hours;
      }
      break;
    case TimeValues.hours:
      if(time < 1){
        convertedTime = time * 60;
        convertedTimeValue = TimeValues.minutes;
      }
      break;
  }
  return Tuple2<double,TimeValues>(convertedTime, convertedTimeValue);
}
