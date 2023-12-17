import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/postureWidget.dart';
import 'package:flutter_app/providers/stopWatchProvider.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backGroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            //this is for testing mobile size on web
            width: kIsWeb ? 400.0 : double.infinity,
            child: const Stack(
              children: [
                StopWatchWidget(),
                
              ]
            ),
          ),
        )
      ),
    );
  }
}

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
          style: const TextStyle(fontSize: 48.0),
        ),
        const SizedBox(height: 30.0),
        const PostureWidget(),
        const SizedBox(height: 40.0),
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
