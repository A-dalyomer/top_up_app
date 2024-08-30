import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:uae_top_up/src/core/constants/const_widget_keys.dart';

class PhoneNumberField extends StatelessWidget {
  const PhoneNumberField({super.key, this.onChanged, required this.enabled});
  final Function(PhoneNumber)? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      key: ConstWidgetKeys.phoneFormField,
      onInputChanged: onChanged,
      isEnabled: enabled,
      keyboardAction: TextInputAction.next,
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
    );
  }
}
