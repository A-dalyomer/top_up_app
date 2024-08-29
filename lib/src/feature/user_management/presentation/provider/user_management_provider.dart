import 'package:flutter/material.dart';
import 'package:uae_top_up/src/feature/transaction/data/model/transaction_model.dart';
import 'package:uae_top_up/src/feature/user_management/data/model/beneficiary_model.dart';
import 'package:uae_top_up/src/feature/user_management/domain/entity/beneficiary.dart';

import '../../domain/entity/user.dart';
import '../../domain/repository/user_management_repository.dart';

class UserManagementProvider extends ChangeNotifier {
  UserManagementProvider(this.userManagementRepository) {
    initializeUser();
  }
  final UserManagementRepository userManagementRepository;

  late User user;
  bool finishedInitialization = false;
  bool userExists = false;

  Future<void> initializeUser() async {
    User? savedUser = await userManagementRepository.getCurrentUser();
    userExists = savedUser != null;
    if (userExists) user = savedUser!;
    finishedInitialization = true;
    notifyListeners();
  }

  Future<void> loginUser(
    String phoneNumber,
    String password,
  ) async {
    User? newUser = await userManagementRepository.signInUser(phoneNumber);
    if (newUser != null) {
      await userManagementRepository.saveUser(newUser: newUser);
      user = newUser;
      userExists = true;
      notifyListeners();
    }
  }

  Future<void> signOutUser() async {
    await userManagementRepository.removeUser();
    userExists = false;
    notifyListeners();
  }

  Future<bool> addBeneficiary(Beneficiary beneficiary) async {
    BeneficiaryModel? addedBeneficiary =
        await userManagementRepository.addBeneficiary(
      name: beneficiary.name,
      phoneNumber: beneficiary.phoneNumber,
      senderPhoneNumber: user.phoneNumber,
    );
    if (addedBeneficiary != null) {
      await updateBeneficiaries(addedBeneficiary);
      notifyListeners();
    }
    return addedBeneficiary != null;
  }

  Future<bool> makeTransaction({
    required Beneficiary beneficiary,
    required double amount,
  }) async {
    TransactionModel tempTransaction = TransactionModel(
      id: 0,
      amount: amount,
      sourceUserId: user.id,
      targetUserPhoneNumber: beneficiary.phoneNumber,
    );
    bool canMakeTransaction = checkTransactionPossible(tempTransaction);
    if (!canMakeTransaction) return false;
    debitUserBalance(amount);
    TransactionModel? newTransaction = await userManagementRepository
        .makeTransaction(transaction: tempTransaction);
    if (newTransaction != null) {
      await updateTransactions(
        beneficiary: beneficiary,
        newTransaction: newTransaction,
      );
      notifyListeners();
    } else {
      debitUserBalance(-amount);
    }
    return newTransaction != null;
  }

  bool checkTransactionPossible(TransactionModel transaction) {
    if (user.balance < transaction.amount + 1) {
      return false;
    }
    return true;
  }

  void debitUserBalance(double amount) {
    user = user.copyWith(balance: user.balance - amount);
    notifyListeners();
  }

  Future<void> updateBeneficiaries(BeneficiaryModel newBeneficiary) async {
    user.beneficiaries.add(newBeneficiary);
    await userManagementRepository.saveUser(newUser: user);
  }

  Future<void> updateTransactions({
    required Beneficiary beneficiary,
    required TransactionModel newTransaction,
  }) async {
    user.transactions.add(newTransaction);
    user.beneficiaries
        .singleWhere((element) => element == beneficiary)
        .transactions
        .add(newTransaction);
    await userManagementRepository.saveUser(newUser: user);
  }
}
