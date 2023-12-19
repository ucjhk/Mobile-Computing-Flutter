import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:tuple/tuple.dart';

class GardenObjectWidget extends StatelessWidget {
  final String imagePath;
  final int credits;
  final double distance;
  final Tuple2<double, double> position;

  const GardenObjectWidget({super.key, required this.imagePath, required this.credits, this.distance = 1, required this.position});

  @override
  Widget build(BuildContext context) {
    print("${position.item1}, ${position.item2}");
    return Positioned(
      left: position.item1,
      top: position.item2,
      child: Image(
        height: 50 + 200 * distance,
        width: 50 + 200 * distance,
        fit: BoxFit.contain,
        image: AssetImage(imagePath)
      )
    );
  }
}

class GarbageWidget extends GardenObjectWidget {
  GarbageWidget({super.key, required double distance, required Tuple2<double, double> position})
      : super(
          distance: distance,
          credits: -1,
          position: position,
          imagePath: ImagePaths.garbageImages[Random().nextInt(ImagePaths.garbageImages.length)],
        );
}

class BigGarbageWidget extends GardenObjectWidget {
  BigGarbageWidget({super.key, required double distance, required Tuple2<double, double> position})
      : super(
          distance: distance,
          credits: -5,
          position: position,
          imagePath: ImagePaths.bigGarbageImages[Random().nextInt(ImagePaths.bigGarbageImages.length)],
        );
}

class FlowerWidget extends GardenObjectWidget {
  FlowerWidget({super.key, required double distance, required Tuple2<double, double> position})
      : super(
          distance: distance,
          credits: 1,
          position: position,
          imagePath: ImagePaths.flowerImages[Random().nextInt(ImagePaths.flowerImages.length)],
        );
}