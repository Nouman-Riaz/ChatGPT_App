import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../setting_screen_functionalities/setting_screen_functionalities.dart';


class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SettingsManager settingsManager = Provider.of<SettingsManager>(context);

    return Scaffold(
      appBar: AppBar(
          title: const Text('Settings'),
              backgroundColor: Colors.orangeAccent,
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: Text('Dark Theme'),
            value: settingsManager.isDarkTheme,
            onChanged: (newValue) {
              settingsManager.toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}
