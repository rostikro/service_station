import 'package:flutter/foundation.dart';
import 'package:service_station/models/work_model.dart';

class Cart extends ChangeNotifier {
  final List<Work> works = [];

  void add(Work newWork) {
    works.add(newWork);
    notifyListeners();
  }

  void remove(Work newWork) {
    works.remove(newWork);
    notifyListeners();
  }
}
