import 'package:uae_top_up/src/feature/configuration/domain/entity/app_config.dart';
import 'package:uae_top_up/src/feature/transaction/domain/entity/transaction.dart';
import 'package:uae_top_up/src/feature/user_management/domain/entity/beneficiary.dart';

class TransactionChecks {
  bool checkEnoughBalance({
    required double userBalance,
    required double transactionAmount,
  }) {
    if (userBalance < transactionAmount + 1) {
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
      if (savedTransaction.dateTime.month == transactionDateMonth.month) {
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
    final Beneficiary targetBeneficiary = savedUserBeneficiaries.singleWhere(
      (element) => transaction.targetUserPhoneNumber == element.phoneNumber,
    );
    double totalBeneficiaryMonthTransactions = transaction.amount;
    totalBeneficiaryMonthTransactions += getTotalBeneficiaryTransactions(
      targetBeneficiary,
      transaction.dateTime,
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

  double getTotalBeneficiaryTransactions(
    Beneficiary targetBeneficiary,
    DateTime transactionDateMonth,
  ) {
    double totalBeneficiaryMonthTransactions = 0;
    for (var savedBeneficiaryTransaction in targetBeneficiary.transactions) {
      if (savedBeneficiaryTransaction.dateTime.month ==
          transactionDateMonth.month) {
        totalBeneficiaryMonthTransactions += savedBeneficiaryTransaction.amount;
      }
    }
    return totalBeneficiaryMonthTransactions;
  }
}
