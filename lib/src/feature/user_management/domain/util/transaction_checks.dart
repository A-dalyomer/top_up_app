import 'package:uae_top_up/src/feature/configurarion/domain/entity/app_config.dart';
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
    for (var savedTransaction in savedUserTransaction) {
      if (savedTransaction.dateTime.month == transaction.dateTime.month) {
        totalMonthTransactions += savedTransaction.amount;
      }
    }
    if (totalMonthTransactions > appConfig.senderMaxAmount) return true;
    return false;
  }

  bool checkExceedsBeneficiaryTransactions(
    Transaction transaction, {
    required List<Beneficiary> savedUserBeneficiaries,
    required userVerified,
    required AppConfig appConfig,
  }) {
    double totalBeneficiaryMonthTransactions = transaction.amount;
    final Beneficiary targetBeneficiary = savedUserBeneficiaries.singleWhere(
      (element) => transaction.targetUserPhoneNumber == element.phoneNumber,
    );
    for (var savedBeneficiaryTransaction in targetBeneficiary.transactions) {
      if (savedBeneficiaryTransaction.dateTime.month ==
          transaction.dateTime.month) {
        totalBeneficiaryMonthTransactions += savedBeneficiaryTransaction.amount;
      }
    }
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
}
