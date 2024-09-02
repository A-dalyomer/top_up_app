import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uae_top_up/src/core/constants/const_configs.dart';
import 'package:uae_top_up/src/core/util/dialogs.dart';
import 'package:uae_top_up/src/feature/configuration/domain/entity/app_config.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';
import 'package:uae_top_up/src/feature/transaction/data/model/transaction_model.dart';
import 'package:uae_top_up/src/feature/transaction/domain/entity/transaction.dart';
import 'package:uae_top_up/src/feature/user_management/domain/entity/beneficiary.dart';

import '../entity/user.dart';

/// Transaction making checks
/// Handles checking the transaction restrictions depending on current user info
/// and the related beneficiary
class TransactionChecks {
  TransactionChecks({required this.dialogs});
  final Dialogs dialogs;

  /// Checks all the possibilities
  /// returns true in case the transaction is possible
  bool checkTransactionPossible(
    BuildContext context, {
    required TransactionModel transaction,
    required User user,
    required AppConfig appConfig,
  }) {
    bool hasEnoughBalance = checkEnoughBalance(
      userBalance: user.balance,
      transactionAmount: transaction.amount,
      transactionFee: appConfig.transactionFee,
    );
    if (!hasEnoughBalance) {
      dialogs.showMessageDialog(context, AppLocalizations.noEnoughBalance);
      return false;
    }

    bool exceedsMonthTransactions = checkExceedsMonthTransactions(
      transaction,
      savedUserTransaction: user.transactions,
      appConfig: appConfig,
    );
    if (exceedsMonthTransactions) {
      dialogs.showMessageDialog(
        context,
        AppLocalizations.transactionMaxMonthAmount.tr(
          namedArgs: {"max_amount": appConfig.senderMaxAmount.toString()},
        ),
      );
      return false;
    }

    bool exceedsBeneficiaryTransactions = checkExceedsBeneficiaryTransactions(
      transaction,
      savedUserBeneficiaries: user.beneficiaries,
      userVerified: user.isVerified,
      appConfig: appConfig,
    );
    if (exceedsBeneficiaryTransactions) {
      String message = handleBeneficiaryMaxTransaction(
        targetUserPhoneNumber: transaction.targetUserPhoneNumber,
        dateTime: transaction.dateTime,
        appConfig: appConfig,
        beneficiaries: user.beneficiaries,
        userVerified: user.isVerified,
      );
      dialogs.showMessageDialog(context, message);
      return false;
    }

    return true;
  }

  /// Checks if then user have enough balance in his account
  bool checkEnoughBalance({
    required double userBalance,
    required double transactionAmount,
    required int transactionFee,
  }) {
    if (userBalance < transactionAmount + transactionFee) {
      return false;
    }
    return true;
  }

  /// Checks if user exceeded his monthly max transactions amount
  /// the max transaction amount is provided by [appConfig]
  /// returns true if used did exceed the limit
  bool checkExceedsMonthTransactions(
    Transaction transaction, {
    required List<Transaction> savedUserTransaction,
    required AppConfig appConfig,
  }) {
    double totalMonthTransactions = transaction.amount;
    totalMonthTransactions += getTotalUserMonthTransactions(
      savedUserTransaction,
      transaction.dateTime,
    );
    if (totalMonthTransactions > appConfig.senderMaxAmount) return true;
    return false;
  }

  /// Calculates the user's total transactions of passed [transactionDateMonth]
  /// Only the transactions of the same month and year of the date is calculated
  double getTotalUserMonthTransactions(
    List<Transaction> savedUserTransaction,
    DateTime transactionDateMonth,
  ) {
    double totalMonthTransactions = 0;
    for (var savedTransaction in savedUserTransaction) {
      if (savedTransaction.dateTime.month == transactionDateMonth.month &&
          savedTransaction.dateTime.year == transactionDateMonth.year) {
        totalMonthTransactions += savedTransaction.amount;
      }
    }
    return totalMonthTransactions;
  }

  /// Checks if user exceeded his monthly transactions amount for this beneficiary
  /// the max beneficiary transaction amount is provided by [appConfig]
  /// The max value takes used verification status into account
  /// returns true if used did exceed the limit
  bool checkExceedsBeneficiaryTransactions(
    Transaction transaction, {
    required List<Beneficiary> savedUserBeneficiaries,
    required userVerified,
    required AppConfig appConfig,
  }) {
    double totalBeneficiaryMonthTransactions = transaction.amount;
    totalBeneficiaryMonthTransactions += getTotalBeneficiaryTransactions(
      targetUserPhoneNumber: transaction.targetUserPhoneNumber,
      transactionDateMonth: transaction.dateTime,
      savedUserBeneficiaries: savedUserBeneficiaries,
    );
    switch (userVerified) {
      case true:
        if (totalBeneficiaryMonthTransactions >
            appConfig.receiverVerifiedMaxAmount) return true;
      case false:
        if (totalBeneficiaryMonthTransactions >
            appConfig.receiverNonVerifiedMaxAmount) return true;
    }
    return false;
  }

  /// Calculates the user's current month total transactions for the
  /// beneficiary with the passed [targetUserPhoneNumber]
  /// Only the transactions of the same month and year of the date is calculated
  double getTotalBeneficiaryTransactions({
    required String targetUserPhoneNumber,
    required DateTime transactionDateMonth,
    required List<Beneficiary> savedUserBeneficiaries,
  }) {
    final Beneficiary targetBeneficiary = savedUserBeneficiaries
        .where(
          (element) => targetUserPhoneNumber == element.phoneNumber,
        )
        .first;
    double totalBeneficiaryMonthTransactions = 0;
    for (var savedBeneficiaryTransaction in targetBeneficiary.transactions) {
      if (savedBeneficiaryTransaction.dateTime.month ==
              transactionDateMonth.month &&
          savedBeneficiaryTransaction.dateTime.year ==
              transactionDateMonth.year) {
        totalBeneficiaryMonthTransactions += savedBeneficiaryTransaction.amount;
      }
    }
    return totalBeneficiaryMonthTransactions;
  }

  /// Returns the error message to be shown to the user
  /// in case the [checkExceedsBeneficiaryTransactions] returned true
  /// Useful for the case of user is still able to make a transaction
  /// for the target phone number but with a lower transaction amount
  String handleBeneficiaryMaxTransaction({
    required String targetUserPhoneNumber,
    required DateTime dateTime,
    required AppConfig appConfig,
    required List<Beneficiary> beneficiaries,
    required bool userVerified,
  }) {
    double beneficiaryMonthTotalAmount = getTotalBeneficiaryTransactions(
      savedUserBeneficiaries: beneficiaries,
      targetUserPhoneNumber: targetUserPhoneNumber,
      transactionDateMonth: dateTime,
    );

    late final double availableAmount;
    if (userVerified) {
      availableAmount =
          appConfig.receiverVerifiedMaxAmount - beneficiaryMonthTotalAmount;
    } else {
      availableAmount =
          appConfig.receiverNonVerifiedMaxAmount - beneficiaryMonthTotalAmount;
    }

    late final String beneficiaryLimitMessage;
    if (availableAmount < ConstConfigs.transactionOptions.first) {
      beneficiaryLimitMessage = AppLocalizations.beneficiaryMaxReached.tr();
    } else {
      beneficiaryLimitMessage = AppLocalizations.beneficiaryMaxAmount.tr(
        namedArgs: {
          "amount": availableAmount.toString(),
          "name": targetUserPhoneNumber,
        },
      );
    }
    return beneficiaryLimitMessage;
  }
}
