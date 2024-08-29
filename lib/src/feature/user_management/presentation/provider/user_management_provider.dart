import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uae_top_up/src/feature/configurarion/domain/entity/app_config.dart';
import 'package:uae_top_up/src/feature/configurarion/domain/util/core_config_manager.dart';
import 'package:uae_top_up/src/feature/transaction/data/model/transaction_model.dart';
import 'package:uae_top_up/src/feature/user_management/data/model/beneficiary_model.dart';
import 'package:uae_top_up/src/feature/user_management/domain/entity/beneficiary.dart';
import 'package:uae_top_up/src/feature/user_management/domain/util/transaction_checks.dart';

import '../../domain/entity/user.dart';
import '../../domain/repository/user_management_repository.dart';

class UserManagementProvider extends ChangeNotifier {
  UserManagementProvider(this.context, this.userManagementRepository) {
    initializeUser();
  }
  final BuildContext context;
  final UserManagementRepository userManagementRepository;

  late User user;
  bool finishedInitialization = false;
  bool userExists = false;

  Future<void> initializeUser() async {
    User? savedUser = await userManagementRepository.getCurrentUser();
    if (savedUser != null) {
      final User? refreshedUser = await refreshUser(savedUser);
      await updateUser(refreshedUser ?? savedUser);
    }
    finishedInitialization = true;
    notifyListeners();
  }

  Future<void> loginUser(
    String phoneNumber,
    String password,
  ) async {
    User? newUser = await userManagementRepository.signInUser(phoneNumber);
    if (newUser != null) {
      await updateUser(newUser);
    }
  }

  Future<User?> refreshUser(User user) async {
    User? newUser = await userManagementRepository.signInUser(user.phoneNumber);
    if (newUser != null) {
      await updateUser(newUser);
    }
    return newUser;
  }

  Future<void> updateUser(User newUser) async {
    await userManagementRepository.saveUser(newUser: newUser);
    user = newUser;
    userExists = true;
    notifyListeners();
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
      dateTime: DateTime.now(),
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

  /// TODO: Make UI errors for false cases
  bool checkTransactionPossible(TransactionModel transaction) {
    TransactionChecks transactionChecks = TransactionChecks();

    bool hasEnoughBalance = transactionChecks.checkEnoughBalance(
      userBalance: user.balance,
      transactionAmount: transaction.amount,
    );
    if (!hasEnoughBalance) return false;

    final AppConfig appConfig = context.read<CoreConfigManager>().appConfig!;
    bool exceedsMonthTransactions =
        transactionChecks.checkExceedsMonthTransactions(
      transaction,
      savedUserTransaction: user.transactions,
      appConfig: appConfig,
    );
    if (exceedsMonthTransactions) return false;

    bool exceedsBeneficiaryTransactions =
        transactionChecks.checkExceedsBeneficiaryTransactions(
      transaction,
      savedUserBeneficiaries: user.beneficiaries,
      userVerified: user.isVerified,
      appConfig: appConfig,
    );
    if (exceedsBeneficiaryTransactions) return false;

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
