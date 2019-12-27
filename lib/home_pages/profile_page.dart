import 'dart:io';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
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
  String _city;
  String _phoneNumber;
  String _gender;
  String _countryCode;
  File _image;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

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

        //set text to controller to set text after async call
        _nameController.text = currentUser.name;
        _emailController.text = currentUser.email;
        _cityController.text = currentUser.city;
        _phoneNumberController.text = currentUser.phoneNumber;

        //set current user details to local variables
        _name = currentUser.name;
        _profilePic = currentUser.profilePic;
        _city = currentUser.city;
        _phoneNumber = currentUser.phoneNumber;
        _gender = currentUser.gender;
        _countryCode = currentUser.countryCode;
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
                  height: 20.0,
                ),
                _cityField(),
                SizedBox(
                  height: 20.0,
                ),
                _countryField(),
                SizedBox(
                  height: 20.0,
                ),
                _genderField(),
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
      validator: (val) => InputValidator.validateString(val, 'name'),
      controller: _nameController,
      onChanged: (String val) {
        print('onFieldSubmitted $val');
        _name = val;
      },
    );
  }

  _cityField() {
    final confirmPasswordField = TextFormField(
      style: TextFromFieldTheme.textFieldTextStyle,
      decoration: TextFromFieldTheme.textFieldInputDecoration.copyWith(
          hintText: LanguageConstants.city,
          prefixIcon: Icon(Icons.location_city)),
      validator: (val) => InputValidator.validateString(val, 'city'),
      controller: _cityController,
      onChanged: (String val) {
        _city = val;
      },
    );
    return confirmPasswordField;
  }

  _countryField() {
    return IntrinsicHeight(
      child: Row(
        children: <Widget>[
          Container(
            color: Colors.black26,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: GestureDetector(
                onTap: () {
                  _openCountryPickerDialog();
                },
                child: Center(
                  child: Text(
                    '+$_countryCode',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                )),
          ),
          SizedBox(
            width: 10.0,
          ),
          Flexible(
            child: TextFormField(
              maxLength: 10,
              obscureText: false,
              style: TextFromFieldTheme.textFieldTextStyle,
              decoration: TextFromFieldTheme.textFieldInputDecoration.copyWith(
                  hintText: LanguageConstants.phone,
                  prefixIcon: Icon(Icons.phone),
                  counterText: ""),
              keyboardType: TextInputType.number,
              validator: InputValidator.validatePhoneNumber,
              controller: _phoneNumberController,
              onChanged: (String val) {
                print('onFieldSubmitted $val');
                _phoneNumber = val;
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.lightBlue),
            child: CountryPickerDialog(
                titlePadding: EdgeInsets.all(8.0),
                searchCursorColor: Colors.lightBlue,
                searchInputDecoration: InputDecoration(hintText: 'Search...'),
                isSearchable: true,
                title: Text('Select your phone code'),
                onValuePicked: (Country country) =>
                    setState(() => _countryCode = country.phoneCode),
                itemBuilder: _buildCountryCodeDialogItem)),
      );

  Widget _buildCountryCodeDialogItem(Country country) {
    return Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(
          width: 10,
        ),
        Text('+${country.phoneCode}'),
        SizedBox(
          width: 10,
        ),
        Expanded(child: Text('(${country.name})')),
      ],
    );
  }

  Row _genderField() {
    return Row(
      children: <Widget>[
        Text(
          'Gender: ',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Radio(
          value: 'Female',
          groupValue: _gender,
          onChanged: _handleRadioValueChange,
        ),
        Text('Female'),
        Radio(
          value: 'Male',
          groupValue: _gender,
          onChanged: _handleRadioValueChange,
        ),
        Text('Male'),
      ],
    );
  }

  void _handleRadioValueChange(String value) {
    setState(() {
      _gender = value;
      print(_gender);
    });
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
      currentUser.gender = _gender;
      currentUser.countryCode = _countryCode;
      currentUser.city = _city;
      currentUser.phoneNumber = _phoneNumber;

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
