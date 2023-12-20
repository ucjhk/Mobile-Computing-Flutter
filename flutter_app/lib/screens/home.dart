import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
          child: Container(
            //this is for testing mobile size on web
            width: kIsWeb ? 500.0 : double.infinity,
            child: const Stack(
              children: [
                GardenWidget(
                  widthArea: Tuple2(-90, 350),
                  heightArea: Tuple2(250, 500)
                  ),
                StopWatchWidget()
              ]
            ),
          ),
        )
      ),
    );
  }
}