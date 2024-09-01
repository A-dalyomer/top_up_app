import 'package:equatable/equatable.dart';

/// Transaction DTO
class Transaction extends Equatable {
  const Transaction({
    this.id = -1,
    required this.amount,
    required this.sourceUserId,
    required this.targetUserPhoneNumber,
    required this.dateTime,
  });

  /// Transaction ID
  final int id;

  /// Transaction amount
  final double amount;

  /// Transaction sender user ID
  final int sourceUserId;

  /// Transaction target user phone number
  final String targetUserPhoneNumber;

  /// Transaction creation date
  final DateTime dateTime;

  @override
  List<Object?> get props => [id, amount, sourceUserId, targetUserPhoneNumber];
}

/// An extension on `Transaction` to create a new instance with change
/// If a parameter is passed, it will be used
/// Otherwise the current instance parameter is used
extension UserEntityExtensions on Transaction {
  Transaction copyWith({
    int? id,
    double? amount,
    int? sourceUserId,
    String? targetUserPhoneNumber,
    DateTime? dateTime,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      sourceUserId: sourceUserId ?? this.sourceUserId,
      targetUserPhoneNumber:
          targetUserPhoneNumber ?? this.targetUserPhoneNumber,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
