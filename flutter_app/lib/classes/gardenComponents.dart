import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:tuple/tuple.dart';

///------------------------------------------------------------------------///
/// GardenObjects that will be put in the GardenWidget
///------------------------------------------------------------------------///

class GardenObjectWidget extends StatelessWidget {
  //image Path
  final String imagePath;
  //For scaling the widget based on the GardenWidget height
  final double distance;
  //actual position on the screen
  final Tuple2<double, double> position;

  const GardenObjectWidget({super.key, this.imagePath ='', this.distance = 1, required this.position});

  Map<String, dynamic> toJson() {
    return {
      'imagePath': imagePath,
      'distance': distance,
      'position': {'x': position.item1, 'y': position.item2},
    };
  }

  factory GardenObjectWidget.fromJson(Map<String, dynamic> json) {
    return GardenObjectWidget(
      imagePath: json['imagePath'],
      distance: json['distance'],
      position: Tuple2(json['position']['x'], json['position']['y']),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.item1,
      top: position.item2,
      child: Image(
        height: 400 * (distance -0.15),
        width: 400 * (distance -0.15),
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
          position: position,
          imagePath: ImagePaths.garbageImages[Random().nextInt(ImagePaths.garbageImages.length)],
        );
  factory GarbageWidget.fromJson(Map<String, dynamic> json) {
    return GarbageWidget(
      distance: json['distance'],
      position: Tuple2(json['position']['x'], json['position']['y']),
    );
  }
        
}

class BigGarbageWidget extends GardenObjectWidget {
  BigGarbageWidget({super.key, required double distance, required Tuple2<double, double> position})
      : super(
          distance: distance,
          position: position,
          imagePath: ImagePaths.bigGarbageImages[Random().nextInt(ImagePaths.bigGarbageImages.length)],
        );
      factory BigGarbageWidget.fromJson(Map<String, dynamic> json) {
    return BigGarbageWidget(
      distance: json['distance'],
      position: Tuple2(json['position']['x'], json['position']['y']),
    );
  }
}

class FlowerWidget extends GardenObjectWidget {
  FlowerWidget({super.key, required double distance, required Tuple2<double, double> position})
      : super(
          distance: distance,
          position: position,
          imagePath: ImagePaths.flowerImages[Random().nextInt(ImagePaths.flowerImages.length)],
        );
        factory FlowerWidget.fromJson(Map<String, dynamic> json) {
    return FlowerWidget(
      distance: json['distance'],
      position: Tuple2(json['position']['x'], json['position']['y']),
    );
  }
}