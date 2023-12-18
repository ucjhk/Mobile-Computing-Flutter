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

class _GardenWidgetState extends ConsumerState<GardenWidget> {
  List<Widget> _gardenObjects = []; 

  addObject(GardenObjectWidget object) {
    print(object);
    int xLength = widget.widthArea.item2 - widget.widthArea.item1;
    int yLength = widget.heightArea.item2 - widget.heightArea.item1;
    int xPos = Random().nextInt(xLength) + widget.widthArea.item1;
    int yPos = Random().nextInt(yLength) + widget.heightArea.item1;
    double distance = ((yPos - widget.heightArea.item1) / yLength) + 0.25;

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
      _gardenObjects.insert(insertionIndex,
        object(
          distance: distance,
          position: Tuple2(xPos.toDouble(), yPos.toDouble())
        )
      );
    }); 
  }
  @override
  Widget build(BuildContext context) {
    final stopwatch = ref.watch(stopWatchProvider);
    final posture = ref.watch(postureProvider);
    if (stopwatch.seconds % 3 == 0 && stopwatch.seconds != 0 && stopwatch.isRunning) {
      //TODO Linus fragen wie am Besten mit Vererbung regeln
      addObject(FlowerWidget);
    }
    return Stack(
      children: _gardenObjects,
    );
  }
}