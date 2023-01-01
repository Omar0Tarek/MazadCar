import 'package:flutter/cupertino.dart';

class FilterProvider with ChangeNotifier {
  Map<String, dynamic> filter = new Map();

  void applyFilter(Map<String, dynamic> appliedFilter) {
    filter = appliedFilter;
    notifyListeners();
  }
}
