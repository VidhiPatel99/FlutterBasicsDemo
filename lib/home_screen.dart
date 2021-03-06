import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/home_pages/listing_page.dart';
import 'package:flutter_demo/home_pages/profile_page.dart';
import 'package:flutter_demo/login_screen.dart';
import 'package:flutter_demo/utils/constants/color_constants.dart';
import 'package:flutter_demo/models/user_model.dart';
import 'package:flutter_demo/utils/preference/preference_manager.dart';
import 'package:flutter_demo/utils/theme/GeneralStyle.dart';

class HomePage extends StatefulWidget {
  final String userEmail;

  HomePage(this.userEmail);

  @override
  _HomePageState createState() => _HomePageState();
}

@override
State<StatefulWidget> createState() {
  return new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User currentUser = User();
  PrefManager prefManager = PrefManager();
  int _selectedDrawerIndex = 0;
  String _pageTitle = "Home";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
      key: _scaffoldKey,
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.menu),
          onTap: () {
            _scaffoldKey.currentState.openDrawer();

            //get latest User object to update user details on drawer when come from update profile screen
            loadSharedPrefs().then((User val) {
              setState(() {
                currentUser = val;
              });
            });
          },
        ),
        title: Text(_pageTitle),
        backgroundColor: ColorConstants.colorPrimary,
      ),
      body: SafeArea(
        child: _getDrawerItemWidget(_selectedDrawerIndex),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.all(0),
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
              currentAccountPicture: Container(
                height: 100,
                width: 100,
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(50),
                  child: PrefManager.imageFromBase64String(
                      currentUser.profilePic == ""
                          ? ""
                          : currentUser.profilePic),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text(
                'Home',
                style: GeneralStyle.navDrawerItemStyle,
              ),
              onTap: () {
                _onSelectItem(0);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                'Profile',
                style: GeneralStyle.navDrawerItemStyle,
              ),
              onTap: () {
                _onSelectItem(1);
              },
            ),
            ListTile(
              leading: Icon(Icons.power_settings_new),
              title: Text(
                'Logout',
                style: GeneralStyle.navDrawerItemStyle,
              ),
              onTap: () {
                Navigator.pop(context);
                _asyncConfirmDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future _asyncConfirmDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('Ok'),
              onPressed: () {
                logout();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
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

  _onSelectItem(int index) {
    setState(() {
      _selectedDrawerIndex = index;

      switch (index) {
        case 0:
          _pageTitle = "Home";
          break;

        case 1:
          _pageTitle = "Profile";
          break;
      }
    });
    Navigator.of(context).pop(); // close the drawer
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new ListingPage();
      case 1:
        return new ProfilePage(currentUser.email);

      default:
        return new Text("Error");
    }
  }
}
