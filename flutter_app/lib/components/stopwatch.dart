import 'package:flutter/material.dart';
import 'package:flutter_app/components/customInteractables.dart';
import 'package:flutter_app/components/postureWidget.dart';
import 'package:flutter_app/providers/stopWatchProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StopWatchWidget extends ConsumerWidget {
  const StopWatchWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stopWatch = ref.watch(stopWatchProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '${(stopWatch.seconds ~/ 3600).toString().padLeft(2, '0')}:${((stopWatch.seconds % 3600) ~/ 60).toString().padLeft(2, '0')}:${(stopWatch.seconds % 60).toString().padLeft(2, '0')}',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: 20.0),
        stopWatch.isRunning ? PostureWidget() : const Column(
          children: [
            SizedBox(height: 20.0),
            NumberPicker(name: "Session Time", initialValue: 40, steps: 1),
            NumberPicker(name: "Pause Time", initialValue: 5, steps: 1),
          ]
        ),
        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => stopWatch.isRunning ? stopWatch.stop() : stopWatch.start(),
              child: Text(stopWatch.isRunning ? 'Stop' : 'Start'),
            ),
            const SizedBox(width: 20.0),
            ElevatedButton(
              onPressed: () => stopWatch.reset(),
              child: const Text('Reset'),
            ),
          ],
        ),
      ],
    );
  }
}
