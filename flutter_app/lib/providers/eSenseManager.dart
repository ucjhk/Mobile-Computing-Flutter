import 'dart:async';
import 'dart:io';


import 'package:audioplayers/audioplayers.dart';
import 'package:esense_flutter/esense.dart';
import 'package:flutter_app/providers/postureProvider.dart';
import 'package:flutter_app/providers/settingsProvider.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

  if(!state.connected){
    await state.connect();
    await Future.delayed(const Duration(seconds: 10));
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

    } else if (event.type == ConnectionType.disconnected && !state.connected) {
      connectToESense();
    }
  });
}

void _listenToESenseEvents() async {
  ref.watch(postureProvider).listenToEventStream(state.eSenseEvents);

  Timer(const Duration(seconds: 2),
      () async => await state.getAccelerometerOffset());
}
 
void startListenToSensorEvents() async {
  await state.setSamplingRate(samplingRate);
  print('startListenToSensorEvents');
  ref.watch(postureProvider).reTryStream(state.sensorEvents);
}

  Future<void> disconnect() async {
    await ref.watch(postureProvider).cancelStreams();
    state.disconnect();
  }

  void playASound() async {
    if(!ref.watch(settingsProvider).muted){
      await AudioPlayer().play(AssetSource(warnSoundPath));
    }
  }
}