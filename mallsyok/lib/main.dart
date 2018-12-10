import 'package:flutter/material.dart';
import 'package:mallsyok/startup/splash_screen.dart';
import 'package:mallsyok/screen/select_mall_screen.dart';
import 'package:mallsyok/res/app_config.dart';

void main() {
  runApp(new MaterialApp(
    home: new SplashScreen(),
    theme: ThemeData(accentColor: kColorPink),
    routes: <String, WidgetBuilder>{
      '/SelectMallScreen': (BuildContext context) => new SelectMallScreen()
    },
  ));
}
