import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/login_screen.dart';
import 'package:flutter_demo/utils/constants/color_constants.dart';
import 'package:flutter_demo/utils/constants/language_constants.dart';
import 'package:flutter_demo/utils/theme/text_form_field_theme.dart';
import 'package:flutter_demo/utils/validators/input_validator.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  String _name;
  String _email;
  String _password;
  String _confirmPassword;

  @override
  Widget build(BuildContext context) {
    _nameField() {
      final nameField = TextFormField(
        obscureText: false,
        style: TextFromFieldTheme.textFieldTextStyle,
        decoration: TextFromFieldTheme.textFieldInputDecoration.copyWith(
          hintText: LanguageConstants.name,
          prefixIcon: Icon(Icons.person),
        ),
        keyboardType: TextInputType.text,
        validator: InputValidator.validateName,
        onSaved: (String val) {
          _name = val;
        },
      );

      return nameField;
    }

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
        controller: _passwordController,
        validator: InputValidator.validatePassword,
        onSaved: (String val) {
          _password = val;
        },
      );
      return passwordField;
    }

    _confirmPasswordField() {
      final confirmPasswordField = TextFormField(
        obscureText: true,
        style: TextFromFieldTheme.textFieldTextStyle,
        decoration: TextFromFieldTheme.textFieldInputDecoration.copyWith(
            hintText: LanguageConstants.confirmPassword,
            prefixIcon: Icon(Icons.lock)),
        controller: _confirmPasswordController,
        validator: (val) {
          return InputValidator.validateConfirmPassword(
              _passwordController.text, _confirmPasswordController.text);
        },
        onSaved: (String val) {
          _confirmPassword = val;
        },
      );
      return confirmPasswordField;
    }

    _signUpButton(BuildContext context) {
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
          child: Text("Sign Up",
              textAlign: TextAlign.center,
              style: TextFromFieldTheme.textFieldTextStyle
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      );

      return login;
    }

    final text = Text(
      "Already have an account?  ",
      style: TextStyle(
          color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 18),
    );

    final textLogin = Text(
      "Login",
      style: TextStyle(
          color: ColorConstants.colorPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          decoration: TextDecoration.underline),
    );

    _loginText(BuildContext context) {
      final textSignUpGesture = GestureDetector(
        onTap: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
              ModalRoute.withName("/signup_screen"));
//          Scaffold.of(context).showSnackBar(SnackBar(
//            content: Text("Sign Up clicked"),
//          ));
        },
        child: textLogin,
      );
      return textSignUpGesture;
    }

    return Scaffold(
      body: Center(
        child: Builder(
          builder: (context) => SingleChildScrollView(
            child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(36.0),
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
                        height: 20.0,
                      ),
                      _nameField(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _emailField(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _passwordField(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _confirmPasswordField(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _signUpButton(context),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[text, _loginText(context)],
                      )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }

  _validateInputs() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
