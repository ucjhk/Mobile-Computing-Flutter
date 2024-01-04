import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsProvider = ChangeNotifierProvider<SettingsNotifier>((ref) {
  return SettingsNotifier();
});


class SettingsNotifier extends ChangeNotifier {
  bool muted = false;

  void toggleMute() {
    muted = !muted;
    notifyListeners();
  }
}