import 'package:uae_top_up/src/feature/transaction/data/model/transaction_model.dart';
import 'package:uae_top_up/src/feature/transaction/domain/entity/transaction.dart';
import 'package:uae_top_up/src/feature/user_management/data/model/beneficiary_model.dart';
import 'package:uae_top_up/src/feature/user_management/domain/entity/beneficiary.dart';
import 'package:uae_top_up/src/feature/configuration/domain/entity/app_config.dart';
import 'package:uae_top_up/src/feature/user_management/domain/entity/user.dart';

User createTestUser({
  int id = 0,
  double balance = 100.0,
  String phoneNumber = "+971565556666",
  String name = "+971565556666",
  List<Transaction> transactions = const [],
  List<Beneficiary> beneficiaries = const [],
  bool isVerified = true,
  double monthlyTopUps = 0,
}) {
  return User(
      id: id,
      name: name,
      balance: balance,
      transactions: transactions,
      beneficiaries: beneficiaries,
      isVerified: isVerified,
      phoneNumber: phoneNumber,
      monthlyTopUps: monthlyTopUps);
}

BeneficiaryModel createTestBeneficiary({
  int id = 0,
  String name = "+971565556666",
  String phoneNumber = "+971565556666",
  List<Transaction> transactions = const [],
}) {
  return BeneficiaryModel(
    id: id,
    name: name,
    phoneNumber: phoneNumber,
    transactions: transactions,
  );
}

TransactionModel createTestTransaction({
  int id = 0,
  double amount = 20.0,
  int sourceUserId = 0,
  String targetUserPhoneNumber = '+971565556666',
  DateTime? dateTime,
}) {
  return TransactionModel(
    id: id,
    amount: amount,
    sourceUserId: sourceUserId,
    targetUserPhoneNumber: targetUserPhoneNumber,
    dateTime: dateTime ?? DateTime.now(),
  );
}

AppConfig createTestAppConfig({
  int senderMaxAmount = 3000,
  int receiverVerifiedMaxAmount = 1000,
  int receiverNonVerifiedMaxAmount = 500,
  int transactionFee = 1,
  int maxActiveBeneficiaries = 5,
}) {
  return AppConfig(
    senderMaxAmount: senderMaxAmount,
    receiverVerifiedMaxAmount: receiverVerifiedMaxAmount,
    receiverNonVerifiedMaxAmount: receiverNonVerifiedMaxAmount,
    maxActiveBeneficiaries: maxActiveBeneficiaries,
    transactionFee: transactionFee,
  );
}
