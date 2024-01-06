import 'dart:async';
import 'dart:math';

import 'package:esense_flutter/esense.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/providers/stopWatchProvider.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

final postureProvider = ChangeNotifierProvider<PostureNotifier>((ref) {
  return PostureNotifier();
});

class PostureNotifier extends ChangeNotifier {
  StreamSubscription? sensorSubscription;
  StreamSubscription? eventSubscription;
  bool isGoodPosture = true;
  Tuple3<int, int, int> angles = Tuple3(0, 0, 0);

  void toggleImage() {
    isGoodPosture = !isGoodPosture;
    notifyListeners();
  }

  calibratePosture(){
    angles = Tuple3(0, 0, 0);
  }

  Future<void> listenToSensorStream(stream) async {
    sensorSubscription = await stream.listen((event) {
      print('ESENSE sensor event: ${event.gyro}, angles: ${angles}, packet: ${(event as SensorEvent).packetIndex}');
      
      final gyro = event.gyro ?? [0, 0, 0];

      Tuple3<int,int,int> rotations = Tuple3<int,int,int>.fromList(gyro
          .map((rawRotation) => (rawRotation /
                  samplingRate /
                  pow(10, cutoff))
              .round())
          .toList());

      angles = Tuple3<int, int, int>(
        angles.item1 + rotations.item1,
        angles.item2 + rotations.item2,
        angles.item3 + rotations.item3,
      );
      if (angles.item3 > angelThreshold && isGoodPosture 
      || (angles.item3 <= angelThreshold && !isGoodPosture)) {
        print('posture: ${!isGoodPosture}');
        toggleImage();
      }
    });
  }

  Future<void> listenToEventStream(stream) async {
    eventSubscription = stream.listen((event) {
    print('ESENSE event: $event');

    switch (event.runtimeType) {
      case ButtonEventChanged:
        // Calibrate the default posture when the button is pressed
        if((event as ButtonEventChanged).pressed){
          calibratePosture();
        }
        break;
    }
  });
  }

  Future<void> cancelStreams() async {
    await sensorSubscription?.cancel();
    await eventSubscription?.cancel();
  }

  reTryStream(stream) async {
    await listenToSensorStream(stream);
    await Future.delayed(Duration(seconds: 3));
    await sensorSubscription?.cancel();
    await Future.delayed(Duration(seconds: 3));
    await listenToSensorStream(stream);
  }
}