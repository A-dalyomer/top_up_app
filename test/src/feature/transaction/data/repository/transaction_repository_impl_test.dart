import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:uae_top_up/src/feature/transaction/data/model/transaction_model.dart';
import 'package:uae_top_up/src/feature/transaction/data/repository/transaction_repository_impl.dart';
import 'package:uae_top_up/src/feature/transaction/domain/entity/transaction.dart';
import 'package:uae_top_up/src/feature/transaction/domain/repository/transaction_repository.dart';

import '../../../../../test_helpers.dart';
import '../../../user_management/data/repository/user_management_repository_impl_test.mocks.dart';

void main() {
  late TransactionRepository transactionRepository;
  late MockApiRequestRepository apiRequestRepository;

  setUp(() {
    apiRequestRepository = MockApiRequestRepository();
    transactionRepository = TransactionRepositoryImpl(
      apiRequestRepository: apiRequestRepository,
    );
  });

  group('TransactionRepositoryImpl', () {
    test('Make transaction success', () async {
      final Transaction newTransaction = createTestTransaction();

      final TransactionModel resultTransaction =
          TransactionModel.fromEntity(newTransaction.copyWith(id: 10));

      when(
        apiRequestRepository.postRequest(any, body: anyNamed('body')),
      ).thenAnswer((_) async => resultTransaction.toJson());

      final TransactionModel? madeTransaction = await transactionRepository
          .makeTransaction(transaction: newTransaction);

      expect(madeTransaction, resultTransaction);
    });
    test('Make transaction fails', () async {
      final Transaction newTransaction = createTestTransaction();

      when(
        apiRequestRepository.postRequest(any, body: anyNamed('body')),
      ).thenAnswer((_) async => null);

      final TransactionModel? madeTransaction = await transactionRepository
          .makeTransaction(transaction: newTransaction);

      expect(madeTransaction, isNull);
    });

    test('Make transaction fails with parse exception', () async {
      final Transaction newTransaction = createTestTransaction();

      when(
        apiRequestRepository.postRequest(any, body: anyNamed('body')),
      ).thenAnswer((_) async => {});

      final TransactionModel? madeTransaction = await transactionRepository
          .makeTransaction(transaction: newTransaction);

      expect(madeTransaction, isNull);
    });
  });
}
