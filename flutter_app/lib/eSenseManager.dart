import 'package:esense_flutter/esense.dart';

Future<bool> connectToESense() async {
  ESenseManager eSenseManager = ESenseManager('eSense-0332');

  // first listen to connection events before trying to connect
  eSenseManager.connectionEvents.listen((event) {
  print('CONNECTION event: $event');
  });

  // try to connect to the eSense device 
  return await eSenseManager.connect();
}
