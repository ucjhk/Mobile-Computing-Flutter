import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/providers/settingsProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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


class ChartWidget extends StatelessWidget{

  final maxEntriesToShow;
  final List<double> values;

  const ChartWidget({super.key, required this.maxEntriesToShow, required this.values});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      //TODO: make this responsive
      width: 300,
      height: 150,
      child: values.isEmpty ?
        const Center(child: Text('No Data')) : 
        LineChart(
          LineChartData(
            gridData: const FlGridData(show: true),
            titlesData: const FlTitlesData(
              show: true,
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: const Color(0xff37434d), width: 1),
            ),
            minX: 0,
            maxX: maxEntriesToShow.toDouble(),
            minY: 0,
            maxY: values.reduce((value, element) => value > element ? value : element) + 10,
            lineBarsData: [
              LineChartBarData(
                spots: values.asMap().entries
                    .map((entry) => FlSpot(entry.key.toDouble(), entry.value)).toList(),
                isCurved: true,
                color: Colors.blue,
                barWidth: 4, // Adjust the width of the line
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
    );
  }
}