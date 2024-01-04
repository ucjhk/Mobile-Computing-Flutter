import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Statistics{
  /// All time record of being active user
  int mostFlowers;
  /// sessions
  List<SessionStatistic> sessions;

  Statistics({required this.mostFlowers, required this.sessions});

  Map<String, dynamic> toJson() {
    return {
      'mostFlowers': mostFlowers,
      'session': sessions.map((item) => item.toJson()).toList(),
    };
  }

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      mostFlowers: json['mostFlowers'],
      sessions: List<SessionStatistic>.from((json['session']?? []).map((item) => SessionStatistic.fromJson(item))),
    );
  }

  void addSession(SessionStatistic session){
    sessions.add(session);
  }

  void setMostFlowers(int flowers){
    mostFlowers = flowers;
  }

  List<SessionStatistic> _lastDays(int days){
    List<SessionStatistic> lastDays = [];
    DateTime now = DateTime.now();
    for (int i = 0; i < sessions.length; i++){
      if (now.difference(sessions[i].day).inDays <= days){
        lastDays.add(sessions[i]);
      }
    }
    return lastDays;
  }

    double _getPosture(List<SessionStatistic> list){
    return list.fold(0.0, (previousValue, element) => previousValue + (element.goodPosturePercentage * 100).round()) / list.length;
  }

  double lastDaysPosturePercentage(int days){
    return _getPosture(_lastDays(days));
  }

  double posturePercentage(){
    return _getPosture(sessions);
  }

  double _getPauseTime(List<SessionStatistic> list){
    return list.fold(0.0, (previousValue, element) => previousValue + element.pauseTime) / list.length;
  }

  double lastDaysPauseTime(int days){
    return _getPauseTime(_lastDays(days));
  }
 
  double pauseTime(){
    return _getPauseTime(sessions);
  }

  double _getSessionTime(List<SessionStatistic> list){
    return list.fold(0.0, (previousValue, element) => previousValue + element.sessionTime) / list.length;
  }

  double lastDaysSessionTime(int days){
    return _getSessionTime(_lastDays(days));
  }

  double sessionTime(){
    return _getSessionTime(sessions);
  }

  PostureChart lastDaysPostureChart(int days){
    return PostureChart(sessions: _lastDays(days));
  }

}

class SessionStatistic{
  double goodPosturePercentage;
  double pauseTime;
  double sessionTime;
  DateTime day;

  SessionStatistic({required this.goodPosturePercentage, required this.pauseTime, required this.sessionTime, required this.day});

  Map<String, dynamic> toJson() {
    return {
      'goodPosturePercentage': goodPosturePercentage,
      'pauseTime': pauseTime,
      'sessionTime': sessionTime,
      'day': day.toIso8601String(),
    };
  }

  factory SessionStatistic.fromJson(Map<String, dynamic> json) {
    return SessionStatistic(
      goodPosturePercentage: json['goodPosturePercentage'],
      pauseTime: json['pauseTime'],
      sessionTime: json['sessionTime'],
      day: DateTime.parse(json['day']),
    );
  }
}

class PostureChart extends StatelessWidget {
  final List<SessionStatistic> sessions;
  final int maxEntriesToShow = 7;

  const PostureChart({super.key, required this.sessions});

  @override
  Widget build(BuildContext context) {

    /* sessions.add(SessionStatistic(goodPosturePercentage: 0.5, pauseTime: 0, sessionTime: 0, day: DateTime.now()));
    sessions.add(SessionStatistic(goodPosturePercentage: 0.2, pauseTime: 0, sessionTime: 0, day: DateTime.now()));
    sessions.add(SessionStatistic(goodPosturePercentage: 0.1, pauseTime: 0, sessionTime: 0, day: DateTime.now()));
    sessions.add(SessionStatistic(goodPosturePercentage: 0.2, pauseTime: 0, sessionTime: 0, day: DateTime.now())); */
    return SizedBox(
      //TODO: make this responsive
      width: 400,
      height: 150,
      child: sessions.isEmpty ?
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
            maxY: sessions
                .map((session) => session.goodPosturePercentage * 100)
                .reduce((a, b) => a > b ? a : b) + 10,
            lineBarsData: [
              LineChartBarData(
                spots: sessions.take(maxEntriesToShow).toList().asMap().entries
                    .map((entry) => FlSpot(entry.key.toDouble(), (entry.value.goodPosturePercentage * 100).round().toDouble())).toList(),
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