import 'dart:async';
import 'dart:io';

import 'package:esense_flutter/esense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/bottomNavigationBar.dart';
import 'package:flutter_app/eSenseManager.dart';
import 'package:flutter_app/providers/statisticsProvider.dart';
import 'package:flutter_app/utils/storingFiles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'themes.dart';
import 'screens/home.dart';
import 'screens/statisticsPage.dart';


void main() {
  runApp(const ProviderScope(
    child: FocusGarden(),
    ),
  );
}

class FocusGarden extends StatelessWidget {
  const FocusGarden({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus Garden',
      theme: lightTheme,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends ConsumerState<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const StatisticsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await readStatisticsFromFile().then((value) {
      ref.watch(statisticsProvider).initialize(value);
    });
  }

@override
  Widget build(BuildContext context) {
    final eSense = ref.watch(eSenseHandler);
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () async {
            if (eSense.connected) {
              eSense.disconnect();
            } else {
              await eSense.connectToESense();
            }
            setState(() {});
          },
          child: Icon(eSense.connected ? Icons.bluetooth_connected : Icons.bluetooth_disabled),
        ),
        ElevatedButton(
          onPressed: () async {
            if (eSense.sampling) {
              eSense.pauseListenToSensorEvents();
            } else {
              eSense.startListenToSensorEvents();
            }
            setState(() {});
          },
          child: Icon(eSense.sampling ? Icons.pause : Icons.play_arrow),
        ),
      ],
      bottomNavigationBar: BottomNavigation(
        (value) => setState(() {
          _currentIndex = value;
        }),
      ),
    );
  }
}