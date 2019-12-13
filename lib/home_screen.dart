import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/utils/models/user_model.dart';
import 'package:flutter_demo/utils/preference/preference_manager.dart';

class HomePage extends StatefulWidget {
  final String userEmail;

  HomePage(this.userEmail);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User currentUser = User();

  Future<User> loadSharedPrefs() async {
    try {
      PrefManager prefManager = PrefManager();
      User user = User.fromJson(await prefManager.getUser(widget.userEmail));
      setState(() {
        currentUser = user;
      });
      return user;
    } catch (Excepetion) {
      // do something
    }
  }

  @override
  initState() {
    super.initState();
    loadSharedPrefs().then((User val) {
      setState(() {
        currentUser = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(36.0),
        child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('Wel come '),
                    Text(currentUser.name ?? ""),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('Email :  '),
                    Text(currentUser.email ?? ""),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
