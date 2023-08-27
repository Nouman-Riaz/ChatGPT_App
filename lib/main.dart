import 'package:chatgpt/authentication_screens/splash_screen.dart';
import 'package:chatgpt/setting_screen_functionalities/setting_screen_functionalities.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_screen_widgets/profile_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
  String? profileImageUrl = prefs.getString('profileImageUrl');
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(
      create: (context) => SettingsManager(isDarkTheme: isDarkTheme)),
      ChangeNotifierProvider(create: (_) => ProfileProvider(profileImageUrl)),
    ],
    child: MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final settingsManager = Provider.of<SettingsManager>(context);
    final brightness = settingsManager.isDarkTheme ? Brightness.dark : Brightness.light;
    final theme = ThemeData(
      brightness: brightness,
    );
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatGPT',
      theme: theme,
      home: SplashScreen(),
    );
  }
}

