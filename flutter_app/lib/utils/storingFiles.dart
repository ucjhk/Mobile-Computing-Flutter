import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/components/gardenComponents.dart';
import 'package:flutter_app/components/gardenWidget.dart';
import 'package:flutter_app/statistics.dart';
import 'package:path_provider/path_provider.dart';

Future<File> saveGardenObjectsToFile(List<GardenObjectWidget> gardenObjects) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/garden_objects.json');

  final jsonString = jsonEncode(gardenObjects.map((gardenObject) => gardenObject.toJson()).toList());

  return file.writeAsString(jsonString);
}

Future<List<GardenObjectWidget>> readGardenObjectsFromFile() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/garden_objects.json');

  if (await file.exists()) {
    final jsonString = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(jsonString);

    return decreaseGardenObjects(jsonList.map((json) => GardenObjectWidget.fromJson(json)).toList(), file.statSync().modified);
  } else {
    return [];
  }
}

Future<File> saveStatisticsToFile(Statistics statistic) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/statistics.json');

  final jsonString = jsonEncode(statistic.toJson());

  return file.writeAsString(jsonString);
}

Future<Statistics> readStatisticsFromFile() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/statistics.json');
 
  if (await file.exists()) {
    final jsonString = await file.readAsString();
    final json = jsonDecode(jsonString);

    return Statistics.fromJson(json);
  } else {
    return Statistics(mostFlowers: 0, sessions: []);
  }
}
