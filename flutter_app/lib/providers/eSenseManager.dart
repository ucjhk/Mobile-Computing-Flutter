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
    listenToESense();
    if (!state.connected) {
      print('Trying to connect to eSense device...');
      state.connected = await state.connect();
    }
  }

  Future<void> listenToESense() async {
    await requestForPermissions();

    state.connectionEvents.listen((event) {
      print('CONNECTION event: $event');

      // when we're connected to the eSense device, we can start listening to events from it
      if (event.type == ConnectionType.connected){
        startListenToSensorEvents();
        _listenToESenseEvents();
        state.connected = true;
      }
      else if (event.type == ConnectionType.disconnected){
        state.connected = false;
      }
      else{
        state.connected = false;
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
    var subscription = state.sensorEvents.listen((event) {
      print('SENSOR event: ${event.accel}');
      /* actualPosture = Tuple3(event.accel![0], event.accel![1], event.accel![2]);
      if((actualPosture.item3 - desiredPosture.item3).abs() > 500){
        //playASound();
      } */
    });
    print(subscription);
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


//final eSenseHandler = ChangeNotifierProvider((ref) => ESenseHandler(eSenseName));

/* class ESenseHandler extends ChangeNotifier{
  late ESenseManager _eSenseManager;
  //AudioPlayer audioPlayer = AudioPlayer();
  bool sampling = false;
  Tuple3<int, int, int> actualPosture = Tuple3(0, 0, 0);
  Tuple3<int, int, int> desiredPosture = Tuple3(0, 0, 0);
  Tuple3<int, int, int> offset = Tuple3(0, 0, 0);
  bool connected = false;
  StreamSubscription? subscription;

  ESenseHandler(String deviceName) {
    _eSenseManager = ESenseManager(deviceName);
    listenToESense();
  }

  Future<void> connectToESense() async {
    if (!connected) {
      print('Trying to connect to eSense device...');
      connected = await _eSenseManager.connect();
    }
  }

  Future<void> listenToESense() async {
    await requestForPermissions();

    _eSenseManager.connectionEvents.listen((event) {
      print('CONNECTION event: $event');

      // when we're connected to the eSense device, we can start listening to events from it
      if (event.type == ConnectionType.connected){
        _listenToESenseEvents();
        connected = true;
      }
      else if (event.type == ConnectionType.disconnected){
        sampling = false;
        connected = false;
      }
      else{
        connected = false;
      }
    });
  }

  void _listenToESenseEvents() async {
    _eSenseManager.eSenseEvents.listen((event) {
      print('ESENSE event: $event');

      switch (event.runtimeType) {
        case ButtonEventChanged:
        // Calibrate the default posture when the button is pressed
          desiredPosture = actualPosture;
          break;
        case AccelerometerOffsetRead:
          offset = Tuple3((event as AccelerometerOffsetRead).offsetX!,
              event.offsetY!, event.offsetZ!);
          print('accelerometer offset: $event');
          break;
      }
    });

    _getESenseProperties();
  }

  void _getESenseProperties() async {
    Timer(const Duration(seconds: 2),
        () async => await _eSenseManager.getAccelerometerOffset());
  }

void startListenToSensorEvents() async {
    subscription = _eSenseManager.sensorEvents.listen((event) {
      print('SENSOR event: ${event.accel}');
      actualPosture = Tuple3(event.accel![0], event.accel![1], event.accel![2]);
      if((actualPosture.item3 - desiredPosture.item3).abs() > 500){
        //playASound();
      }
    });
    sampling = true;
  }

  void pauseListenToSensorEvents() async {
    subscription?.cancel();
    sampling = false;
  }

  void disconnect() {
    pauseListenToSensorEvents();
    _eSenseManager.disconnect();
  }

  /* void playASound() async {
    await audioPlayer.play(AssetSource(warnSoundPath));
  } */
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
 */