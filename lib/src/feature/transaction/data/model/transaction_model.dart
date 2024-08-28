import '../../domain/entity/transaction.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.amount,
    required super.sourceUserId,
    required super.targetUserPhoneNumber,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      amount: json['amount'],
      sourceUserId: json['source_user_id'],
      targetUserPhoneNumber: json['target_user_phone'],
    );
  }

  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      amount: transaction.amount,
      sourceUserId: transaction.sourceUserId,
      targetUserPhoneNumber: transaction.targetUserPhoneNumber,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['id'] = id;
    json['amount'] = amount;
    json['source_user_id'] = sourceUserId;
    json['target_user_phone'] = targetUserPhoneNumber;
    return json;
  }
}
