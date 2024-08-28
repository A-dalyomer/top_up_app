import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneNumberField extends StatelessWidget {
  const PhoneNumberField({super.key, this.onChanged, required this.enabled});
  final Function(PhoneNumber)? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
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
