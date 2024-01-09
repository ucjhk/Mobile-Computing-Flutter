import 'package:flutter/material.dart';
import 'package:flutter_app/components/customWidgets.dart';
import 'package:flutter_app/providers/statisticsProvider.dart';
import 'package:flutter_app/utils/helperMethods.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

///------------------------------------------------------------------------///
/// Statistics Page
/// displays the posture, learn time and flower record statistics 
///------------------------------------------------------------------------///

class StatisticsPage extends ConsumerWidget {
 
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statistics = ref.watch(statsProvider);

    //get the time and the right unit(s, min, h)
    Tuple2<double, TimeValues> sessionTime = convertTime(statistics.sessionTime(), TimeValues.minutes);
    Tuple2<double, TimeValues> lastSevenDaysSessionTime = convertTime(statistics.lastDaysSessionTime(7), TimeValues.minutes);
    Tuple2<double, TimeValues> lastThirtyDaysSessionTime = convertTime(statistics.lastDaysSessionTime(30), TimeValues.minutes);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Header
            Padding(padding: const EdgeInsets.only(top: 50.0), 
              child: Text('Statistics', style: Theme.of(context).textTheme.displayLarge),
            ),

            //Flower Record
            CardWidget(text: 'Flower Record', value: statistics.mostFlowers.toString()),
            const SizedBox(height: 10.0),

            //Learn Time
            CardWidget(text: 'Overall Learn Time', value: '${sessionTime.item1} ${sessionTime.item2.toString()}'),
            statistics.lastDaysSessionTimeChart(7),
            CardWidget(text: 'Last 7 Days Learn Time', value: '${lastSevenDaysSessionTime.item1} ${lastSevenDaysSessionTime.item2.toString()}'),
            CardWidget(text: 'Last 30 Days Learn Time', value: '${lastThirtyDaysSessionTime.item1} ${lastThirtyDaysSessionTime.item2.toString()}'),
            const SizedBox(height: 10.0),

            //Posture Percentage
            CardWidget(text: 'Correct Posture', value: '${statistics.posturePercentage().toStringAsFixed(2)}%'),
            statistics.lastDaysPostureChart(7),
            CardWidget(text: 'Posture Last 7 Days', value: '${statistics.lastDaysPosturePercentage(7).toStringAsFixed(2)}%'),
            CardWidget(text: 'Posture Last 30 Days', value: '${statistics.lastDaysPosturePercentage(30).toStringAsFixed(2)}%'),
          ],
        )
      ),
    );
  }
}
