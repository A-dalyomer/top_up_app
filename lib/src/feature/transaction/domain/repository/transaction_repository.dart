import '../../data/model/transaction_model.dart';
import '../entity/transaction.dart';

abstract class TransactionRepository {
  /// Make a transaction with the [amount] to the specified [beneficiaryId]
  /// returns [true] in case of success with no exceptions or errors
  Future<TransactionModel?> makeTransaction({
    required Transaction transaction,
  });
}
