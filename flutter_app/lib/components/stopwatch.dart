import 'package:flutter/material.dart';
import 'package:flutter_app/components/customInteractables.dart';
import 'package:flutter_app/components/customWidgets.dart';
import 'package:flutter_app/components/postureWidget.dart';
import 'package:flutter_app/providers/statisticsProvider.dart';
import 'package:flutter_app/providers/stopWatchProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

///------------------------------------------------------------------------///
/// StopWatch Widget
/// Displays the current time
/// Start, Stop, Reset button
/// And displays based on the stopwatch state 
/// the NumberPickers, PostureWidget, Statistics from the last 5 sessions
///------------------------------------------------------------------------///

class StopWatchWidget extends ConsumerWidget {
  const StopWatchWidget({super.key});

  Widget displayWidget(BuildContext context, WidgetRef ref){
    final stopWatch = ref.watch(stopWatchProvider);
    final stopWatchNotifier = ref.watch(stopWatchProvider.notifier);
    //in the session state
    if(stopWatch.sessionActive){
      //running
      if(stopWatch.isRunning){
        return const PostureWidget();
      } 
      //paused
      else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NumberPicker(name: "Session Time", initialValue: stopWatch.session, steps: 5, range: const Tuple2(1, 999), onChanged: (value) => stopWatchNotifier.setSession(value)),
            NumberPicker(name: "Pause Time", initialValue: stopWatch.pause, steps: 1, range: const Tuple2(1, 999), onChanged: (value) => stopWatchNotifier.setPause(value)),
          ]
        );
      }
    } 
    //in the pauseSession state
    else {
      return Container(
        alignment: Alignment.center,
        child: Card(child: ref.watch(statsProvider).thisDaysPostureChart()),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stopWatchNotifier = ref.watch(stopWatchProvider.notifier);
    final stopWatch = ref.watch(stopWatchProvider);

    return ScaleWidget(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          //Time
          Text(
            '${(stopWatch.seconds ~/ 3600).toString().padLeft(2, '0')}:${((stopWatch.seconds % 3600) ~/ 60).toString().padLeft(2, '0')}:${(stopWatch.seconds % 60).toString().padLeft(2, '0')}',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 10.0),

          //Middle Widget based on the stopwatch state
          SizedBox(
            height: 150.0,
            child: displayWidget(context, ref)
          ),
          const SizedBox(height: 20.0),

          //Start, Stop, Reset buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => stopWatch.isRunning ? {stopWatchNotifier.stop()} : {stopWatchNotifier.start()},
                child: Text(stopWatch.isRunning ? 'Stop' : 'Start'),
              ),
              const SizedBox(width: 20.0),
              ElevatedButton(
                onPressed: () => stopWatchNotifier.reset(),
                child: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
