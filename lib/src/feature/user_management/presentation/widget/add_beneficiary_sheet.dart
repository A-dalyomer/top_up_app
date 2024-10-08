import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uae_top_up/src/core/util/core_enums.dart';
import 'package:uae_top_up/src/core/widget/api_action_button.dart';
import 'package:uae_top_up/src/core/widget/phone_number_field.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';
import 'package:uae_top_up/src/feature/user_management/domain/entity/beneficiary.dart';

/// Add beneficiary bottom sheet content widget
class AddBeneficiarySheet extends StatefulWidget {
  const AddBeneficiarySheet({
    super.key,
    required this.onSave,
    this.testMode = false,
  });
  final Future<bool> Function(Beneficiary) onSave;
  final bool testMode;

  @override
  State<AddBeneficiarySheet> createState() => _AddBeneficiarySheetState();
}

class _AddBeneficiarySheetState extends State<AddBeneficiarySheet> {
  /// Forms key for validation before submission
  final GlobalKey<FormState> formKey = GlobalKey();

  /// Entered name state
  String beneficiaryName = '';

  /// Entered phone number state
  String phoneNumber = '';

  /// API Screen current state
  ApiScreenStates screenStates = ApiScreenStates.done;

  /// Saves the new beneficiary after validating the form
  /// Updates [screenStates] depending on result of [widget.onSave]
  void save() async {
    if (!(formKey.currentState?.validate() ?? false) && !widget.testMode) {
      return;
    }
    setState(() => screenStates = ApiScreenStates.loading);
    Beneficiary newBeneficiary = Beneficiary(
      id: 0,
      name: beneficiaryName,
      phoneNumber: phoneNumber,
      transactions: const [],
      active: true,
    );
    bool added = await widget.onSave(newBeneficiary);
    if (added) {
      setState(() => screenStates = ApiScreenStates.done);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } else {
      setState(() => screenStates = ApiScreenStates.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          top: 18.0,
          left: 18,
          right: 18,
          bottom: MediaQuery.of(context).viewInsets.bottom + 18,
        ),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                onChanged: (value) => beneficiaryName = value,
                decoration: InputDecoration(
                  hintText: AppLocalizations.beneficiaryName.tr(),
                ),
                validator: (value) {
                  switch (value!.length) {
                    case > 20:
                      return AppLocalizations.longName.tr();
                    case 0:
                      return AppLocalizations.fieldRequired.tr();
                    default:
                      return null;
                  }
                },
              ),
              const Padding(padding: EdgeInsets.only(bottom: 10)),
              PhoneNumberField(
                enabled: true,
                onChanged: (p0) => phoneNumber = p0.phoneNumber!,
              ),
              ApiActionButton(
                title: AppLocalizations.save,
                screenStates: screenStates,
                onPressed: save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
