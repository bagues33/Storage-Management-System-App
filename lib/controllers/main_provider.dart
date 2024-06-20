import 'package:flutter/material.dart';

class MainProvider extends ChangeNotifier {
  int tabSelected = 0;
  
  void changeTabSelected(int value) {
    tabSelected = value;
    notifyListeners();
  }
}
