import 'package:flutter/material.dart';
import 'package:flutter_app/classes/gardenComponents.dart';
import 'package:flutter_app/classes/statistics.dart';
import 'package:tuple/tuple.dart';

///------------------------------------------------------------------------///
/// Garden Helper Functions
///------------------------------------------------------------------------///

//gets the first garbage widget in the list
int getFirstGarbageInList(List<Widget> list){
  for(int i = 0; i < list.length; i++){
    if(list[i] is GarbageWidget || list[i] is BigGarbageWidget){
      return i;
    }
  }
  return -1;
}

//gets the number of specific objects in the list
int getObjectCount<T extends Widget>(List<Widget> list){
  int count = 0;
  for(int i = 0; i < list.length; i++){
    if(list[i] is T){
      count++;
    }
  }
  return count;
}

//stores in right place
void insertInRightPlace(object, list){
  int insertionIndex = 0;
    for (int i = 0; i < list.length; i++) {
      if((list[i]).distance < object.distance) {
        insertionIndex++;
      }
      else {
        break;
      }
    }
    list.insert(insertionIndex,object);
}

///------------------------------------------------------------------------///
/// Statistics Helper Functions
///------------------------------------------------------------------------///

//gets the first few elements in the list
List<double> getFirstFewElementsInList(List<double> list, int number){
  List<double> result = [];

  for (var i = list.length - 1; i >= 0; i--) {
    result.add(list[i]);
    if(result.length >= number){
      break;
    }
  }
  return result;
}

//group the sessions by the date 
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

///------------------------------------------------------------------------///
/// Time Converter Functions
///------------------------------------------------------------------------///

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

//convert the time to the next best if possible
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
