import 'package:flutter/material.dart';
import 'package:flutter_app/components/gardenComponents.dart';

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
