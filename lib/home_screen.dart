import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/login_screen.dart';
import 'package:flutter_demo/utils/constants/color_constants.dart';
import 'package:flutter_demo/utils/models/user_model.dart';
import 'package:flutter_demo/utils/preference/preference_manager.dart';
import 'package:flutter_demo/utils/theme/GeneralStyle.dart';

class HomePage extends StatefulWidget {
  final String userEmail;

  HomePage(this.userEmail);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User currentUser = User();
  PrefManager prefManager = PrefManager();

  Future<User> loadSharedPrefs() async {
    try {
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
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: ColorConstants.colorPrimary,
      ),
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
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                '${currentUser.name}',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                '${currentUser.email}',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              decoration: BoxDecoration(color: ColorConstants.colorPrimary),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text(
                'Home',
                style: GeneralStyle.navDrawerItemStyle,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                'Profile',
                style: GeneralStyle.navDrawerItemStyle,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.power_settings_new),
              title: Text(
                'Logout',
                style: GeneralStyle.navDrawerItemStyle,
              ),
              onTap: () {
                logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future logout() async {
    await prefManager.setIsLoggedIn(false);
    await prefManager.removeCurrentLoggedInUser();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        ModalRoute.withName("/home_screen"));
  }
}
