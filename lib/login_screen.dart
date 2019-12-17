import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/signup_screen.dart';
import 'package:flutter_demo/utils/constants/color_constants.dart';
import 'package:flutter_demo/utils/constants/language_constants.dart';
import 'package:flutter_demo/models/user_model.dart';
import 'package:flutter_demo/utils/preference/preference_manager.dart';
import 'package:flutter_demo/utils/theme/text_form_field_theme.dart';
import 'package:flutter_demo/utils/validators/input_validator.dart';

import 'home_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  String _email;
  String _password;

//  TextEditingController _emailController = TextEditingController();
//  TextEditingController _passwordController = TextEditingController();

  PrefManager prefManager = PrefManager();

  _validateInputs(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      String user = await prefManager.checkForUserExistence(_email);

      navigateToNextScreen(user, context);
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  _displaySnackBar(BuildContext buildContext, String textToDisplay) {
    Scaffold.of(buildContext).showSnackBar(SnackBar(
      content: Text(textToDisplay),
    ));
  }

  @override
  Widget build(BuildContext context) {
    _emailField() {
      final emailField = TextFormField(
        obscureText: false,
        style: TextFromFieldTheme.textFieldTextStyle,
        decoration: TextFromFieldTheme.textFieldInputDecoration.copyWith(
          hintText: LanguageConstants.email,
          prefixIcon: Icon(Icons.email),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: InputValidator.validateEmail,
        onChanged: (String val) {
          _email = val;
        },
      );
      return emailField;
    }

    _passwordField() {
      final passwordField = TextFormField(
        obscureText: true,
        style: TextFromFieldTheme.textFieldTextStyle,
        decoration: TextFromFieldTheme.textFieldInputDecoration.copyWith(
          hintText: LanguageConstants.password,
          prefixIcon: Icon(Icons.lock),
        ),
        validator: InputValidator.validatePassword,
        onChanged: (String val) {
          _password = val;
        },
      );
      return passwordField;
    }

    _loginButton(BuildContext context) {
      final login = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10.0),
        color: ColorConstants.colorPrimary,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () async {
            _validateInputs(context);
          },
          child: Text("Login",
              textAlign: TextAlign.center,
              style: TextFromFieldTheme.textFieldTextStyle
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      );

      return login;
    }

    final text = Text(
      "Don't have an account?  ",
      style: TextStyle(
          color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 18),
    );

    final textSignUp = Text(
      "SignUp",
      style: TextStyle(
          color: ColorConstants.colorPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          decoration: TextDecoration.underline),
    );

    _signUpText(BuildContext context) {
      final textSignUpGesture = GestureDetector(
        onTap: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => SignUpPage()),
              ModalRoute.withName("/login_screen"));
        },
        child: textSignUp,
      );
      return textSignUpGesture;
    }

    return Scaffold(
        body: Center(
      child: Builder(
        builder: (context) => SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 155.0,
                      child: Image.asset(
                        "images/splash_logo.png",
                      ),
                    ),
                    SizedBox(
                      height: 35.0,
                    ),
                    _emailField(),
                    SizedBox(
                      height: 20.0,
                    ),
                    _passwordField(),
                    SizedBox(
                      height: 20.0,
                    ),
                    _loginButton(context),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[text, _signUpText(context)],
                    )
                  ],
                ),
              ),
//
            ),
          ),
        ),
      ),
    ));
  }

  void navigateToNextScreen(String user, BuildContext context) {
    if (user == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("No user found. Please sign up first"),
        action: SnackBarAction(
          label: "SignUp",
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SignUpPage()),
                ModalRoute.withName("/login_screen"));
          },
        ),
      ));
    } else {
      User mUser = User.fromJson(json.decode(user));
      if (mUser.password == _password) {
        prefManager.setIsLoggedIn();
        prefManager.setCurrentLoggedInUser(mUser.email);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      mUser.email,
                    )),
            ModalRoute.withName("/login_screen"));
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Please enter valid password"),
        ));
      }
    }
  }
}
