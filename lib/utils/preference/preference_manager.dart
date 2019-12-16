import 'dart:convert';
import 'package:flutter_demo/utils/constants/app_constants.dart';
import 'package:flutter_demo/utils/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefManager {
  Future saveUser(String key, value) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(key, json.encode(value));
  }

  getUser(String key) async {
    final pref = await SharedPreferences.getInstance();
    return json.decode(pref.getString(key));
  }

  setIsLoggedIn([bool isLoggedIn]) async {
    //[] is for default argument
    if (isLoggedIn == null) {
      //if null that means set true
      final pref = await SharedPreferences.getInstance();
      pref.setBool(AppConstants.IS_LOGGED_IN, true);
    } else {
      final pref = await SharedPreferences.getInstance();
      pref.setBool(AppConstants.IS_LOGGED_IN, false);
    }
  }

  Future getIsLoggedIn() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(AppConstants.IS_LOGGED_IN);
  }

  setCurrentLoggedInUser(String userName) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(AppConstants.CURRENT_USER_ID, userName);
  }

  getCurrentLoggedInUser() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(AppConstants.CURRENT_USER_ID);
  }

  removeCurrentLoggedInUser() async {
    final pref = await SharedPreferences.getInstance();
    pref.remove(AppConstants.CURRENT_USER_ID);
  }

  Future checkForUserExistence(String email) async {
    final pref = await SharedPreferences.getInstance();
    String user = pref.getString(email);
    if (user == null || user.length == 0) {
      return null;
    } else {
      return user;
    }
  }
}
