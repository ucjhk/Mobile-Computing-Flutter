import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/components/gardenComponents.dart';
import 'package:flutter_app/providers/eSenseManager.dart';
import 'package:flutter_app/providers/postureProvider.dart';
import 'package:flutter_app/providers/statisticsProvider.dart';
import 'package:flutter_app/providers/stopWatchProvider.dart';
import 'package:flutter_app/utils/storingFiles.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:flutter_app/utils/helperMethods.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

class GardenWidget extends ConsumerStatefulWidget {
  final int width;
  final int height;
  const GardenWidget({super.key, required this.width, required this.height});

  @override
  ConsumerState<GardenWidget> createState() => _GardenWidgetState();
}

decreaseGardenObjects(List<GardenObjectWidget> gardenObjects, DateTime lastTime){
  int daysOver = max(0, lastTime.difference(DateTime.now()).inDays - daysUntilDispose);
  double disposeValue = daysOver * disposeMultiplier * getObjectCount<FlowerWidget>(gardenObjects);
  int disposedFlowers = 0;
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

  removeObject(int index){
    setState(() {
      gardenObjects.removeAt(index);
    });
  }

  Future<void> addObject<T extends GardenObjectWidget>() {
    double xPos = Random().nextInt(widget.width) - (widget.width * 0.15);
    double yPos = Random().nextInt((widget.height/2.5).round()) + (widget.height * 0.4);
    double distance = (yPos / widget.height);

    int insertionIndex = 0;
    for (int i = 0; i < gardenObjects.length; i++) {
      if((gardenObjects[i]).distance < distance) {
        insertionIndex++;
      }
      else {
        break;
      }
    }
    setState(() {
      gardenObjects.insert(insertionIndex, switch(T) {
        BigGarbageWidget=>BigGarbageWidget(distance: distance,position: Tuple2(xPos, yPos)),
        GarbageWidget =>GarbageWidget(distance: distance,position: Tuple2(xPos, yPos)),
        FlowerWidget=>FlowerWidget(distance: distance, position: Tuple2(xPos, yPos)),
        _=>throw Exception("Invalid type")
      });
    }); 

    final statsProvider = ref.watch(statisticsProvider);
    final flowers = getObjectCount<FlowerWidget>(gardenObjects);
    if(flowers > statsProvider.statistics.mostFlowers){
      statsProvider.setMostFlowers(getObjectCount<FlowerWidget>(gardenObjects));
    }

    return saveGardenObjectsToFile(gardenObjects);
  }

  timerChecking(){
    //Reove Garbage while good posture
    int garbageIndex = getFirstGarbageInList(gardenObjects);
    if(garbageIndex != -1){
      print('there is garbage');
      if(_garbageRemoverTimer >= (gardenObjects[garbageIndex] is BigGarbageWidget ? timeTillBigGarbageDisposal : timeTillGarbageDisposal)){
        removeObject(garbageIndex);
        _garbageRemoverTimer = 0;
      }
    }
    else{
      print('no garbage');
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
        ref.watch(eSenseHandlerProvider.notifier).playASound();
        warnSoundPlayed = true;
      }
    }
    //Add Garbage if bad posture for too long
    if(_garbageTimer >= timeTillBigGarbage){
      _garbageTimer = 0;
      addObject<BigGarbageWidget>();
    }
  }
  
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