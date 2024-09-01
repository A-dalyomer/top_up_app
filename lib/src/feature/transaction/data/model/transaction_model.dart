import '../../domain/entity/transaction.dart';

/// Data model for [Transaction]
class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.amount,
    required super.sourceUserId,
    required super.targetUserPhoneNumber,
    required super.dateTime,
  });

  /// A factory that parses the [json] to a model object instance
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

  /// A factory that parses the [Transaction] entity to a model object instance
  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      amount: transaction.amount,
      sourceUserId: transaction.sourceUserId,
      targetUserPhoneNumber: transaction.targetUserPhoneNumber,
      dateTime: transaction.dateTime,
    );
  }

  /// Converts instance to a json map
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
