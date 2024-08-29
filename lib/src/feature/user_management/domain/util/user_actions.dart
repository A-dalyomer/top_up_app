import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uae_top_up/src/core/extension/size_extensions.dart';
import 'package:uae_top_up/src/feature/user_management/domain/entity/beneficiary.dart';
import 'package:uae_top_up/src/feature/user_management/presentation/widget/add_beneficiary_sheet.dart';
import 'package:uae_top_up/src/feature/user_management/presentation/widget/transaction_sheet.dart';

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

  void showTransactionSheet(BuildContext context, Beneficiary beneficiary) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: 0.7.height(context)),
      builder: (context) {
        return TransactionSheet(
          beneficiary: beneficiary,
          onRechargePress: (transactionAmount) =>
              context.read<UserManagementProvider>().makeTransaction(
                    beneficiary: beneficiary,
                    amount: transactionAmount,
                  ),
        );
      },
    );
  }
}
