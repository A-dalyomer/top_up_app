abstract class TransactionRepository {
  /// Make a transaction with the [amount] to the specified [beneficiaryId]
  /// returns [true] in case of success with no exceptions or errors
  Future<bool> makeTransaction({
    required double amount,
    required int targetUserId,
  });
}
