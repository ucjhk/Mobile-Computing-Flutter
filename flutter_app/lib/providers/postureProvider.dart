import 'dart:async';

import 'package:esense_flutter/esense.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

///------------------------------------------------------------------------///
/// Posture Provider
/// provides the current posture of the user based on the eSense streams
///------------------------------------------------------------------------///

final postureProvider = ChangeNotifierProvider<PostureNotifier>((ref) {
  return PostureNotifier();
});

class PostureNotifier extends ChangeNotifier {
  StreamSubscription? sensorSubscription;
  StreamSubscription? eventSubscription;
  bool isGoodPosture = true;
  Tuple3<num, num, num> angles = const Tuple3(0, 0, 0);
  
  void toggleImage() {
    isGoodPosture = !isGoodPosture;
    notifyListeners();
  }

  calibratePosture(){
    angles = const Tuple3(0, 0, 0);
  }

  Future<void> listenToSensorStream(stream) async {
    sensorSubscription = await stream.listen((event) {
            
      final gyro = event.gyro ?? [0, 0, 0];
      
      /*-------------------------------------------------------------
      Adds the rotation from the gyro on the current position
      and filter lower numbers out to not detect moving
      while not actually moving
      ---------------------------------------------------------------*/
      Tuple3<num,num,num> rotations = Tuple3<num,num,num>.fromList(gyro
          .map((rawRotation){ 
            num rotation = rawRotation / samplingRate / 100;
            return (rotation.abs() < 0.5) ? 0 : rotation;
              })
          .toList());

      angles = Tuple3<num, num, num>(
        angles.item1 + rotations.item1,
        angles.item2 + rotations.item2,
        angles.item3 + rotations.item3,
      );
      //if z-axis is over the treshold or under change the posture
      if (angles.item3 > angelThreshold && isGoodPosture 
      || (angles.item3 <= angelThreshold && !isGoodPosture)) {
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
    await cancelSensorStream();
    await cancelEventStream();
  }
  
  Future<void> cancelSensorStream() async {
    return await sensorSubscription?.cancel();
  }

  Future<void> cancelEventStream() async {
    return await eventSubscription?.cancel();
  }

//retryConnecting works better for me as I tested just one time seems inconsistent
reTryStream(stream) async {
    await listenToSensorStream(stream);
    await Future.delayed(const Duration(seconds: 3));
    await sensorSubscription?.cancel();
    await Future.delayed(const Duration(seconds: 3));
    await listenToSensorStream(stream);
  }
}