import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uae_top_up/src/core/util/core_enums.dart';
import 'package:uae_top_up/src/core/widget/action_button.dart';
import 'package:uae_top_up/src/core/widget/loading_indicator.dart';
import 'package:uae_top_up/src/core/widget/phone_number_field.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';
import 'package:uae_top_up/src/feature/user_management/domain/entity/beneficiary.dart';

class AddBeneficiarySheet extends StatefulWidget {
  const AddBeneficiarySheet({super.key, required this.onSave});
  final Future<bool> Function(Beneficiary) onSave;

  @override
  State<AddBeneficiarySheet> createState() => _AddBeneficiarySheetState();
}

class _AddBeneficiarySheetState extends State<AddBeneficiarySheet> {
  final GlobalKey<FormState> formKey = GlobalKey();
  String beneficiaryName = '';
  String phoneNumber = '';
  ApiScreenStates screenStates = ApiScreenStates.done;

  void save() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => screenStates = ApiScreenStates.loading);
    Beneficiary newBeneficiary = Beneficiary(
      id: 0,
      name: beneficiaryName,
      phoneNumber: phoneNumber,
      transactions: const [],
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
              switch (screenStates) {
                ApiScreenStates.loading => const LoadingIndicator(),
                ApiScreenStates.done || _ => Column(
                    children: [
                      if (screenStates == ApiScreenStates.error)
                        Icon(
                          Icons.error,
                          size: 30,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ActionButton(
                        title: AppLocalizations.save,
                        onPressed: save,
                      ),
                    ],
                  ),
              },
            ],
          ),
        ),
      ),
    );
  }
}
