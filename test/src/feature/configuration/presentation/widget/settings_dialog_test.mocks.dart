// Mocks generated by Mockito 5.4.4 from annotations
// in uae_top_up/test/src/feature/configuration/presentation/widget/settings_dialog_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:flutter/material.dart' as _i10;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i14;
import 'package:uae_top_up/src/core/util/dialogs.dart' as _i2;
import 'package:uae_top_up/src/feature/configuration/domain/entity/app_config.dart'
    as _i12;
import 'package:uae_top_up/src/feature/transaction/data/model/transaction_model.dart'
    as _i8;
import 'package:uae_top_up/src/feature/transaction/domain/entity/transaction.dart'
    as _i13;
import 'package:uae_top_up/src/feature/user_management/data/model/beneficiary_model.dart'
    as _i6;
import 'package:uae_top_up/src/feature/user_management/domain/entity/beneficiary.dart'
    as _i7;
import 'package:uae_top_up/src/feature/user_management/domain/entity/user.dart'
    as _i5;
import 'package:uae_top_up/src/feature/user_management/domain/repository/user_management_repository.dart'
    as _i3;
import 'package:uae_top_up/src/feature/user_management/domain/util/transaction_checks.dart'
    as _i11;
import 'package:uae_top_up/src/feature/user_management/domain/util/user_actions.dart'
    as _i9;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDialogs_0 extends _i1.SmartFake implements _i2.Dialogs {
  _FakeDialogs_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [UserManagementRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserManagementRepository extends _i1.Mock
    implements _i3.UserManagementRepository {
  @override
  _i4.Future<_i5.User?> getCurrentUser() => (super.noSuchMethod(
        Invocation.method(
          #getCurrentUser,
          [],
        ),
        returnValue: _i4.Future<_i5.User?>.value(),
        returnValueForMissingStub: _i4.Future<_i5.User?>.value(),
      ) as _i4.Future<_i5.User?>);

  @override
  _i4.Future<_i5.User?> signInUser(String? phoneNumber) => (super.noSuchMethod(
        Invocation.method(
          #signInUser,
          [phoneNumber],
        ),
        returnValue: _i4.Future<_i5.User?>.value(),
        returnValueForMissingStub: _i4.Future<_i5.User?>.value(),
      ) as _i4.Future<_i5.User?>);

  @override
  _i4.Future<void> saveUser({required _i5.User? newUser}) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveUser,
          [],
          {#newUser: newUser},
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> removeUser() => (super.noSuchMethod(
        Invocation.method(
          #removeUser,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<bool> changeBalance(
    double? amount, {
    required _i5.User? currentUser,
    required _i3.UserBalanceChangeTypes? changeType,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #changeBalance,
          [amount],
          {
            #currentUser: currentUser,
            #changeType: changeType,
          },
        ),
        returnValue: _i4.Future<bool>.value(false),
        returnValueForMissingStub: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);

  @override
  _i4.Future<_i6.BeneficiaryModel?> addBeneficiary({
    required String? name,
    required String? phoneNumber,
    required String? senderPhoneNumber,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #addBeneficiary,
          [],
          {
            #name: name,
            #phoneNumber: phoneNumber,
            #senderPhoneNumber: senderPhoneNumber,
          },
        ),
        returnValue: _i4.Future<_i6.BeneficiaryModel?>.value(),
        returnValueForMissingStub: _i4.Future<_i6.BeneficiaryModel?>.value(),
      ) as _i4.Future<_i6.BeneficiaryModel?>);

  @override
  _i4.Future<bool> removeBeneficiary({
    required _i7.Beneficiary? beneficiary,
    required String? senderPhoneNumber,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #removeBeneficiary,
          [],
          {
            #beneficiary: beneficiary,
            #senderPhoneNumber: senderPhoneNumber,
          },
        ),
        returnValue: _i4.Future<bool>.value(false),
        returnValueForMissingStub: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);

  @override
  _i4.Future<_i8.TransactionModel?> makeTransaction(
          {required _i8.TransactionModel? transaction}) =>
      (super.noSuchMethod(
        Invocation.method(
          #makeTransaction,
          [],
          {#transaction: transaction},
        ),
        returnValue: _i4.Future<_i8.TransactionModel?>.value(),
        returnValueForMissingStub: _i4.Future<_i8.TransactionModel?>.value(),
      ) as _i4.Future<_i8.TransactionModel?>);
}

/// A class which mocks [UserActions].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserActions extends _i1.Mock implements _i9.UserActions {
  @override
  void showAddBeneficiarySheet(_i10.BuildContext? context) =>
      super.noSuchMethod(
        Invocation.method(
          #showAddBeneficiarySheet,
          [context],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void showTransactionSheet(
    _i10.BuildContext? context,
    _i7.Beneficiary? beneficiary,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #showTransactionSheet,
          [
            context,
            beneficiary,
          ],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [TransactionChecks].
///
/// See the documentation for Mockito's code generation for more information.
class MockTransactionChecks extends _i1.Mock implements _i11.TransactionChecks {
  @override
  _i2.Dialogs get dialogs => (super.noSuchMethod(
        Invocation.getter(#dialogs),
        returnValue: _FakeDialogs_0(
          this,
          Invocation.getter(#dialogs),
        ),
        returnValueForMissingStub: _FakeDialogs_0(
          this,
          Invocation.getter(#dialogs),
        ),
      ) as _i2.Dialogs);

  @override
  bool checkTransactionPossible(
    _i10.BuildContext? context, {
    required _i8.TransactionModel? transaction,
    required _i5.User? user,
    required _i12.AppConfig? appConfig,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #checkTransactionPossible,
          [context],
          {
            #transaction: transaction,
            #user: user,
            #appConfig: appConfig,
          },
        ),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  bool checkEnoughBalance({
    required double? userBalance,
    required double? transactionAmount,
    required int? transactionFee,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #checkEnoughBalance,
          [],
          {
            #userBalance: userBalance,
            #transactionAmount: transactionAmount,
            #transactionFee: transactionFee,
          },
        ),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  bool checkExceedsMonthTransactions(
    _i13.Transaction? transaction, {
    required List<_i13.Transaction>? savedUserTransaction,
    required _i12.AppConfig? appConfig,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #checkExceedsMonthTransactions,
          [transaction],
          {
            #savedUserTransaction: savedUserTransaction,
            #appConfig: appConfig,
          },
        ),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  double getTotalUserMonthTransactions(
    List<_i13.Transaction>? savedUserTransaction,
    DateTime? transactionDateMonth,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getTotalUserMonthTransactions,
          [
            savedUserTransaction,
            transactionDateMonth,
          ],
        ),
        returnValue: 0.0,
        returnValueForMissingStub: 0.0,
      ) as double);

  @override
  bool checkExceedsBeneficiaryTransactions(
    _i13.Transaction? transaction, {
    required List<_i7.Beneficiary>? savedUserBeneficiaries,
    required dynamic userVerified,
    required _i12.AppConfig? appConfig,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #checkExceedsBeneficiaryTransactions,
          [transaction],
          {
            #savedUserBeneficiaries: savedUserBeneficiaries,
            #userVerified: userVerified,
            #appConfig: appConfig,
          },
        ),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  double getTotalBeneficiaryTransactions({
    required String? targetUserPhoneNumber,
    required DateTime? transactionDateMonth,
    required List<_i7.Beneficiary>? savedUserBeneficiaries,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getTotalBeneficiaryTransactions,
          [],
          {
            #targetUserPhoneNumber: targetUserPhoneNumber,
            #transactionDateMonth: transactionDateMonth,
            #savedUserBeneficiaries: savedUserBeneficiaries,
          },
        ),
        returnValue: 0.0,
        returnValueForMissingStub: 0.0,
      ) as double);

  @override
  String handleBeneficiaryMaxTransaction({
    required String? targetUserPhoneNumber,
    required DateTime? dateTime,
    required _i12.AppConfig? appConfig,
    required List<_i7.Beneficiary>? beneficiaries,
    required bool? userVerified,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #handleBeneficiaryMaxTransaction,
          [],
          {
            #targetUserPhoneNumber: targetUserPhoneNumber,
            #dateTime: dateTime,
            #appConfig: appConfig,
            #beneficiaries: beneficiaries,
            #userVerified: userVerified,
          },
        ),
        returnValue: _i14.dummyValue<String>(
          this,
          Invocation.method(
            #handleBeneficiaryMaxTransaction,
            [],
            {
              #targetUserPhoneNumber: targetUserPhoneNumber,
              #dateTime: dateTime,
              #appConfig: appConfig,
              #beneficiaries: beneficiaries,
              #userVerified: userVerified,
            },
          ),
        ),
        returnValueForMissingStub: _i14.dummyValue<String>(
          this,
          Invocation.method(
            #handleBeneficiaryMaxTransaction,
            [],
            {
              #targetUserPhoneNumber: targetUserPhoneNumber,
              #dateTime: dateTime,
              #appConfig: appConfig,
              #beneficiaries: beneficiaries,
              #userVerified: userVerified,
            },
          ),
        ),
      ) as String);
}
