import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uae_top_up/src/core/util/dialogs.dart';
import 'package:uae_top_up/src/feature/configuration/domain/entity/app_config.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';
import 'package:uae_top_up/src/feature/transaction/data/model/transaction_model.dart';
import 'package:uae_top_up/src/feature/transaction/domain/entity/transaction.dart';
import 'package:uae_top_up/src/feature/user_management/domain/entity/beneficiary.dart';

import '../entity/user.dart';

class TransactionChecks {
  TransactionChecks({required this.dialogs});
  final Dialogs dialogs;

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
        AppLocalizations.transactionMaxMonthAmount,
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
    if (availableAmount < 5) {
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
