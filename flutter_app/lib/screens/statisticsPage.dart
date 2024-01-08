import 'package:flutter/material.dart';
import 'package:flutter_app/components/customWidgets.dart';
import 'package:flutter_app/providers/statisticsProvider.dart';
import 'package:flutter_app/classes/statistics.dart';
import 'package:flutter_app/utils/helperMethods.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

class StatisticsPage extends ConsumerWidget {
 
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statisticsWatcher = ref.watch(statisticsProvider);
    final statistics = statisticsWatcher.statistics;

    Tuple2<double, TimeValues> sessionTime = convertTime(statistics.sessionTime(), TimeValues.minutes);
    Tuple2<double, TimeValues> lastSevenDaysSessionTime = convertTime(statistics.lastDaysSessionTime(7), TimeValues.minutes);
    Tuple2<double, TimeValues> lastThirtyDaysSessionTime = convertTime(statistics.lastDaysSessionTime(30), TimeValues.minutes);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(padding: const EdgeInsets.only(top: 50.0), 
              child: Text('Statistics', style: Theme.of(context).textTheme.displayLarge),
            ),
            CardWidget(text: 'Flower Record', value: statistics.mostFlowers.toString()),
            const SizedBox(height: 10.0),
            CardWidget(text: 'Overall Learn Time', value: '${sessionTime.item1} ${sessionTime.item2.toString()}'),
            CardWidget(text: 'Last 7 Days Learn Time', value: '${lastSevenDaysSessionTime.item1} ${lastSevenDaysSessionTime.item2.toString()}'),
            CardWidget(text: 'Last 30 Days Learn Time', value: '${lastThirtyDaysSessionTime.item1} ${lastThirtyDaysSessionTime.item2.toString()}'),
            statistics.lastDaysSessionTimeChart(7),
            const SizedBox(height: 10.0),
            CardWidget(text: 'Correct Posture', value: '${statistics.posturePercentage()}%'),
            CardWidget(text: 'Posture Last 7 Days', value: '${statistics.lastDaysPosturePercentage(7)}%'),
            CardWidget(text: 'Posture Last 30 Days', value: '${statistics.lastDaysPosturePercentage(30)}%'),
            statistics.lastDaysPostureChart(7),
          ],
        )
      ),
    );
  }
}
