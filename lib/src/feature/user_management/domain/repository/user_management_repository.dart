import 'package:uae_top_up/src/feature/transaction/data/model/transaction_model.dart';

import '../../data/model/beneficiary_model.dart';
import '../entity/user.dart';

enum UserBalanceChangeTypes { add, debit }

abstract class UserManagementRepository {
  Future<User?> getCurrentUser();

  Future<User?> signInUser(String phoneNumber);

  Future<void> saveUser({required User newUser});

  Future<void> removeUser();

  Future<bool> changeBalance(
    double amount, {
    required User currentUser,
    required UserBalanceChangeTypes changeType,
  });

  Future<BeneficiaryModel?> addBeneficiary({
    required String name,
    required String phoneNumber,
    required String senderPhoneNumber,
  });

  Future<TransactionModel?> makeTransaction({
    required TransactionModel transaction,
  });
}
