import 'dart:async';
import 'dart:io';


import 'package:audioplayers/audioplayers.dart';
import 'package:esense_flutter/esense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/providers/settingsProvider.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuple/tuple.dart';

part 'eSenseManager.g.dart';

@Riverpod(keepAlive: true)
class ESenseHandler extends _$ESenseHandler{
  @override
  ESenseManager build() {
    return ESenseManager(eSenseName);
  }

  Future<void> requestForPermissions() async {
    if (!(await Permission.bluetoothScan.request().isGranted &&
        await Permission.bluetoothConnect.request().isGranted)) {
      print('WARNING - no permission to use Bluetooth granted. Cannot access eSense device.');
    }
    if (Platform.isAndroid) {
      if (!(await Permission.locationWhenInUse.request().isGranted)) {
        print('WARNING - no permission to access location granted. Cannot access eSense device.');
      }
    }
  }

Future<void> connectToESense() async {
  await requestForPermissions();

  if(!state.connected){
    await state.connect();
    await Future.delayed(Duration(seconds: 10));
    connectToESense();
  } 
}

Future<void> listenToESense() async {
  await requestForPermissions();

  state.connectionEvents.listen((event) {
    print('CONNECTION event: $event');

    if (event.type == ConnectionType.connected) {
      _listenToESenseEvents();
      startListenToSensorEvents();
    } else if (event.type == ConnectionType.unknown || (event.type == ConnectionType.disconnected && state.connected)) {
      connectToESense();
    }
  });
}

void _listenToESenseEvents() async {
  state.eSenseEvents.listen((event) {
    print('ESENSE event: $event');

    switch (event.runtimeType) {
      case ButtonEventChanged:
        // Calibrate the default posture when the button is pressed
        break;
      case AccelerometerOffsetRead:
        /* offset = Tuple3((event as AccelerometerOffsetRead).offsetX!,
              event.offsetY!, event.offsetZ!); */
        print('accelerometer offset: $event');
        break;
    }
  });

  Timer(const Duration(seconds: 2),
      () async => await state.getAccelerometerOffset());
}

Future<void> startListenToSensorEvents() async {
  print('startListenToSensorEvents');
  state.sensorEvents.listen((event) {
    print('SENSOR event: ${event.accel}');
    /* actualPosture = Tuple3(event.accel![0], event.accel![1], event.accel![2]);
    if((actualPosture.item3 - desiredPosture.item3).abs() > 500){
      //playASound();
    } */
  });
}



  void disconnect() {
    state.disconnect();
  }

  void playASound() async {
    if(!ref.watch(settingsProvider).muted){
      await AudioPlayer().play(AssetSource(warnSoundPath));
    }
  }
}