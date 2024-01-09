import 'package:flutter/material.dart';

///------------------------------------------------------------------------///
/// Custom Navigationbar that returns an index when taped
/// switch between the Start page and the Statistics page
///------------------------------------------------------------------------///

class BottomNavigation extends StatefulWidget {
  final ValueChanged<int>? onTap;

  const BottomNavigation(this.onTap);
  @override
  BottomNavigationState createState() => BottomNavigationState();
}

class BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      widget.onTap?.call(_currentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onTabTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart),
          label: 'Statistics',
        ),
      ],
    );
  }
}
