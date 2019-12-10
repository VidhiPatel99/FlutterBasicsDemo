import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/signup_screen.dart';
import 'package:flutter_demo/utils/constants/color_constants.dart';
import 'package:flutter_demo/utils/constants/language_constants.dart';
import 'package:flutter_demo/utils/theme/text_form_field_theme.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  RegExp emailValidationRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  String _email;
  String _password;

  _validateInputs() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String validateEmail(String arg) {
    if (arg.length > 0) {
      if (!emailValidationRegex.hasMatch(arg)) {
        return 'Please enter valid email';
      } else {
        return null;
      }
    } else {
      return 'Please enter email';
    }
  }

  String validatePassword(String password) {
    if (password.length > 8) {
      return null;
    } else {
      return 'Please enter valid password';
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
        validator: validateEmail,
        onSaved: (String val) {
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
        validator: validatePassword,
        onSaved: (String val) {
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
          onPressed: () {
            _validateInputs();
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
}
