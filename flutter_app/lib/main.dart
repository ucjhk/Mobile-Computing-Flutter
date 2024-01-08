import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/components/bottomNavigationBar.dart';
import 'package:flutter_app/providers/eSenseManager.dart';
import 'package:flutter_app/providers/statisticsProvider.dart';
import 'package:flutter_app/utils/storingFiles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  void dispose() async {
    await ref.watch(eSenseHandlerProvider.notifier).disconnect();
    super.dispose();
  }

  Future<void> _initialize() async {
    await readStatisticsFromFile().then((value) {
      ref.watch(statisticsProvider).initialize(value);
    });
    ref.watch(eSenseHandlerProvider.notifier).listenToESense();
    ref.watch(eSenseHandlerProvider.notifier).connectToESense();
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigation(
        (value) => setState(() {
          _currentIndex = value;
        }),
      ),
    );
  }
} 