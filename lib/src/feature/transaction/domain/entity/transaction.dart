import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  const Transaction({
    this.id = -1,
    required this.amount,
    required this.sourceUserId,
    required this.targetUserPhoneNumber,
  });
  final int id;
  final double amount;
  final int sourceUserId;
  final String targetUserPhoneNumber;

  @override
  List<Object?> get props => [id, amount, sourceUserId, targetUserPhoneNumber];
}

extension UserEntityExtensions on Transaction {
  Transaction copyWith({
    int? id,
    double? amount,
    int? sourceUserId,
    String? targetUserPhoneNumber,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      sourceUserId: sourceUserId ?? this.sourceUserId,
      targetUserPhoneNumber:
          targetUserPhoneNumber ?? this.targetUserPhoneNumber,
    );
  }
}
