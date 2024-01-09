import 'package:flutter/material.dart';
import 'package:flutter_app/components/customInteractables.dart';
import 'package:flutter_app/components/customWidgets.dart';
import 'package:flutter_app/components/gardenWidget.dart';
import 'package:flutter_app/components/stopwatch.dart';
import 'package:flutter_app/utils/constants.dart';

///------------------------------------------------------------------------///
/// StartPage
/// displays the Garden, StopWatch, Settings in a Stack over each other
///------------------------------------------------------------------------///

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        //Background
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePaths.backGroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [

            //Garden Widget
            LayoutBuilder(builder: (context, constraints) {
              return GardenWidget(width: constraints.maxWidth.round(), height: constraints.maxHeight.round());
            }),

            //Stop Watch 
            const StopWatchWidget(),

            //Setting Widgets
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