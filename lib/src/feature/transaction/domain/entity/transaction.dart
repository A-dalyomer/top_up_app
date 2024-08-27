class Transaction {
  Transaction({
    this.id = -1,
    required this.amount,
    required this.sourceUserId,
    required this.targetUserId,
  });
  final int id;
  final double amount;
  final int sourceUserId;
  final int targetUserId;
}
