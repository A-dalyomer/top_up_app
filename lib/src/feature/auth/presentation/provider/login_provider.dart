import 'package:flutter/material.dart';

/// State controller for the login screen
class LoginProvider extends ChangeNotifier {
  LoginProvider({required this.loginUser});

  /// The user login handler function that is passed from user user provider
  final Future<void> Function(String phoneNumber, String password) loginUser;

  /// Login form key to validate the form on login attempt
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  /// Screen loading state
  bool loading = false;

  /// The entered phone number
  /// Updated from the onChange in the phone number form field
  String phoneNumber = '';

  /// The entered password
  /// Updated from the onChange int Password text form field
  String password = '';

  /// Getter for [_loginFormKey]
  GlobalKey<FormState> loginFormKey() => _loginFormKey;

  /// Set the value of [phoneNumber]
  void setPhoneNumber(String? newValue) {
    phoneNumber = newValue ?? '';
  }

  /// Set the value of [password]
  void setPassword(String newValue) {
    password = newValue;
  }

  /// Updates the [loading] state with the passed [value]
  void setLoadingState(bool value) {
    loading = value;
    notifyListeners();
  }

  /// Attempts to login user After validating the [_loginFormKey]
  void attemptLogin() async {
    if (!(_loginFormKey.currentState?.validate() ?? false)) return;
    setLoadingState(true);
    await loginUser(phoneNumber, password);
    setLoadingState(false);
  }
}
