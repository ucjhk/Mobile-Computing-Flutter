import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsProvider = ChangeNotifierProvider<SettingsNotifier>((ref) {
  return SettingsNotifier();
});


class SettingsNotifier extends ChangeNotifier {
  bool muted = false;
  double scale = 1.2;

  void changeScale(double value) {
    scale = value;
    notifyListeners();
  }

  void toggleMute() {
    muted = !muted;
    notifyListeners();
  }
}