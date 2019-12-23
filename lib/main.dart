import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_demo/home_screen.dart';
import 'package:flutter_demo/login_screen.dart';
import 'package:flutter_demo/utils/preference/preference_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn;
  String currentLoggedUser;

  Future<bool> getIsLoggedIn() async {
    try {
      PrefManager prefManager = PrefManager();
      isLoggedIn = await prefManager.getIsLoggedIn();
      return isLoggedIn;
    } catch (Excepetion) {
      // do something
    }
  }

  Future<String> getCurrentLoggedInUser() async {
    try {
      PrefManager prefManager = PrefManager();
      currentLoggedUser = await prefManager.getCurrentLoggedInUser();
      return currentLoggedUser;
    } catch (Excepetion) {
      // do something
    }
  }

  @override
  void initState() {
    super.initState();
    getIsLoggedIn().then((bool val) {
      isLoggedIn = val;
      if (isLoggedIn != null && isLoggedIn == true) {
        getCurrentLoggedInUser().then((String currentUserEmail) {
          Future.delayed(
              const Duration(seconds: 1),
              () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(currentLoggedUser)),
                  ModalRoute.withName("/main")));
        });
      } else {
        Future.delayed(
            const Duration(seconds: 1),
            () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                ModalRoute.withName("/main")));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage("images/splash_logo.png"),
          fit: BoxFit.contain,
        ),
      ),
    ));
  }
}
