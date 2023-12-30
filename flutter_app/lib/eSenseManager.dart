import 'dart:async';
import 'dart:io';

import 'package:esense_flutter/esense.dart';
import 'package:permission_handler/permission_handler.dart';


class ESenseHandler {
  late ESenseManager _eSenseManager;
  String _deviceStatus = '';
  bool sampling = false;
  String _event = '';
  String _button = 'not pressed';
  bool connected = false;
  StreamSubscription? subscription;

  ESenseHandler(String deviceName) {
    _eSenseManager = ESenseManager(deviceName);
  }

  Future<void> connectToESense() async {
    if (!connected) {
      print('Trying to connect to eSense device...');
      connected = await _eSenseManager.connect();
      _deviceStatus = connected ? 'connecting...' : 'connection failed';
    }
  }

  Future<void> listenToESense() async {
    await requestForPermissions();

    // if you want to get the connection events when connecting,
    // set up the listener BEFORE connecting...
    _eSenseManager.connectionEvents.listen((event) {
      print('CONNECTION event: $event');

      // when we're connected to the eSense device, we can start listening to events from it
      if (event.type == ConnectionType.connected) _listenToESenseEvents();
        connected = false;
        switch (event.type) {
          case ConnectionType.connected:
            _deviceStatus = 'connected';
            connected = true;
            break;
          case ConnectionType.unknown:
            _deviceStatus = 'unknown';
            break;
          case ConnectionType.disconnected:
            _deviceStatus = 'disconnected';
            sampling = false;
            break;
          case ConnectionType.device_found:
            _deviceStatus = 'device_found';
            break;
          case ConnectionType.device_not_found:
            _deviceStatus = 'device_not_found';
            break;
        }
      });
  }

  void _listenToESenseEvents() async {
    _eSenseManager.eSenseEvents.listen((event) {
      print('ESENSE event: $event');

      switch (event.runtimeType) {
        case ButtonEventChanged:
          _button = (event as ButtonEventChanged).pressed
              ? 'pressed'
              : 'not pressed';
          break;
        case AccelerometerOffsetRead:
          print('accelerometer offset: ${event as AccelerometerOffsetRead}');
          break;
        case AdvertisementAndConnectionIntervalRead:
          // TODO
          break;
        case SensorConfigRead:
          // TODO
          break;
      }
    });

    _getESenseProperties();
  }

  void _getESenseProperties() async {
    // wait 2, 3, 4, 5, ... secs before getting the name, offset, etc.
    // it seems like the eSense BTLE interface does NOT like to get called
    // several times in a row -- hence, delays are added in the following calls
    //Print the accelerometer data
    Timer(const Duration(seconds: 2),
        () async => await _eSenseManager.getAccelerometerOffset());
    Timer(
        const Duration(seconds: 4),
        () async =>
            await _eSenseManager.getAdvertisementAndConnectionInterval());
    Timer(const Duration(seconds: 15),
        () async => await _eSenseManager.getSensorConfig());
  }

void startListenToSensorEvents() async {
    // // any changes to the sampling frequency must be done BEFORE listening to sensor events
    // print('setting sampling frequency...');
    // await eSenseManager.setSamplingRate(10);

    // subscribe to sensor event from the eSense device
    subscription = _eSenseManager.sensorEvents.listen((event) {
      print('SENSOR event: $event');
      _event = event.toString();
    });
    sampling = true;
  }

  void _pauseListenToSensorEvents() async {
    subscription?.cancel();
    sampling = false;
  }

  void disconnect() {
    _pauseListenToSensorEvents();
    _eSenseManager.disconnect();
  }
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

