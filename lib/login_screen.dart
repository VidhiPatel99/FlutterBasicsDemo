import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  _displaySnackBar(BuildContext buildContext) {
    Scaffold.of(buildContext).showSnackBar(SnackBar(
      content: Text("Login clicked"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    _emailField() {
      final emailField = TextField(
        obscureText: false,
        style: style,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          prefixIcon: Icon(Icons.email),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        keyboardType: TextInputType.emailAddress,
      );
      return emailField;
    }

    _passwordField() {
      final passwordField = TextField(
        obscureText: true,
        style: style,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          prefixIcon: Icon(Icons.lock),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
      );
      return passwordField;
    }

    _loginButton(BuildContext context) {
      final login = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xff01A0C7),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {},
          child: Text("Login",
              textAlign: TextAlign.center,
              style: style.copyWith(
                  color: Colors.white, fontWeight: FontWeight.bold)),
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
          color: Colors.blueGrey,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          decoration: TextDecoration.underline),
    );

    _signUpText(BuildContext context) {
      final textSignUpGesture = GestureDetector(
        onTap: () {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Sign Up clicked"),
          ));
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
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 35.0,
                  ),
                  SizedBox(
                    height: 155.0,
                    child: Image.asset(
                      "images/splash_logo.png",
                    ),
                  ),
                  SizedBox(
                    height: 35.0,
                  ),
                  SizedBox(
                    height: 55.0,
                    child: _emailField(),
                  ),
                  SizedBox(
                    height: 35.0,
                  ),
                  SizedBox(
                    height: 55.0,
                    child: _passwordField(),
                  ),
                  SizedBox(
                    height: 35.0,
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
          ),
        ),
      ),
    ));
  }
}
