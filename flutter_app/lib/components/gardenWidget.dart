import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/components/gardenComponents.dart';
import 'package:flutter_app/providers/postureProvider.dart';
import 'package:flutter_app/providers/stopWatchProvider.dart';
import 'package:flutter_app/storingFiles.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:flutter_app/utils/helperMethods.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

class GardenWidget extends ConsumerStatefulWidget {
  final Tuple2<int, int> widthArea;
  final Tuple2<int, int> heightArea;
  const GardenWidget({super.key, required this.widthArea, required this.heightArea});

  @override
  ConsumerState<GardenWidget> createState() => _GardenWidgetState();
}


enum ObjectTimer{
  garbageTimer,
  garbageRemoverTimer,
  flowerTimer
}

class _GardenWidgetState extends ConsumerState<GardenWidget> {
  List<GardenObjectWidget> _gardenObjects = [];
  int _flowerTimer = 0;
  int _garbageRemoverTimer = 0;
  int _garbageTimer = 0;

/*   @override
  void initState() {
    super.initState();
    readFromFile().then((value) {
      setState(() {
        _gardenObjects = value;
      });
    });
  } */


  setTimer(ObjectTimer timer, int value){
    setState(() {
      switch(timer){
      case ObjectTimer.garbageTimer:
        _garbageTimer = value;
        break;
      case ObjectTimer.garbageRemoverTimer:
        _garbageRemoverTimer = value;
        break;
      case ObjectTimer.flowerTimer:
        _flowerTimer = value;
        break;
    }
    });
  }

  timerChecking(){
    //Reove Garbage while good posture
    int garbageIndex = getFirstGarbageInList(_gardenObjects);
    if(garbageIndex != -1){
      if(_garbageRemoverTimer >= (_gardenObjects[garbageIndex] is BigGarbageWidget ? timeTillBigGarbageDisposal : timeTillGarbageDisposal)){
        removeObject(garbageIndex);
        setTimer(ObjectTimer.garbageRemoverTimer, 0);
      }
    }
    else{
      setTimer(ObjectTimer.garbageRemoverTimer, 0);
    }
    //Add Flowers (Slower Growing if more Garbage)
    if(_flowerTimer >= (timeTillFlower + timeTillFlower * 
    (getObjectCount<GarbageWidget>(_gardenObjects) * garbageMultiplier + 
    getObjectCount<BigGarbageWidget>(_gardenObjects) * bigGarbageMultiplier))){
      setTimer(ObjectTimer.flowerTimer, 0);
      addObject<FlowerWidget>();
    }
    //Warning Signal
    if(_garbageTimer >= timeTillWarning){
      //TODO warningsignal and screenshaking maybe pulse red
    }
    //Add Garbage if bad posture for too long
    if(_garbageTimer >= timeTillBigGarbage){
      setTimer(ObjectTimer.garbageTimer, 0);
      addObject<BigGarbageWidget>();
    }
  }
  
  changeTimers(){
    final posture = ref.watch(postureProvider);
    if(posture.isGoodPosture){
      setState(() {
        _flowerTimer++;
        _garbageRemoverTimer++;
      });

      if(_garbageTimer >= timeTillGarbage){
        addObject<GarbageWidget>();
      }
      setTimer(ObjectTimer.garbageTimer, 0);
    }
    else{
      setState(() {
        _garbageTimer++;
      });
    }
  }

  removeObject(int index){
    setState(() {
      _gardenObjects.removeAt(index);
    });
  }

  //Future<void>
  addObject<T extends GardenObjectWidget>() {
    int xLength = widget.widthArea.item2 - widget.widthArea.item1;
    int yLength = widget.heightArea.item2 - widget.heightArea.item1;
    int xPos = Random().nextInt(xLength) + widget.widthArea.item1;
    int yPos = Random().nextInt(yLength) + widget.heightArea.item1;
    double distance = ((yPos - widget.heightArea.item1) / yLength);

    int insertionIndex = 0;
    for (int i = 0; i < _gardenObjects.length; i++) {
      if((_gardenObjects[i]).distance < distance) {
        insertionIndex++;
      }
      else {
        break;
      }
    }
    setState(() {
      _gardenObjects.insert(insertionIndex, switch(T) {
        BigGarbageWidget=>BigGarbageWidget(distance: distance,position: Tuple2(xPos.toDouble(), yPos.toDouble())),
        GarbageWidget =>GarbageWidget(distance: distance,position: Tuple2(xPos.toDouble(), yPos.toDouble())),
        FlowerWidget=>FlowerWidget(distance: distance, position: Tuple2(xPos.toDouble(), yPos.toDouble())),
        _=>throw Exception("Invalid type")
      });
    }); 

    //return saveToFile(_gardenObjects);
  }


  @override
  Widget build(BuildContext context) {
    final stopwatch = ref.watch(stopWatchProvider);

    if(stopwatch.isRunning){
      changeTimers();
      timerChecking();
    }
    
    return Stack(
      children: _gardenObjects,
    );
  }
}