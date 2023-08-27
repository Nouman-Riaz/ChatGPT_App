import 'package:chatgpt/authentication_screens/splash_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashService splashService = SplashService();
  void initState() {
    // TODO: implement initState
    super.initState();
    splashService.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Center(
            child: Container(
              width: 250, // Set the desired width
              height: 250, // Set the desired height
              child: Image(
                image: AssetImage('images/chatgpt_logo.png'),
              ),
            ),
          ),

          Center(
            child: Text('Welcome',style: TextStyle(color: Colors.black54,fontSize: 25),),
          ),

        ],
      ),
    );
  }
}
