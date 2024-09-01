import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uae_top_up/src/feature/user_management/data/model/user_model.dart';
import 'package:uae_top_up/src/feature/user_management/domain/entity/user.dart';
import 'package:uae_top_up/src/feature/user_management/domain/repository/user_management_repository.dart';
import 'package:uae_top_up/src/feature/user_management/domain/util/transaction_checks.dart';
import 'package:uae_top_up/src/feature/user_management/domain/util/user_actions.dart';
import 'package:uae_top_up/src/feature/user_management/presentation/provider/user_management_provider.dart';

import '../../../../../test_helpers.dart';
import 'user_management_provider_test.mocks.dart';

class MockBuildContext extends Mock implements BuildContext {}

@GenerateNiceMocks([
  MockSpec<UserManagementRepository>(),
  MockSpec<TransactionChecks>(),
  MockSpec<UserActions>()
])
void main() {
  late UserManagementProvider userManagementProvider;
  late MockUserManagementRepository userManagementRepository;
  late MockTransactionChecks transactionChecks;
  late MockUserActions userActions;

  setUp(() {
    userManagementRepository = MockUserManagementRepository();
    transactionChecks = MockTransactionChecks();
    userActions = MockUserActions();
    userManagementProvider = UserManagementProvider(
      userManagementRepository,
      transactionChecks,
      userActions,
    );
  });

  group('UserManagementProvider', () {
    test('User init exists', () async {
      when(userManagementRepository.getCurrentUser()).thenAnswer(
        (_) async => createTestUser(),
      );

      await userManagementProvider.initializeUser();
      expect(userManagementProvider.finishedInitialization, isTrue);
      expect(userManagementProvider.userExists, isTrue);
      expect(userManagementProvider.user, isA<User>());
    });

    test('User login', () async {
      final User testUser = createTestUser();

      when(userManagementRepository.signInUser(any)).thenAnswer(
        (_) async => testUser,
      );

      await userManagementProvider.loginUser(testUser.phoneNumber, "12345678");
      expect(userManagementProvider.user, testUser);
    });
    test('User refresh', () async {
      final User testUser = createTestUser();

      when(userManagementRepository.signInUser(any)).thenAnswer(
        (_) async => testUser,
      );

      await userManagementProvider.refreshUser(testUser);
      expect(userManagementProvider.user, testUser);
    });

    test('User Sign out', () async {
      await userManagementProvider.signOutUser();
      expect(userManagementProvider.userExists, isFalse);
    });

    test('User check add Beneficiary possible', () async {
      final appConfig = createTestAppConfig();
      final testUser = createTestUser();
      when(userManagementRepository.signInUser(testUser.phoneNumber))
          .thenAnswer(
        (_) async => UserModel.fromEntity(testUser),
      );
      await userManagementProvider.refreshUser(createTestUser());
      final bool addPossible =
          userManagementProvider.checkAddBeneficiaryPossible(appConfig);
      expect(addPossible, isTrue);
    });
    test('User check add Beneficiary not possible', () async {
      final appConfig = createTestAppConfig();
      final testUser = createTestUser(
        beneficiaries: List.filled(10, createTestBeneficiary()),
      );
      when(userManagementRepository.signInUser(testUser.phoneNumber))
          .thenAnswer(
        (_) async => UserModel.fromEntity(testUser),
      );
      await userManagementProvider.refreshUser(testUser);
      final bool addPossible =
          userManagementProvider.checkAddBeneficiaryPossible(
        appConfig,
      );
      expect(addPossible, isFalse);
    });

    test('User Add Beneficiary success', () async {
      final testUser = createTestUser();
      final testBeneficiary = createTestBeneficiary();

      when(
        userManagementRepository.addBeneficiary(
          name: anyNamed('name'),
          phoneNumber: anyNamed('phoneNumber'),
          senderPhoneNumber: anyNamed('senderPhoneNumber'),
        ),
      ).thenAnswer((_) async => testBeneficiary);

      userManagementProvider.user = testUser;
      final bool addedBeneficiary = await userManagementProvider.addBeneficiary(
        testBeneficiary,
      );
      expect(addedBeneficiary, isTrue);
    });
    test('User Add Beneficiary fails', () async {
      final testUser = createTestUser();
      final testBeneficiary = createTestBeneficiary();

      when(
        userManagementRepository.addBeneficiary(
          name: anyNamed('name'),
          phoneNumber: anyNamed('phoneNumber'),
          senderPhoneNumber: anyNamed('senderPhoneNumber'),
        ),
      ).thenAnswer((_) async => null);

      userManagementProvider.user = testUser;
      final bool addedBeneficiary = await userManagementProvider.addBeneficiary(
        testBeneficiary,
      );
      expect(addedBeneficiary, isFalse);
    });

    test('User Remove Beneficiary success', () async {
      final testBeneficiary = createTestBeneficiary();
      final testUser = createTestUser(beneficiaries: [testBeneficiary]);
      userManagementProvider.user = testUser;

      when(
        userManagementRepository.removeBeneficiary(
          senderPhoneNumber: anyNamed('senderPhoneNumber'),
          beneficiary: anyNamed("beneficiary"),
        ),
      ).thenAnswer((_) async => true);

      await userManagementProvider.removeBeneficiary(
        testBeneficiary,
      );
      expect(userManagementProvider.user.beneficiaries.length, 0);
    });
    test('User Remove Beneficiary fails', () async {
      final testBeneficiary = createTestBeneficiary();
      final testUser = createTestUser(beneficiaries: [testBeneficiary]);
      userManagementProvider.user = testUser;

      when(
        userManagementRepository.removeBeneficiary(
          senderPhoneNumber: anyNamed('senderPhoneNumber'),
          beneficiary: anyNamed("beneficiary"),
        ),
      ).thenAnswer((_) async => false);

      await userManagementProvider.removeBeneficiary(
        testBeneficiary,
      );
      expect(userManagementProvider.user.beneficiaries.length, 1);
    });

    test('User Make transaction success', () async {
      final beneficiary = createTestBeneficiary();
      final testUser = createTestUser(beneficiaries: [beneficiary]);
      final appConfig = createTestAppConfig();
      final testTransaction = createTestTransaction(amount: 10);
      final MockBuildContext mockContext = MockBuildContext();

      when(
        userManagementRepository.makeTransaction(
          transaction: anyNamed('transaction'),
        ),
      ).thenAnswer((_) async => testTransaction);
      when(
        transactionChecks.checkTransactionPossible(
          any,
          transaction: anyNamed('transaction'),
          user: anyNamed('user'),
          appConfig: anyNamed('appConfig'),
        ),
      ).thenReturn(true);
      userManagementProvider.user = testUser;

      final bool transactionMade = await userManagementProvider.makeTransaction(
        beneficiary: beneficiary,
        amount: testTransaction.amount,
        context: mockContext,
        appConfig: appConfig,
      );
      expect(transactionMade, isTrue);
      expect(
        userManagementProvider.user.balance,
        testUser.balance - appConfig.transactionFee - testTransaction.amount,
      );
    });
    test('User Make transaction fails', () async {
      final beneficiary = createTestBeneficiary();
      final testUser = createTestUser(beneficiaries: [beneficiary]);
      final appConfig = createTestAppConfig();
      final testTransaction = createTestTransaction(amount: 10);
      final MockBuildContext mockContext = MockBuildContext();

      when(
        userManagementRepository.makeTransaction(
          transaction: anyNamed('transaction'),
        ),
      ).thenAnswer((_) async => null);
      when(
        transactionChecks.checkTransactionPossible(
          any,
          transaction: anyNamed('transaction'),
          user: anyNamed('user'),
          appConfig: anyNamed('appConfig'),
        ),
      ).thenReturn(true);
      userManagementProvider.user = testUser;

      final bool transactionMade = await userManagementProvider.makeTransaction(
        beneficiary: beneficiary,
        amount: testTransaction.amount,
        context: mockContext,
        appConfig: appConfig,
      );
      expect(transactionMade, isFalse);
      expect(
        userManagementProvider.user.balance,
        testUser.balance,
      );
    });
  });
}
