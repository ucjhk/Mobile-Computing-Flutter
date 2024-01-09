import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/providers/settingsProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///------------------------------------------------------------------------///
/// Consumer Widgets
///------------------------------------------------------------------------///

//Scales the child based on the settingsProvider
class ScaleWidget extends ConsumerWidget {
  final Widget child;

  const ScaleWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return Transform.scale(
      scale: settings.scale,
      child: child,
    );
  }
}

///------------------------------------------------------------------------///
/// Custom Stateless Widgets
///------------------------------------------------------------------------///

//CardWidget with a text and a value 
class CardWidget extends StatelessWidget{

  final String text;
  final String value;

  const CardWidget({super.key, required this.text, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(text),
          Text(value),
        ],
      ),
    );
  }
}

//Chart Widget that only shows limited amount of entries.
//Numbers indicating the values around the widget can be turned off
class ChartWidget extends StatelessWidget{

  final int maxEntriesToShow;
  final List<double> values;
  final bool showNumbers;

  const ChartWidget({super.key, required this.maxEntriesToShow, required this.values, this.showNumbers = true});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: 300,
      height: 150,
      child: values.isEmpty ?
        const Center(child: Text('No Data')) : 
        LineChart(
          LineChartData(
            gridData: const FlGridData(show: true),
            //Numbers on/off
            titlesData: FlTitlesData(
              show: showNumbers,
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Theme.of(context).primaryColor, width: 1),
            ),
            minX: 0,
            maxX: maxEntriesToShow.toDouble(),
            minY: 0,
            //height based on the max value in the list
            maxY: values.reduce((value, element) => value > element ? value : element) + 10,
            lineBarsData: [
              LineChartBarData(
                spots: values.asMap().entries
                    .map((entry) => FlSpot(entry.key.toDouble(), entry.value)).toList(),
                isCurved: true,
                color: Theme.of(context).primaryColor,
                barWidth: 4, 
                preventCurveOverShooting: true,
                belowBarData: BarAreaData(show: false),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Theme.of(context).canvasColor,
              )
            )
          ),
        ),
    );
  }
}