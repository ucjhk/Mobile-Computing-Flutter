import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/customInteractables.dart';
import 'package:flutter_app/components/customWidgets.dart';
import 'package:flutter_app/components/gardenWidget.dart';
import 'package:flutter_app/components/stopwatch.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:tuple/tuple.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePaths.backGroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          //alignment: Alignment.center,
          children: [
            LayoutBuilder(builder: (context, constraints) {
              return GardenWidget(width: constraints.maxWidth.round(), height: constraints.maxHeight.round());
            }), 
            /* const GardenWidget(
              width: Tuple2(-90, 350),
              height: Tuple2(250, 500)
              ), */
            const StopWatchWidget(),
            Container(
              padding: const EdgeInsets.all(25.0),
              alignment: Alignment.topRight,
              child: const ScaleWidget(
                child: MuteButton()
              ),
            ),
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SliderWidget(minSliderValue: 1, maxSliderValue: 1.5, divisions: 10),
            ),
          ]
        ),
      ),
    );
  }
}