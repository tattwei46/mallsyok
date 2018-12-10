import 'package:flutter/material.dart';
import 'package:mallsyok/startup/splash_screen.dart';
import 'package:mallsyok/screens/select_mall_screen.dart';
import 'package:mallsyok/startup/home_screen.dart';

void main() {
  runApp(new MaterialApp(
    home: new SplashScreen(),
    routes: <String, WidgetBuilder>{
      '/SelectMallScreen': (BuildContext context) => new SelectMallScreen()
    },
  ));
}
