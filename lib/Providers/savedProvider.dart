import 'package:flutter/material.dart';

class SavedProvider extends ChangeNotifier {
  List<String> _cars = [];
  List<String> get carID => _cars;

  void toggleFavorite(String car) {
    final isExist = _cars.contains(car);
    if (isExist) {
      _cars.remove(car);
    } else {
      _cars.add(car);
    }
    notifyListeners();
  }

  void clearFavorite() {
    _cars = [];
    notifyListeners();
  }

  bool isExist(String car) {
    final isExist = _cars.contains(car);
    return isExist;
  }
}
