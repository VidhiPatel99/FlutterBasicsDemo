mixin AppConstants {
  static final RegExp emailValidationRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static final IS_LOGGED_IN = "isLoggedIn";
  static final CURRENT_USER_ID = "currentUserId";
}
