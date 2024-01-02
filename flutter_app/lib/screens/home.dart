import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/customInteractables.dart';
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
        child: Center(
          child: Stack(
            children: [
              const GardenWidget(
                widthArea: Tuple2(-90, 350),
                heightArea: Tuple2(250, 500)
                ),
              const StopWatchWidget(),
              Container(
                padding: const EdgeInsets.all(15.0),
                alignment: Alignment.topRight,
                child: const MuteButton()
              ),
            ]
          ),
        ),
      )
    );
  }
}