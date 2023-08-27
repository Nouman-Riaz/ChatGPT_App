import 'dart:async';
import 'package:chatgpt/authentication_screens/login_screen.dart';
import 'package:chatgpt/navigation_screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashService {
  void isLogin(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if(user!=null) {
      Timer(
          const Duration(seconds: 3),
              () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatScreen())));
    }
    else{
      Timer(
          const Duration(seconds: 3),
              () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const LoginScreen())));
    }
  }
}
