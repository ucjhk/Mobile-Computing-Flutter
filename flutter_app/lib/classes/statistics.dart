import 'package:flutter_app/components/customWidgets.dart';
import 'package:flutter_app/utils/helperMethods.dart';

///------------------------------------------------------------------------///
/// Statistics Class
/// Functions to utilize and display the sessions
///------------------------------------------------------------------------///

class Statistics{
  int mostFlowers;
  DateTime lastTime;
  List<SessionStatistic> sessions;

  Statistics({required this.mostFlowers, required this.sessions, required this.lastTime});

  Map<String, dynamic> toJson() {
    return {
      'mostFlowers': mostFlowers,
      'lastTime': lastTime.toIso8601String(),
      'session': sessions.map((item) => item.toJson()).toList(),
    };
  }

  copyWith({int? mostFlowers, DateTime? lastTime, List<SessionStatistic>? sessions}){
    return Statistics(mostFlowers: mostFlowers ?? this.mostFlowers, lastTime: lastTime ?? this.lastTime, sessions: this.sessions);
  }

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      mostFlowers: json['mostFlowers'],
      lastTime: DateTime.parse(json['lastTime']?? DateTime.now().toIso8601String()),
      sessions: List<SessionStatistic>.from((json['session']?? []).map((item) => SessionStatistic.fromJson(item))),
    );
  }

  void addSession(SessionStatistic session){
    sessions.add(session);
  }

  void setMostFlowers(int flowers){
    mostFlowers = flowers;
  }

  //get sessions from the last few days
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
    return (list.fold(0.0, (previousValue, element) => previousValue + (element.goodPosturePercentage * element.sessionTime* 100)) / _getSessionTime(list));
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
    return list.fold(0.0, (previousValue, element) => previousValue + element.sessionTime);
  }

  double lastDaysSessionTime(int days){
    return _getSessionTime(_lastDays(days));
  }

  double sessionTime(){
    return _getSessionTime(sessions);
  }

  ChartWidget lastDaysPostureChart(int days){
    return ChartWidget(values: _sessionsAverageGoodPosture(_lastDays(days)), maxEntriesToShow: days);
  }

  ChartWidget thisDaysPostureChart(){
    var ses = getFirstFewElementsInList(_sessionsGoodPosture(sessions), 5);
    return ChartWidget(values: ses, maxEntriesToShow: 5, showNumbers: false);
  }

  ChartWidget lastDaysSessionTimeChart(int days){
    return ChartWidget(values: _summedTime(_lastDays(days)), maxEntriesToShow: days);
  }

  /*-------------------------------------------------------------
    Helper methods to get the right values based on the sessions
    for the ChartWidgets
  ---------------------------------------------------------------*/

  //get the goodPosturePercentage of each session and return in a list
  List<double> _sessionsGoodPosture(List<SessionStatistic> list) {
    List<double> result = [];
    for (var entry in list) {
      double value = entry.goodPosturePercentage;
      result.add((value * 100).round().toDouble());
    }
    return result;
  }

  //get the average posturePercentage of each day of the list
  List<double> _sessionsAverageGoodPosture(List<SessionStatistic> list) {
    var groupedSessions = groupByDate(list);
    List<double> result = [];
    for (var entry in groupedSessions.entries) {
      double sum = entry.value.fold(0, (previousValue, element) => previousValue + element.goodPosturePercentage *element.sessionTime);
      double average = sum / (_getSessionTime(entry.value));

      result.add((average * 100).round().toDouble());
    }
    return result;
  }

  //get the summed time of each day of the list
  List<double> _summedTime(List<SessionStatistic> list) {
    var groupedSessions = groupByDate(list);
    List<double> result = [];
    for (var entry in groupedSessions.entries) {
      double sum = entry.value.fold(0, (previousValue, element) => previousValue + element.sessionTime);

      result.add(sum);
    }
    return result;
  }

}

///------------------------------------------------------------------------///
/// Session Class
/// Has the important values of each session saved
///------------------------------------------------------------------------///

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