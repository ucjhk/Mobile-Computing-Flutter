import 'dart:async';
import 'package:flutter/material.dart';
import '/utils/constants.dart';

//TODO calculate the values seconds and the states not in this page so if im changing the page the timer wont be lost
class StopwatchWidget extends StatefulWidget {
  const StopwatchWidget({Key? key}) : super(key: key);

  @override
  _StopwatchWidgetState createState() => _StopwatchWidgetState();
}

class _StopwatchWidgetState extends State<StopwatchWidget> {
  bool isRunning = false;
  int seconds = 0;
  String imagePath = goodPosture;

  void start() {
    isRunning = true;
    Future<void>.delayed(Duration(seconds: 1), () {
      if (isRunning) {
        setState(() {
          seconds++;
          start();
        });
      }
    });
  }

  void stop() {
    setState(() => isRunning = false);
  }

  void reset() {
    setState(() {
      isRunning = false;
      seconds = 0;
    });
  }

  void toggleImage() {
    setState(() {
      imagePath = imagePath == goodPosture ? badPosture : goodPosture;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stopwatch'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${(seconds ~/ 3600).toString().padLeft(2, '0')}:${((seconds % 3600) ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 48.0),
            ),
            SizedBox(height: 30.0),
            GestureDetector(
              onTap: toggleImage,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => isRunning ? stop() : start(),
                  child: Text(isRunning ? 'Stop' : 'Start'),
                ),
                SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () => reset(),
                  child: Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}