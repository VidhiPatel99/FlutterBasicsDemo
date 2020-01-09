import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_demo/AnimatedText.dart';
import 'package:flutter_demo/home_screen.dart';
import 'package:flutter_demo/login_screen.dart';
import 'package:flutter_demo/utils/preference/preference_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

class AnimationTest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AnimationTest();
}

class _AnimationTest extends State<AnimationTest>
    with SingleTickerProviderStateMixin {
  List<Widget> stackChildren;

  AnimationController animationController;
  Animation opacityBlue;
  Animation opacityPink;

  @override
  void initState() {
    super.initState();
    stackChildren = getStackChildren();
    animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);

    opacityBlue = Tween(begin: 0.5, end: 1.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    opacityPink = Tween(begin: 1.0, end: 0.5).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
  }

  List<Widget> getStackChildren() {
    return <Widget>[
      // Max Size
      Positioned.fill(
        key: UniqueKey(),
        child: Container(
          color: Colors.green,
        ),
      ),
      Positioned(
        key: UniqueKey(),
        top: 120,
        left: 60,
        child: Container(
          color: Colors.blue,
          height: 200.0,
          width: 200.0,
        ),
      ),
      Positioned(
        key: UniqueKey(),
        left: 80,
        top: 40.0,
        child: GestureDetector(
          onTap: () {
            _swapChildren(2);
            Fluttertoast.showToast(msg: "Pink clicked 2");
          },
          child: Container(
            color: Colors.pink,
            height: 150.0,
            width: 150.0,
          ),
        ),
      )
    ];
  }

  _swapChildren(int posToBringFront) {
    Widget temp;

    setState(() {
      var index = posToBringFront == 1 ? 2 : 1;
      temp = stackChildren.removeAt(posToBringFront);
      stackChildren.insert(index, temp);
    });
  }

//    setState(() {
//      stackChildren[1] = stackChildren[2];
//      stackChildren[2] = temp; //top pos
//    });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedBuilder(
      builder: (context, child) {
//        return Stack(
//          fit: StackFit.expand,
//          children: this.stackChildren,
//        );

        return Opacity(
          opacity: opacityBlue.value,
          child: Container(
            color: Colors.blue,
            height: 200.0,
            width: 200.0,
          ),
        );
      },
      animation: animationController,
    ));
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
