import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/classes/gardenComponents.dart';
import 'package:flutter_app/providers/eSenseManager.dart';
import 'package:flutter_app/providers/postureProvider.dart';
import 'package:flutter_app/providers/statisticsProvider.dart';
import 'package:flutter_app/providers/stopWatchProvider.dart';
import 'package:flutter_app/utils/storingFiles.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:flutter_app/utils/helperMethods.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

///------------------------------------------------------------------------///
/// Garden Widget that displays the GardenObjects
/// and stacks them based on their distance above each other
///------------------------------------------------------------------------///

//Gets the height and width of the Garden
class GardenWidget extends ConsumerStatefulWidget {
  final int width;
  final int height;
  const GardenWidget({super.key, required this.width, required this.height});

  @override
  ConsumerState<GardenWidget> createState() => _GardenWidgetState();
}

//Method to decrease the flower count based on the last Time the app was used
List<GardenObjectWidget> decreaseGardenObjects(List<GardenObjectWidget> gardenObjects, DateTime lastTime){
  //how many days passed
  int daysOver = max(0, lastTime.difference(DateTime.now()).inDays - daysUntilDispose);
  //numbers of flowers that will be disposed
  double disposeValue = daysOver * disposeMultiplier * getObjectCount<FlowerWidget>(gardenObjects);
  int disposedFlowers = 0;
  //dispose Flowers
  for(GardenObjectWidget object in gardenObjects){
    if(object is FlowerWidget){
      disposedFlowers++;
      gardenObjects.remove(object);
    }
    if(disposedFlowers >= disposeValue){
      break;
    }
  }
  return gardenObjects;
}


class _GardenWidgetState extends ConsumerState<GardenWidget> {
  List<GardenObjectWidget> gardenObjects = [];
  int _flowerTimer = 0;
  int _garbageRemoverTimer = 0;
  int _garbageTimer = 0;
  bool warnSoundPlayed = false;

  //load the gardenObjectWidgets from the file and decrease them
  @override
  void initState() {
    super.initState();
    readGardenObjectsFromFile().then((objects) {
      readStatisticsFromFile().then((statistics) {
        setState(() {
          gardenObjects = decreaseGardenObjects(objects, statistics.lastTime);
      });
      });
    });
  } 

  Future<void> removeObject(int index){
    setState(() {
      gardenObjects.removeAt(index);
    });
    return saveGardenObjectsToFile(gardenObjects);
  }

  //takes the type of Object that should be added
  Future<void> addObject<T extends GardenObjectWidget>() {
    //Random position in the Garden
    double xPos = Random().nextInt(widget.width) - (widget.width * 0.15);
    //Only in the lower half of the screen
    double yPos = Random().nextInt((widget.height/2.5).round()) + (widget.height * 0.4);
    //calculate the distance for the size
    double distance = (yPos / widget.height);

    setState(() {
      insertInRightPlace(switch(T) {
        BigGarbageWidget=>BigGarbageWidget(distance: distance,position: Tuple2(xPos, yPos)),
        GarbageWidget =>GarbageWidget(distance: distance,position: Tuple2(xPos, yPos)),
        FlowerWidget=>FlowerWidget(distance: distance, position: Tuple2(xPos, yPos)),
        _=>throw Exception("Invalid type")}, gardenObjects);
    }); 

    //update the mostFlowers 
    final statistics = ref.read(statsProvider);
    final statsNotifier = ref.read(statsProvider.notifier);
    final flowers = getObjectCount<FlowerWidget>(gardenObjects);
    if(flowers > (statistics.mostFlowers)){
      statsNotifier.setMostFlowers(flowers);
    }
    //save the gardenObjects to the file
    return saveGardenObjectsToFile(gardenObjects);
  }

  /*-------------------------------------------------------------
    Add and delete Objects based on the timers
    and change the timers based on the position
  ---------------------------------------------------------------*/

  timerChecking(){
    //Remove garbage if existing and garbageremoverTimer is high enough
    int garbageIndex = getFirstGarbageInList(gardenObjects);
    if(garbageIndex != -1){
      if(_garbageRemoverTimer >= (gardenObjects[garbageIndex] is BigGarbageWidget ? timeTillBigGarbageDisposal : timeTillGarbageDisposal)){
        removeObject(garbageIndex);
        _garbageRemoverTimer = 0;
      }
    }
    else{
      _garbageRemoverTimer = 0;
    }

    //Add Flowers (Slower Growing if more Garbage)
    if(_flowerTimer >= (timeTillFlower + timeTillFlower * 
    (getObjectCount<GarbageWidget>(gardenObjects) * garbageMultiplier + 
    getObjectCount<BigGarbageWidget>(gardenObjects) * bigGarbageMultiplier))){
      _flowerTimer = 0;
      addObject<FlowerWidget>();
    }

    //Warning Signal 
    if(_garbageTimer >= timeTillWarning){
      if(!warnSoundPlayed){
        ref.watch(eSenseHandlerProvider.notifier).playASound(warnSoundPath);
        warnSoundPlayed = true;
      }
    }

    //Add Garbage if bad posture for too long
    if(_garbageTimer >= timeTillBigGarbage){
      _garbageTimer = 0;
      addObject<BigGarbageWidget>();
    }
  }
  
  //Change Timers based on posture
  changeTimers(bool isGoodPosture){
    if(isGoodPosture){
      setState(() {
        _flowerTimer++;
        _garbageRemoverTimer++;
      });
      warnSoundPlayed = false;

      if(_garbageTimer >= timeTillGarbage){
        addObject<GarbageWidget>();
      }
      _garbageTimer = 0;
    }
    else{
      setState(() {
        _garbageTimer++;
      });
    }
  }

  
  @override
  Widget build(BuildContext context) {
    final posture = ref.read(postureProvider);
    final stopwatch = ref.watch(stopWatchProvider);

    if(stopwatch.isRunning && stopwatch.sessionActive){
      changeTimers(posture.isGoodPosture);
      timerChecking();
    }
    
    return Stack(
      children: gardenObjects,
    );
  }
}