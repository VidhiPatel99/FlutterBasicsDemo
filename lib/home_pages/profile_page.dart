import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_demo/models/user_model.dart';
import 'package:flutter_demo/utils/constants/color_constants.dart';
import 'package:flutter_demo/utils/constants/language_constants.dart';
import 'package:flutter_demo/utils/preference/preference_manager.dart';
import 'package:flutter_demo/utils/theme/text_form_field_theme.dart';
import 'package:flutter_demo/utils/validators/input_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker_modern/image_picker_modern.dart';

class ProfilePage extends StatefulWidget {
  String userEmail;

  ProfilePage(this.userEmail);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  User currentUser = User();
  String currentLoggedUserEmail;
  PrefManager prefManager = PrefManager();
  String _name;
  String _profilePic;
  File _image;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      _profilePic = PrefManager.base64String(_image.readAsBytesSync());
    });
  }

  Future<User> loadSharedPrefs() async {
    try {
      User user = User.fromJson(await prefManager.getUser(widget.userEmail));
      return user;
    } catch (Excepetion) {
      // do something
    }
  }

  @override
  void initState() {
    super.initState();
    loadSharedPrefs().then((User val) {
      setState(() {
        print('Vidhi : In InitState');
        currentUser = val;

        _nameController.text = currentUser.name;
        _emailController.text = currentUser.email;

        _name = currentUser.name;
        _profilePic = currentUser.profilePic;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        alignment: Alignment.topCenter,
        child: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                _profilePicWidget(),
                SizedBox(
                  height: 20.0,
                ),
                _nameField(),
                SizedBox(
                  height: 20.0,
                ),
                _emailField(),
                SizedBox(
                  height: 30.0,
                ),
                _signUpButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _profilePicWidget() {
    return GestureDetector(
      onTap: getImage,
      child: Container(
        height: 100,
        width: 100,
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(50),
          child: PrefManager.imageFromBase64String(_profilePic ?? ""),
        ),
      ),
    );
  }

  TextFormField _emailField() {
    return TextFormField(
      obscureText: false,
      style: TextFromFieldTheme.textFieldTextStyle,
      decoration: TextFromFieldTheme.textFieldInputDecoration.copyWith(
        prefixIcon: Icon(Icons.email),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: InputValidator.validateEmail,
      controller: _emailController,
      enabled: false,
    );
  }

  TextFormField _nameField() {
    return TextFormField(
      obscureText: false,
      style: TextFromFieldTheme.textFieldTextStyle,
      decoration: TextFromFieldTheme.textFieldInputDecoration.copyWith(
        hintText: LanguageConstants.name,
        prefixIcon: Icon(Icons.person),
      ),
      keyboardType: TextInputType.text,
      validator: InputValidator.validateName,
      controller: _nameController,
      onChanged: (String val) {
        print('onFieldSubmitted $val');
        _name = val;
      },
    );
  }

  _signUpButton(BuildContext context) {
    final login = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: ColorConstants.colorPrimary,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(40.0, 15.0, 40.0, 15.0),
        onPressed: () async {
          _validateInputs(context);
        },
        child: Text("Update",
            textAlign: TextAlign.center,
            style: TextFromFieldTheme.textFieldTextStyle
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return login;
  }

  _validateInputs(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      currentUser.name = _name;
      currentUser.profilePic = _profilePic;

      updateUser().then((val) {
        Fluttertoast.showToast(
            msg: 'User update successfully', gravity: ToastGravity.BOTTOM);
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Future updateUser() => prefManager.saveUser(currentUser.email, currentUser);
}
