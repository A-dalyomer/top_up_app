import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:uae_top_up/src/core/constants/const_widget_keys.dart';
import 'package:uae_top_up/src/core/extension/size_extensions.dart';
import 'package:uae_top_up/src/core/widget/phone_number_field.dart';
import 'package:uae_top_up/src/feature/auth/presentation/provider/login_provider.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    this.onPhoneNumberChanged,
    this.onPasswordChanged,
  });
  final Function(PhoneNumber)? onPhoneNumberChanged;
  final Function(String)? onPasswordChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.phoneNumberLabel.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        PhoneNumberField(
          onChanged: (value) => onPhoneNumberChanged?.call(value),
          enabled: !context.read<LoginProvider>().loading,
        ),
        10.vS,
        Text(
          AppLocalizations.passwordLabel.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        TextFormField(
          key: ConstWidgetKeys.passwordFormField,
          onChanged: (value) => onPasswordChanged?.call(value),
          enabled: !context.read<LoginProvider>().loading,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
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
    );
  }
}
