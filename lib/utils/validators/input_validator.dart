import 'package:flutter_demo/utils/constants/app_constants.dart';

mixin InputValidator {
  static String validateEmail(String arg) {
    if (arg.length > 0) {
      if (!AppConstants.emailValidationRegex.hasMatch(arg)) {
        return 'Please enter valid email';
      } else {
        return null;
      }
    } else {
      return 'Please enter email';
    }
  }

  static String validatePassword(String value) {
    if (value.length > 0) {
      if (value.length < 6) {
        return 'Password lenght must be 6 or greater';
      } else {
        return null;
      }
    } else {
      return 'Please enter password';
    }
  }

  static String validateConfirmPassword(
      String password, String confirmPassword) {
    if (confirmPassword != null) {
      if (confirmPassword.length > 0) {
        if (password != confirmPassword) {
          return 'Password and confirm password must be same';
        } else {
          return null;
        }
      } else {
        return 'Please enter confirm password';
      }
    } else {
      return 'Please enter confirm password';
    }
  }

  static String validateString(String value, String errorMessage) {
    if (value.length > 0) {
      return null;
    } else {
      return 'Please enter $errorMessage';
    }
  }
}
