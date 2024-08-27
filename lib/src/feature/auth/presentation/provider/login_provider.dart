import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  LoginProvider({required this.loginUser});
  final Future<void> Function(String phoneNumber, String password) loginUser;

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  bool loading = false;
  String phoneNumber = '';
  String password = '';

  GlobalKey<FormState> loginFormKey() => _loginFormKey;

  void setPhoneNumber(String? newValue) {
    phoneNumber = newValue ?? '';
  }

  void setPassword(String newValue) {
    password = newValue;
  }

  void attemptLogin() async {
    if (!(_loginFormKey.currentState?.validate() ?? false)) return;
    loading = true;
    notifyListeners();
    await loginUser(phoneNumber, password);
    loading = false;
  }
}
