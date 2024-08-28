import '../../domain/entity/transaction.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.amount,
    required super.sourceUserId,
    required super.targetUserId,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      amount: json['amount'],
      sourceUserId: json['source_user_id'],
      targetUserId: json['target_user_id'],
    );
  }

  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      amount: transaction.amount,
      sourceUserId: transaction.sourceUserId,
      targetUserId: transaction.targetUserId,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['id'] = id;
    json['amount'] = amount;
    json['source_user_id'] = sourceUserId;
    json['target_user_id'] = targetUserId;
    return json;
  }
}
