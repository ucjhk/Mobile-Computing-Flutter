import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postureProvider = ChangeNotifierProvider<PostureNotifier>((ref) {
  return PostureNotifier();
});

class PostureNotifier extends ChangeNotifier {
  bool isGoodPosture = true;

  void toggleImage() {
    isGoodPosture = !isGoodPosture;
    notifyListeners();
  }
}