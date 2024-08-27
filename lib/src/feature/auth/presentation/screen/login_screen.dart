import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uae_top_up/src/core/widget/action_button.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';

import '../widget/login_form.dart';
import '../widget/login_screen_header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.loginScreen.tr(),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Form(
            key: _loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LoginScreenHeader(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: LoginForm(
                    onPasswordChanged: (phoneNumber) {},
                    onPhoneNumberChanged: (password) {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: ActionButton(title: AppLocalizations.loginButton.tr()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
