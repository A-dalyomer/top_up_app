import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  const Transaction({
    this.id = -1,
    required this.amount,
    required this.sourceUserId,
    required this.targetUserId,
  });
  final int id;
  final double amount;
  final int sourceUserId;
  final int targetUserId;

  @override
  List<Object?> get props => [id, amount, sourceUserId, targetUserId];
}
