
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/components/gardenComponents.dart';
import 'package:flutter_app/providers/postureProvider.dart';
import 'package:flutter_app/providers/stopWatchProvider.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

class GardenWidget extends ConsumerStatefulWidget {
  final Tuple2<int, int> widthArea;
  final Tuple2<int, int> heightArea;
  const GardenWidget({super.key, required this.widthArea, required this.heightArea});

  @override
  ConsumerState<GardenWidget> createState() => _GardenWidgetState();
}

int getFirstGarbageInList(List<Widget> list){
  for(int i = 0; i < list.length; i++){
    if(list[i] is GarbageWidget || list[i] is BigGarbageWidget){
      return i;
    }
  }
  return -1;
}

class _GardenWidgetState extends ConsumerState<GardenWidget> {
  final List<Widget> _gardenObjects = [];
  int _goodPostureTimer = 0;
  int _badPostureTimer = 0;

  addObject<T extends GardenObjectWidget>() {
    int xLength = widget.widthArea.item2 - widget.widthArea.item1;
    int yLength = widget.heightArea.item2 - widget.heightArea.item1;
    int xPos = Random().nextInt(xLength) + widget.widthArea.item1;
    int yPos = Random().nextInt(yLength) + widget.heightArea.item1;
    double distance = ((yPos - widget.heightArea.item1) / yLength);

    int insertionIndex = 0;
    for (int i = 0; i < _gardenObjects.length; i++) {
      if((_gardenObjects[i] as GardenObjectWidget).distance < distance) {
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
  }
  @override
  Widget build(BuildContext context) {
    final stopwatch = ref.watch(stopWatchProvider);
    final posture = ref.watch(postureProvider);
    if(stopwatch.isRunning){
      if(posture.isGoodPosture){
        _goodPostureTimer++;

        if(_badPostureTimer >= timeTillBigGarbage){
          addObject<BigGarbageWidget>();
        }
        else if(_badPostureTimer >= timeTillGarbage){
          addObject<GarbageWidget>();
        }

        _badPostureTimer = 0;
      }
      else{
        _badPostureTimer++;
      }

      if(_goodPostureTimer >= timeTillFlower){
        int garbageIndex = getFirstGarbageInList(_gardenObjects);
        if(garbageIndex != -1){
          if(timeTillFlower >= (_gardenObjects[garbageIndex] is BigGarbageWidget ? timeTillBigGarbageDisposal : timeTillGarbageDisposal)){
            _goodPostureTimer = 0;
            _gardenObjects.removeAt(garbageIndex);
          }
        }
        else{
          _goodPostureTimer = 0;
          addObject<FlowerWidget>();
        }
      }
      if(_badPostureTimer >= timeTillWarning){
        //TODO warningsignal and screenshaking maybe pulse red
      }
      if(_badPostureTimer >= timeTillBigGarbage){
        _badPostureTimer = 0;
        addObject<BigGarbageWidget>();
      }
    }
    
    return Stack(
      children: _gardenObjects,
    );
  }
}