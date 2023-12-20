import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/components/gardenComponents.dart';
import 'package:path_provider/path_provider.dart';

Future<File> saveToFile(List<GardenObjectWidget> gardenObjects) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/garden_objects.json');

  final jsonString = jsonEncode(gardenObjects.map((gardenObject) => gardenObject.toJson()).toList());

  return file.writeAsString(jsonString);
}

Future<List<GardenObjectWidget>> readFromFile() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/garden_objects.json');

  if (await file.exists()) {
    final jsonString = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(jsonString);

    return jsonList.map((json) => GardenObjectWidget.fromJson(json)).toList();
  } else {
    return [];
  }
}