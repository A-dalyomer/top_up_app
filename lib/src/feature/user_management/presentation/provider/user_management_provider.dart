import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uae_top_up/src/feature/configuration/domain/entity/app_config.dart';
import 'package:uae_top_up/src/feature/configuration/domain/util/core_config_manager.dart';
import 'package:uae_top_up/src/feature/transaction/data/model/transaction_model.dart';
import 'package:uae_top_up/src/feature/user_management/data/model/beneficiary_model.dart';
import 'package:uae_top_up/src/feature/user_management/domain/entity/beneficiary.dart';
import 'package:uae_top_up/src/feature/user_management/domain/util/transaction_checks.dart';

import '../../domain/entity/user.dart';
import '../../domain/repository/user_management_repository.dart';
import '../../domain/util/user_actions.dart';

class UserManagementProvider extends ChangeNotifier {
  UserManagementProvider(
    this.context,
    this.userManagementRepository,
    this.transactionChecks,
  ) {
    initializeUser();
  }
  final BuildContext context;
  final UserManagementRepository userManagementRepository;
  final TransactionChecks transactionChecks;

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

  void showAddBeneficiarySheet(BuildContext context) {
    if (!checkAddBeneficiaryPossible()) return;
    UserActions().showAddBeneficiarySheet(context);
  }

  bool checkAddBeneficiaryPossible() {
    final AppConfig appConfig = context.read<CoreConfigManager>().appConfig!;
    if (user.beneficiaries.length > appConfig.maxActiveBeneficiaries) {
      return false;
    }
    return true;
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

  void showTransactionSheet(context, Beneficiary beneficiary) {
    UserActions().showTransactionSheet(context, beneficiary);
  }

  Future<bool> makeTransaction({
    required Beneficiary beneficiary,
    required double amount,
    required BuildContext context,
    required AppConfig appConfig,
  }) async {
    TransactionModel tempTransaction = TransactionModel(
      id: 0,
      amount: amount,
      sourceUserId: user.id,
      targetUserPhoneNumber: beneficiary.phoneNumber,
      dateTime: DateTime.now(),
    );

    bool canMakeTransaction = transactionChecks.checkTransactionPossible(
      context,
      transaction: tempTransaction,
      user: user,
      appConfig: appConfig,
    );
    if (!canMakeTransaction) return false;
    debitUserBalance(amount + appConfig.transactionFee);
    TransactionModel? newTransaction =
        await userManagementRepository.makeTransaction(
      transaction: tempTransaction,
    );
    if (newTransaction != null) {
      await updateTransactions(
        beneficiary: beneficiary,
        newTransaction: newTransaction,
      );
      notifyListeners();
    } else {
      debitUserBalance(-(amount + appConfig.transactionFee));
    }
    return newTransaction != null;
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
