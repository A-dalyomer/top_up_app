import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uae_top_up/src/feature/user_management/presentation/widget/add_beneficiary_sheet.dart';

import '../../presentation/provider/user_management_provider.dart';

class UserActions {
  void showAddBeneficiarySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      builder: (context) {
        return AddBeneficiarySheet(
          onSave: (beneficiary) => context
              .read<UserManagementProvider>()
              .addBeneficiary(beneficiary),
        );
      },
    );
  }
}
