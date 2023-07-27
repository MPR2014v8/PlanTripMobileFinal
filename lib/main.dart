import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:plantrip_traveler/pages/home_screen/login_page.dart';
import 'package:plantrip_traveler/pages/activity_screen/activity_page.dart';
import 'package:plantrip_traveler/pages/trip_sreen/trip_page.dart';
import 'package:plantrip_traveler/pages/user_screen/user_page.dart';
import 'package:plantrip_traveler/test.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark
  ));
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Prompt',
      ),
      home: LoginPage(),
      // home: TestPage(),
    );
  }
}
