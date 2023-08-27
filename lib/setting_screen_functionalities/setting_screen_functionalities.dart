import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager extends ChangeNotifier {
  bool isDarkTheme;

  SettingsManager({required this.isDarkTheme});

  void toggleTheme() async{
    isDarkTheme = !isDarkTheme;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkTheme', isDarkTheme);
  }

}
