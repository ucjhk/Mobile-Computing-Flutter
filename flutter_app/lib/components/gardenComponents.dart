import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
enum GardenObjectType {
  flower,
  smallGarbage,
  bigGarbage
}

class GardenObject extends StatelessWidget {
  final GardenObjectType type;
  final String imagePath;
  final double distance;
  final Tuple2<double, double> position;

  const GardenObject({super.key, required this.imagePath, required this.type, this.distance = 1, required this.position});
  @override
  Widget build(BuildContext context) {
    print("${position.item1}, ${position.item2}");
    return Positioned(
      left: position.item1,
      top: position.item2,
      child: Image(
        height: 200 * distance,
        width: 200 * distance,
        fit: BoxFit.contain,
        image: AssetImage(imagePath)
      )
    );
  }
}