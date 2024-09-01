import 'package:uae_top_up/src/feature/transaction/data/model/transaction_model.dart';

import '../../data/model/beneficiary_model.dart';
import '../entity/user.dart';

/// User balance change type
/// The [add] is used to perform add balance operation to user
/// The [debit] is used to perform balance debit operation from user
enum UserBalanceChangeTypes { add, debit }

/// Contract for user account state management operations
abstract class UserManagementRepository {
  /// Get the locally saved used data
  Future<User?> getCurrentUser();

  /// Sign out the current user
  Future<User?> signInUser(String phoneNumber);

  /// Save new user data locally
  Future<void> saveUser({required User newUser});

  /// Delete local user data
  Future<void> removeUser();

  /// Change current user's balance
  Future<bool> changeBalance(
    double amount, {
    required User currentUser,
    required UserBalanceChangeTypes changeType,
  });

  /// Add a beneficiary for current user
  Future<BeneficiaryModel?> addBeneficiary({
    required String name,
    required String phoneNumber,
    required String senderPhoneNumber,
  });

  /// Make a transaction for the current user
  Future<TransactionModel?> makeTransaction({
    required TransactionModel transaction,
  });
}
