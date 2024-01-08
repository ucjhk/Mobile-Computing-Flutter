import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/classes/gardenComponents.dart';
import 'package:flutter_app/components/gardenWidget.dart';
import 'package:flutter_app/classes/statistics.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:path_provider/path_provider.dart';

Map<String, dynamic> gardenWidgetsToJson(List<GardenObjectWidget> gardenObjects) {
  List<FlowerWidget> flowers = [];
  List<GarbageWidget> garbage = [];
  List<BigGarbageWidget> bigGarabage = [];
  for (var object in gardenObjects) {
    switch(object.runtimeType){
      case FlowerWidget:
        flowers.add(object as FlowerWidget);
        break;
      case GarbageWidget:
        garbage.add(object as GarbageWidget);
        break;
      case BigGarbageWidget:
        bigGarabage.add(object as BigGarbageWidget);
        break;
    }
  }
    return {
      'flowers': flowers.map((item) => item.toJson()).toList(),
      'garbage': garbage.map((item) => item.toJson()).toList(),
      'bigGarbage': bigGarabage.map((item) => item.toJson()).toList(),
    };
  }

  void insertInRightPlace(object, list){
    int insertionIndex = 0;
      for (int i = 0; i < list.length; i++) {
        if((list[i]).distance < object.distance) {
          insertionIndex++;
        }
        else {
          break;
        }
      }
      list.insert(insertionIndex,object);
  }

  List<GardenObjectWidget> gardenWidgetFromJson(Map<String, dynamic> json){
    List<GardenObjectWidget> combined = [];
    combined.addAll(List<FlowerWidget>.from((json['flowers']?? []).map((item) => FlowerWidget.fromJson(item))));
    combined.addAll(List<GarbageWidget>.from((json['garbage']?? []).map((item) => GarbageWidget.fromJson(item))));
    combined.addAll(List<BigGarbageWidget>.from((json['bigGarbage']?? []).map((item) => BigGarbageWidget.fromJson(item))));

    List<GardenObjectWidget> gardenObjects = [];

    for (var object in combined) {
      insertInRightPlace(object, gardenObjects);
    }

    return gardenObjects;
  }

Future<File> saveGardenObjectsToFile(List<GardenObjectWidget> gardenObjects) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/garden_objects.json');

  final jsonString = jsonEncode(gardenWidgetsToJson(gardenObjects));

  return file.writeAsString(jsonString);
}

Future<List<GardenObjectWidget>> readGardenObjectsFromFile() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/garden_objects.json');

  if (await file.exists()) {
    final jsonString = await file.readAsString();
    final json = jsonDecode(jsonString);

    return gardenWidgetFromJson(json);
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
    return Statistics(mostFlowers: 0,lastTime: DateTime.now(), sessions: []);
  }
}
