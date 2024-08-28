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

  Future<bool> addBeneficiary({
    required String name,
    required String phoneNumber,
    required User currentUser,
  });

  Future<bool> makeTransaction({
    required double amount,
    required int targetUserId,
    required User currentUser,
  });
}
