import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uae_top_up/src/feature/local_storage/domain/repository/local_storage_repository.dart';
import 'package:uae_top_up/src/feature/network/domain/repository/api_request_repository.dart';
import 'package:uae_top_up/src/feature/transaction/data/model/transaction_model.dart';
import 'package:uae_top_up/src/feature/transaction/domain/repository/transaction_repository.dart';
import 'package:uae_top_up/src/feature/user_management/data/model/beneficiary_model.dart';
import 'package:uae_top_up/src/feature/user_management/data/model/user_model.dart';
import 'package:uae_top_up/src/feature/user_management/data/repository/user_management_repository_impl.dart';
import 'package:uae_top_up/src/feature/user_management/domain/entity/beneficiary.dart';
import 'package:uae_top_up/src/feature/user_management/domain/entity/user.dart';
import 'package:uae_top_up/src/feature/user_management/domain/repository/user_management_repository.dart';

import '../../../../../test_helpers.dart';
import 'user_management_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LocalStorageRepository>(),
  MockSpec<ApiRequestRepository>(),
  MockSpec<TransactionRepository>(),
])
void main() {
  late UserManagementRepositoryImpl userManagementProvider;
  late MockLocalStorageRepository mockStorage;
  late MockApiRequestRepository mockApiRequestRepository;
  late MockTransactionRepository mockTransactionRepository;

  setUp(() {
    mockStorage = MockLocalStorageRepository();
    mockApiRequestRepository = MockApiRequestRepository();
    mockTransactionRepository = MockTransactionRepository();
    userManagementProvider = UserManagementRepositoryImpl(
      mockStorage,
      apiRequestRepository: mockApiRequestRepository,
      transactionRepository: mockTransactionRepository,
    );
  });

  group('UserManagementRepositoryImpl', () {
    test('Change Balance success', () async {
      when(mockApiRequestRepository.postRequest(any, body: anyNamed("body")))
          .thenAnswer((_) async => {"success": true});
      final bool didChange = await userManagementProvider.changeBalance(
        100,
        currentUser: createTestUser(),
        changeType: UserBalanceChangeTypes.add,
      );

      expect(didChange, isTrue);
    });
    test('Change Balance fails', () async {
      when(mockApiRequestRepository.postRequest(any))
          .thenAnswer((_) async => null);
      final bool didChange = await userManagementProvider.changeBalance(
        100,
        currentUser: createTestUser(),
        changeType: UserBalanceChangeTypes.add,
      );

      expect(didChange, isFalse);
    });

    test('Add beneficiary success', () async {
      final Beneficiary beneficiary = createTestBeneficiary();
      final resultBeneficiary = createTestBeneficiary(id: 10);

      when(mockApiRequestRepository.postRequest(
        any,
        body: anyNamed("body"),
      )).thenAnswer((_) async => resultBeneficiary.toJson());
      BeneficiaryModel? newBeneficiary =
          await userManagementProvider.addBeneficiary(
        name: beneficiary.name,
        phoneNumber: beneficiary.phoneNumber,
        senderPhoneNumber: createTestUser().phoneNumber,
      );

      expect(newBeneficiary, resultBeneficiary);
    });
    test('Add beneficiary fails', () async {
      final Beneficiary beneficiary = createTestBeneficiary();

      when(mockApiRequestRepository.postRequest(any))
          .thenAnswer((_) async => null);
      BeneficiaryModel? newBeneficiary =
          await userManagementProvider.addBeneficiary(
        name: beneficiary.name,
        phoneNumber: beneficiary.phoneNumber,
        senderPhoneNumber: createTestUser().phoneNumber,
      );

      expect(newBeneficiary, isNull);
    });

    test('Create transaction', () async {
      final TransactionModel resultTransaction = createTestTransaction();

      when(
        mockTransactionRepository.makeTransaction(
          transaction: anyNamed("transaction"),
        ),
      ).thenAnswer((_) async => resultTransaction);
      TransactionModel? newTransaction =
          await userManagementProvider.makeTransaction(
        transaction: resultTransaction,
      );

      expect(newTransaction, resultTransaction);
    });

    test('Get saved user success', () async {
      final UserModel testSavedUser = UserModel.fromEntity(createTestUser());

      when(
        mockStorage.readValue(any),
      ).thenAnswer(
        (_) async => jsonEncode(testSavedUser.toJson()),
      );
      User? savedUser = await userManagementProvider.getCurrentUser();

      expect(savedUser, testSavedUser);
    });
    test('Get saved user fails', () async {
      when(
        mockStorage.readValue(any),
      ).thenAnswer((_) async => null);
      User? savedUser = await userManagementProvider.getCurrentUser();

      expect(savedUser, null);
    });

    test('Save user success', () async {
      final User newUser = createTestUser();

      saveUser() async =>
          await userManagementProvider.saveUser(newUser: newUser);

      expect(saveUser, returnsNormally);
    });

    test('Sign in user success', () async {
      final UserModel newUser = UserModel.fromEntity(createTestUser());

      when(
        mockApiRequestRepository.postRequest(any, body: anyNamed('body')),
      ).thenAnswer((_) async => newUser.toJson());
      final User? resultUser = await userManagementProvider.signInUser(
        newUser.phoneNumber,
      );

      expect(resultUser, newUser);
    });
    test('Sign in user fails', () async {
      final UserModel newUser = UserModel.fromEntity(createTestUser());

      when(
        mockApiRequestRepository.postRequest(any, body: anyNamed('body')),
      ).thenAnswer((_) async => null);
      final User? resultUser = await userManagementProvider.signInUser(
        newUser.phoneNumber,
      );

      expect(resultUser, isNull);
    });

    test('Remove user', () async {
      when(
        mockStorage.removeValue(any),
      ).thenAnswer((_) async {});
      removeUser() async => await userManagementProvider.removeUser();

      expect(removeUser, returnsNormally);
    });
  });
}
