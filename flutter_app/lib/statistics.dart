import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/customWidgets.dart';
import 'package:flutter_app/utils/helperMethods.dart';

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
      if (now.difference(sessions[i].date).inDays <= days){
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
    return PostureChart(sessions: _lastDays(days), maxEntriesToShow: days);
  }

  TimeChart lastDaysSessionTimeChart(int days){
    return TimeChart(sessions: _lastDays(days), maxEntriesToShow: days);
  }

}

class SessionStatistic{
  double goodPosturePercentage;
  double pauseTime;
  double sessionTime;
  DateTime date;

  SessionStatistic({required this.goodPosturePercentage, required this.pauseTime, required this.sessionTime, required this.date});

  Map<String, dynamic> toJson() {
    return {
      'goodPosturePercentage': goodPosturePercentage,
      'pauseTime': pauseTime,
      'sessionTime': sessionTime,
      'date': date.toIso8601String(),
    };
  }

  factory SessionStatistic.fromJson(Map<String, dynamic> json) {
    return SessionStatistic(
      goodPosturePercentage: json['goodPosturePercentage'],
      pauseTime: json['pauseTime'],
      sessionTime: json['sessionTime'],
      date: DateTime.parse(json['date']),
    );
  }
}

class PostureChart extends StatelessWidget {
  final List<SessionStatistic> sessions;
  final int maxEntriesToShow;

  const PostureChart({super.key, required this.sessions, required this.maxEntriesToShow});

  List<double> sessionsGoodPosture(Map<DateTime, List<SessionStatistic>> groupedSessions) {
    List<double> result = [];
    for (var entry in groupedSessions.entries) {
      double sum = entry.value.fold(0, (previousValue, element) => previousValue + element.goodPosturePercentage);
      double average = sum / entry.value.length;

      result.add((average * 100).round().toDouble());
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return ChartWidget(maxEntriesToShow: maxEntriesToShow, values: sessionsGoodPosture(groupByDate(sessions)));
  }
}

class TimeChart extends StatelessWidget {
  final List<SessionStatistic> sessions;
  final int maxEntriesToShow;

  const TimeChart({super.key, required this.sessions, required this.maxEntriesToShow});

  List<double> summedTime(Map<DateTime, List<SessionStatistic>> groupedSessions) {
    List<double> result = [];
    for (var entry in groupedSessions.entries) {
      double sum = entry.value.fold(0, (previousValue, element) => previousValue + element.sessionTime);

      result.add(sum);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return ChartWidget(maxEntriesToShow: maxEntriesToShow, values: summedTime(groupByDate(sessions)));
  }
}