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

///------------------------------------------------------------------------///
/// Provider for the Esense Earables 
/// can connect, listen, disconnect and play a sound
///------------------------------------------------------------------------///

@Riverpod(keepAlive: true)
class ESenseHandler extends _$ESenseHandler{

  @override
  ESenseManager build() {
    return ESenseManager(eSenseName);
  }

  Future<void> requestForPermissions() async {
    await Permission.bluetoothConnect.request();
    await Permission.bluetoothScan.request();
    if (Platform.isAndroid) {
      await Permission.locationWhenInUse.request();
    }
  }

  //Trys so long till the eSense are connected
  Future<void> connectToESense() async {
    if(!state.connected){
      await state.connect();
      await Future.delayed(const Duration(seconds: 10));
      connectToESense();
    } 
  }

  //Listens to the connection events and starts listening to the other events when connected
  Future<void> listenToESense() async {
    await requestForPermissions();

    state.connectionEvents.listen((event) {
      print('CONNECTION event: $event');

      if (event.type == ConnectionType.connected) {
        _listenToESenseEvents();
        startListenToSensorEvents();
      }
    });
  }

  //gives the eSenseEvents to the posture provider
  void _listenToESenseEvents() async {
    ref.watch(postureProvider).listenToEventStream(state.eSenseEvents);

    Timer(const Duration(seconds: 2),
        () async => await state.getAccelerometerOffset());
  }

  //gives the sensor events to the posture provider
  void startListenToSensorEvents() async {
    await state.setSamplingRate(samplingRate);
    ref.watch(postureProvider).reTryStream(state.sensorEvents);
  }

  //disconnect the eSense
  Future<void> disconnect() async {
    await ref.watch(postureProvider).cancelStreams();
    state.disconnect();
  }

  //play a sound
  void playASound(sound) async {
    if(!ref.watch(settingsProvider).muted){
      await AudioPlayer().play(AssetSource(sound));
    }
  }
}