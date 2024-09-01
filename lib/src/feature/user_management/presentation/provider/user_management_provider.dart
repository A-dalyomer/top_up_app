import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uae_top_up/src/feature/configuration/domain/entity/app_config.dart';
import 'package:uae_top_up/src/feature/transaction/data/model/transaction_model.dart';
import 'package:uae_top_up/src/feature/transaction/domain/entity/transaction.dart';
import 'package:uae_top_up/src/feature/user_management/data/model/beneficiary_model.dart';
import 'package:uae_top_up/src/feature/user_management/domain/entity/beneficiary.dart';
import 'package:uae_top_up/src/feature/user_management/domain/util/transaction_checks.dart';

import '../../domain/entity/user.dart';
import '../../domain/repository/user_management_repository.dart';
import '../../domain/util/user_actions.dart';

/// Responsible for user info state and calls for related operations
class UserManagementProvider extends ChangeNotifier {
  UserManagementProvider(
    this.userManagementRepository,
    this.transactionChecks,
    this.userActions,
  ) {
    initializeUser();
  }

  /// User management repository instance for logic operations
  final UserManagementRepository userManagementRepository;

  /// Transaction checks instance for transaction checks operations
  final TransactionChecks transactionChecks;

  /// User actions instance for CTA sheets operations
  final UserActions userActions;

  /// The user info state
  late User user;

  /// App state flags
  ///
  /// Determine if the [initializeUser] has finished
  bool finishedInitialization = false;

  /// Determine if a used saved info exists
  /// therefore show login screen if not
  bool userExists = false;

  /// Initialize user info state from saved info
  /// Performs a refresh info request if possible
  /// if not, uses the saved info
  /// Updates the [finishedInitialization] when finished
  Future<void> initializeUser() async {
    User? savedUser = await userManagementRepository.getCurrentUser();
    if (savedUser != null) {
      final User? refreshedUser = await refreshUser(savedUser);
      await updateUser(refreshedUser ?? savedUser);
    }
    finishedInitialization = true;
    notifyListeners();
  }

  /// Calls the login operation from repository
  /// Then updates the user state if the value is not null
  Future<void> loginUser(
    String phoneNumber,
    String password,
  ) async {
    User? newUser = await userManagementRepository.signInUser(phoneNumber);
    if (newUser != null) {
      await updateUser(newUser);
    }
  }

  /// Refreshes the passed user info from API using the user repository
  /// Then updates the user state if the value is not null
  Future<User?> refreshUser(User user) async {
    User? newUser = await userManagementRepository.signInUser(user.phoneNumber);
    if (newUser != null) {
      await updateUser(newUser);
    }
    return newUser;
  }

  /// Update the saved user info with the passed [newUser] instance info
  Future<void> updateUser(User newUser) async {
    await userManagementRepository.saveUser(newUser: newUser);
    user = newUser;
    userExists = true;
    notifyListeners();
  }

  /// Calls the [removeUser] operation from the user repository
  /// Then updates [userExists] to show the login screen
  Future<void> signOutUser() async {
    await userManagementRepository.removeUser();
    userExists = false;
    notifyListeners();
  }

  /// Shows the add beneficiary transaction if the [checkAddBeneficiaryPossible]
  /// returned true
  /// And Cancels the operation if not
  void showAddBeneficiarySheet(BuildContext context, AppConfig appConfig) {
    if (!checkAddBeneficiaryPossible(appConfig)) return;
    userActions.showAddBeneficiarySheet(context);
  }

  /// Checks if user can add beneficiary by comparing user beneficiaries count
  /// to the [maxActiveBeneficiaries] in the passed [appConfig]
  /// returns true if user can add a beneficiary
  bool checkAddBeneficiaryPossible(AppConfig appConfig) {
    if (user.beneficiaries.length > appConfig.maxActiveBeneficiaries) {
      return false;
    }
    return true;
  }

  /// Adds user [beneficiary] from the add beneficiary sheet
  /// Saves the new beneficiary using the user repository
  /// Adds the beneficiary to user beneficiaries list if succeeded
  /// returns true if adding success
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

  /// Shows transaction sheet from [userActions]
  void showTransactionSheet(context, Beneficiary beneficiary) {
    userActions.showTransactionSheet(context, beneficiary);
  }

  /// Makes the attempted transaction after making all the needed checks
  /// returns true if succeeded
  Future<bool> makeTransaction({
    required Beneficiary beneficiary,
    required double amount,
    required BuildContext context,
    required AppConfig appConfig,
  }) async {
    /// A temporal transaction for transferring the data between layers
    TransactionModel tempTransaction = TransactionModel(
      id: 0,
      amount: amount,
      sourceUserId: user.id,
      targetUserPhoneNumber: beneficiary.phoneNumber,
      dateTime: DateTime.now(),
    );

    /// Make the transaction checks
    bool canMakeTransaction = transactionChecks.checkTransactionPossible(
      context,
      transaction: tempTransaction,
      user: user,
      appConfig: appConfig,
    );

    /// Cancel operation if [canMakeTransaction] returned false
    if (!canMakeTransaction) return false;

    /// Debit user balance before the top-up transaction is attempted
    await debitUserBalance(amount + appConfig.transactionFee);

    /// Make the transaction request
    TransactionModel? newTransaction =
        await userManagementRepository.makeTransaction(
      transaction: tempTransaction,
    );

    /// Transaction request succeeded
    if (newTransaction != null) {
      /// Save transaction to user and contained beneficiary info
      await updateTransactions(
        beneficiary: beneficiary,
        newTransaction: newTransaction,
      );
      notifyListeners();
    } else {
      /// Transaction request failed due to connection or server exception
      /// The error message should be show from the API repository
      /// Return user debited balance
      await debitUserBalance(-(amount + appConfig.transactionFee));
    }
    return newTransaction != null;
  }

  /// Edit local user balance
  Future<void> debitUserBalance(double amount) async {
    final newUser = user.copyWith(balance: user.balance - amount);
    await updateUser(newUser);
  }

  /// Update local beneficiaries list by adding the passed [newBeneficiary]
  /// Then save the new user info
  Future<void> updateBeneficiaries(BeneficiaryModel newBeneficiary) async {
    final List<Beneficiary> updatedBeneficiaries =
        List.from([...user.beneficiaries, newBeneficiary]);
    final newUser = user.copyWith(beneficiaries: updatedBeneficiaries);
    await updateUser(newUser);
  }

  /// Update local transactions by adding the passed [newBeneficiary]
  /// to user and beneficiary transaction lists
  /// Then save the new user info
  Future<void> updateTransactions({
    required Beneficiary beneficiary,
    required TransactionModel newTransaction,
  }) async {
    final List<Transaction> updatedTransactions = List.from([
      ...user.transactions,
      newTransaction,
    ]);
    final Beneficiary updatedBeneficiary = _updateBeneficiaryTransactions(
      beneficiary,
      newTransaction: newTransaction,
    );
    user = user.copyWith(
      transactions: updatedTransactions,
      beneficiaries: [
        ...user.beneficiaries,
        updatedBeneficiary,
      ],
    );
    await userManagementRepository.saveUser(newUser: user);
  }

  /// Adds a new transaction to the beneficiary transactions list
  /// Then returns the new beneficiary instance
  Beneficiary _updateBeneficiaryTransactions(
    Beneficiary beneficiary, {
    required TransactionModel newTransaction,
  }) {
    final List<Transaction> updatedBeneficiaryTransactions = List.from([
      ...user.transactions,
      newTransaction,
    ]);
    final updatedBeneficiary = beneficiary.copyWith(
      transactions: updatedBeneficiaryTransactions,
    );
    return updatedBeneficiary;
  }
}
