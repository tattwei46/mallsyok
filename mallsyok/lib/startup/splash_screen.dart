import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mallsyok/res/app_config.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isIOS = false;

  startTimer() async {
    var _duration = new Duration(seconds: AppConfig.SPLASH_SCREEN_DURATION);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/SelectMallScreen');
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }


  @override
  Widget build(BuildContext context) {
    isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return new Scaffold(
      body: new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage(isIOS
                ? 'images/splashscreen_iphone.png'
                : 'images/splashscreen_android.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: new Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              AppConfig.APP_VERSION,
              style: new TextStyle(color: Colors.white, fontSize: 18.0),
            ),
          ),
        ) /* add child content content here */,
      ),
    );
  }
}
