import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uae_top_up/src/core/util/dialogs.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';
import 'package:uae_top_up/src/feature/user_management/domain/util/transaction_checks.dart';

import '../../../../../test_helpers.dart';
import 'transaction_checks_test.mocks.dart';

class MockContext extends Mock implements BuildContext {}

@GenerateNiceMocks([MockSpec<Dialogs>()])
void main() {
  late TransactionChecks transactionChecks;
  late MockDialogs mockDialogs;
  late BuildContext mockContext;

  setUp(() {
    mockDialogs = MockDialogs();
    transactionChecks = TransactionChecks(dialogs: mockDialogs);
    mockContext = MockContext();
  });

  group('TransactionChecks', () {
    final transaction = createTestTransaction();
    final appConfig = createTestAppConfig();
    test('Full Transaction checks possible', () {
      final user = createTestUser(beneficiaries: [createTestBeneficiary()]);
      final result = transactionChecks.checkTransactionPossible(
        mockContext,
        transaction: transaction,
        user: user,
        appConfig: appConfig,
      );
      expect(result, isTrue);
      verifyNever(
        mockDialogs.showMessageDialog(
          mockContext,
          AppLocalizations.noEnoughBalance,
        ),
      );
    });

    test('Full transaction checks not possible, exceeds beneficiary limit', () {
      final user = createTestUser(
        balance: 4000,
        beneficiaries: [
          createTestBeneficiary(
            transactions: [createTestTransaction(amount: 3000)],
          )
        ],
      );
      final result = transactionChecks.checkTransactionPossible(
        mockContext,
        transaction: transaction,
        user: user,
        appConfig: appConfig,
      );
      expect(result, isFalse);
      verify(mockDialogs.showMessageDialog(any, any)).called(1);
    });

    /// checkEnoughBalance tests
    test('Enough user balance', () {
      bool enoughBalance = transactionChecks.checkEnoughBalance(
          userBalance: 50, transactionAmount: 5, transactionFee: 1);
      expect(enoughBalance, isTrue);
    });
    test('Not Enough user balance', () {
      bool enoughBalance = transactionChecks.checkEnoughBalance(
        userBalance: 5,
        transactionAmount: 10,
        transactionFee: 1,
      );
      expect(enoughBalance, isFalse);
    });

    /// checkExceedsMonthTransactions tests
    test('Month Transactions not exceeded', () {
      bool monthTransactionsExceeded =
          transactionChecks.checkExceedsMonthTransactions(
        transaction,
        savedUserTransaction: [createTestTransaction(amount: 2900)],
        appConfig: appConfig,
      );
      expect(monthTransactionsExceeded, isFalse);
    });
    test('Month Transactions exceeded', () {
      bool monthTransactionsExceeded =
          transactionChecks.checkExceedsMonthTransactions(
        transaction,
        savedUserTransaction: [createTestTransaction(amount: 3100)],
        appConfig: appConfig,
      );
      expect(monthTransactionsExceeded, isTrue);
    });

    /// checkExceedsBeneficiaryTransactions tests
    test('Beneficiary Month Transactions not exceeded', () {
      bool beneficiaryMonthTransactionsExceeded =
          transactionChecks.checkExceedsBeneficiaryTransactions(
        transaction,
        savedUserBeneficiaries: [createTestBeneficiary()],
        userVerified: true,
        appConfig: appConfig,
      );
      expect(beneficiaryMonthTransactionsExceeded, isFalse);
    });
    test('Beneficiary Month Transactions exceeded', () {
      bool beneficiaryMonthTransactionsExceeded =
          transactionChecks.checkExceedsBeneficiaryTransactions(
        transaction,
        savedUserBeneficiaries: [
          createTestBeneficiary(
            transactions: [createTestTransaction(amount: 600)],
          )
        ],
        userVerified: false,
        appConfig: appConfig,
      );
      expect(beneficiaryMonthTransactionsExceeded, isTrue);
    });

    /// handleBeneficiaryMaxTransaction tests
    test('Beneficiary Month Transactions message Exceeded max', () {
      String beneficiaryExceededMessage =
          transactionChecks.handleBeneficiaryMaxTransaction(
        targetUserPhoneNumber: createTestBeneficiary().phoneNumber,
        dateTime: createTestTransaction().dateTime,
        appConfig: appConfig,
        beneficiaries: [createTestBeneficiary()],
        userVerified: true,
      );
      expect(beneficiaryExceededMessage, AppLocalizations.beneficiaryMaxAmount);
    });
    test('Beneficiary Month Transactions message near max', () {
      String beneficiaryExceededMessage =
          transactionChecks.handleBeneficiaryMaxTransaction(
        targetUserPhoneNumber: createTestBeneficiary().phoneNumber,
        dateTime: createTestTransaction().dateTime,
        appConfig: appConfig,
        beneficiaries: [
          createTestBeneficiary(
            transactions: [createTestTransaction(amount: 1200)],
          )
        ],
        userVerified: true,
      );
      expect(
        beneficiaryExceededMessage,
        AppLocalizations.beneficiaryMaxReached,
      );
    });
  });
}
