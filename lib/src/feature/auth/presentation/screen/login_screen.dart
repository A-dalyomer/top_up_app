import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:uae_top_up/src/core/constants/const_icon_assets.dart';
import 'package:uae_top_up/src/core/extension/size_extensions.dart';
import 'package:uae_top_up/src/core/widget/action_button.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';

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
                Center(
                  child: SvgPicture.asset(ConstIconAssets.loginPresentIcon),
                ),
                Text(
                  AppLocalizations.loginScreenTitle.tr(),
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.phoneNumberLabel.tr(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      InternationalPhoneNumberInput(
                        onInputChanged: (value) {},
                        autoFocus: true,
                        selectorConfig: const SelectorConfig(
                          showFlags: true,
                          selectorType: PhoneInputSelectorType.DIALOG,
                          setSelectorButtonAsPrefixIcon: true,
                          leadingPadding: 24,
                          trailingSpace: false,
                        ),
                        initialValue: PhoneNumber(isoCode: "AE"),
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      10.vS,
                      Text(
                        AppLocalizations.passwordLabel.tr(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextFormField(
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          hintText: AppLocalizations.passwordHint.tr(),
                        ),
                        validator: (value) => value!.isEmpty
                            ? AppLocalizations.passwordHint.tr()
                            : value.length < 8
                                ? AppLocalizations.shortPassword.tr()
                                : null,
                      ),
                    ],
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
