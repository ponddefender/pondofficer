import 'package:flutter/foundation.dart';

class GameStateProvider extends ChangeNotifier {
  int _fishRemaining = 0;
  int get fishRemaining => _fishRemaining;

  void startGame(int initialFishCount) {
    _fishRemaining = initialFishCount;
    notifyListeners();
  }

  void loseFish() {
    if (_fishRemaining > 0) {
      _fishRemaining--;
      notifyListeners();
    }
  }

  void resetGame() {
    _fishRemaining = 0;
    notifyListeners();
  }
}
