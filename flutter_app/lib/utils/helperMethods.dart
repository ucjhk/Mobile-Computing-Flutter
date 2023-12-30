import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/components/gardenComponents.dart';
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
