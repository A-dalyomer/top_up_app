import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uae_top_up/src/core/widget/action_button.dart';
import 'package:uae_top_up/src/core/widget/loading_indicator.dart';
import 'package:uae_top_up/src/feature/auth/presentation/provider/login_provider.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';

import '../widget/login_form.dart';
import '../widget/login_screen_header.dart';

/// User login screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.loginProvider});

  /// State Login provider
  final LoginProvider loginProvider;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      body: ChangeNotifierProvider(
        create: (context) => widget.loginProvider,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Consumer<LoginProvider>(
              builder: (context, loginProvider, child) => Form(
                key: loginProvider.loginFormKey(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LoginScreenHeader(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: LoginForm(
                        onPhoneNumberChanged: (phoneNumber) =>
                            loginProvider.setPhoneNumber(
                          phoneNumber.phoneNumber,
                        ),
                        onPasswordChanged: (password) =>
                            loginProvider.setPassword(
                          password,
                        ),
                      ),
                    ),
                    if (loginProvider.loading)
                      const LoadingIndicator()
                    else
                      Padding(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        child: ActionButton(
                          title: AppLocalizations.loginButton.tr(),
                          onPressed: loginProvider.attemptLogin,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
