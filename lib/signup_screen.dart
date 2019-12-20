import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/home_screen.dart';
import 'package:flutter_demo/login_screen.dart';
import 'package:flutter_demo/utils/constants/color_constants.dart';
import 'package:flutter_demo/utils/constants/language_constants.dart';
import 'package:flutter_demo/models/user_model.dart';
import 'package:flutter_demo/utils/preference/preference_manager.dart';
import 'package:flutter_demo/utils/theme/text_form_field_theme.dart';
import 'package:flutter_demo/utils/validators/input_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker_modern/image_picker_modern.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      _profilePic = PrefManager.base64String(_image.readAsBytesSync());
    });
  }

  PrefManager prefManager = PrefManager();
  String _name;
  String _email;
  String _password;
  String _confirmPassword;
  String _profilePic;

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
        onChanged: (String val) {
          print('onFieldSubmitted $val');
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
        onChanged: (String val) {
          print('onFieldSubmitted $val');
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

    _confirmPasswordField() {
      final confirmPasswordField = TextFormField(
        obscureText: true,
        style: TextFromFieldTheme.textFieldTextStyle,
        decoration: TextFromFieldTheme.textFieldInputDecoration.copyWith(
            hintText: LanguageConstants.confirmPassword,
            prefixIcon: Icon(Icons.lock)),
        validator: (val) =>
            InputValidator.validateConfirmPassword(_password, _confirmPassword),
        onChanged: (String val) {
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
          onPressed: () async {
            _validateInputs(context);
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
                      profilePicField(),
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

  GestureDetector profilePicField() {
    return GestureDetector(
      onTap: getImage,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black26, width: 2.0),
        ),
        height: 155.0,
        width: 155.0,
        child: _image == null
            ? Icon(Icons.add_a_photo)
            : ClipRRect(
                borderRadius: new BorderRadius.circular(77.5),
                child: Image.file(
                  _image,
                  fit: BoxFit.fill,
                )),
      ),
    );
  }

  Future<void> navigateToNextScreen(String user, BuildContext context) async {
    if (user == null) {
      User user = User();
      user.name = _name;
      user.email = _email;
      user.password = _password;
      user.profilePic = _profilePic;

      await prefManager.saveUser(_email, user);
      print("email : $_email");

      await prefManager.setIsLoggedIn();
      await prefManager.setCurrentLoggedInUser(_email);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    _email,
                  )),
          ModalRoute.withName("/signup_screen"));
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("User already exists. Please login."),
        action: SnackBarAction(
          label: 'Login',
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                ModalRoute.withName("/signup_screen"));
          },
        ),
      ));
    }
  }

  _validateInputs(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (_image == null) {
        Fluttertoast.showToast(
            msg: 'Please select profile pic',
            backgroundColor: Colors.red,
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_SHORT);
      } else {
        String user = await prefManager.checkForUserExistence(_email);
        navigateToNextScreen(user, context);
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
