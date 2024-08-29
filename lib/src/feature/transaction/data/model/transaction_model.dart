import '../../domain/entity/transaction.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.amount,
    required super.sourceUserId,
    required super.targetUserPhoneNumber,
    required super.dateTime,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      amount: json['amount'],
      sourceUserId: json['source_user_id'],
      targetUserPhoneNumber: json['target_user_phone'],
      dateTime: DateTime.parse(
        json['date_time'] ?? DateTime.now().toString(),
      ),
    );
  }

  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      amount: transaction.amount,
      sourceUserId: transaction.sourceUserId,
      targetUserPhoneNumber: transaction.targetUserPhoneNumber,
      dateTime: transaction.dateTime,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['id'] = id;
    json['amount'] = amount;
    json['source_user_id'] = sourceUserId;
    json['target_user_phone'] = targetUserPhoneNumber;
    json['date_time'] = dateTime.toString();
    return json;
  }
}
