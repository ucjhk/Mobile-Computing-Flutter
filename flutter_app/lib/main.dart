import 'package:flutter/material.dart';
import 'package:flutter_app/components/bottomNavigationBar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'themes.dart';
import 'screens/home.dart';
import 'screens/history.dart';
import 'screens/settings.dart';


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
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    HistoryPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigation((value) => setState(() { _currentIndex = value;}),)
    );
  }
}
