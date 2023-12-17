import 'package:flutter/material.dart';
import 'package:flutter_app/components/customInteractables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage>{
  int _sessionTime = 3000;
  int _pauseTime = 600;
  bool _trackSession = true;
  //bool _pauseWhileSpeaking = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }


  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _sessionTime = prefs.getInt('sessionTime') ?? _sessionTime;
      _pauseTime = prefs.getInt('pauseTime') ?? _pauseTime;
      _trackSession = prefs.getBool('trackSession') ?? _trackSession;
    });
  }

  Future<void> _changeSessionTime(int value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _sessionTime = value;
      prefs.setInt('sessionTime', value);
    });
  }

  Future<void> _changePauseTime(int value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pauseTime = value;
      prefs.setInt('pauseTime', value);
    });
  }

  Future<void> _toggleTrackSession() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _trackSession = !_trackSession;
      prefs.setBool('trackSession', _trackSession);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Column(children: [
          Row(
            children: <Widget>[
              NumberPicker(initialValue: 10, steps: 5)
            ],
          ),
        ]),
      ),
    );
  }
}
