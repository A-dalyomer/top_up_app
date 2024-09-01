/// App Configuration DTO
class AppConfig {
  AppConfig({
    required this.maxActiveBeneficiaries,
    required this.receiverNonVerifiedMaxAmount,
    required this.receiverVerifiedMaxAmount,
    required this.senderMaxAmount,
    required this.transactionFee,
  });

  /// Max allowed number of active beneficiaries per user
  final int maxActiveBeneficiaries;

  /// Non verified user max amount per calendar month per beneficiary
  final int receiverNonVerifiedMaxAmount;

  /// verified user max amount per calendar month per beneficiary
  final int receiverVerifiedMaxAmount;

  /// User transaction limit per month for all beneficiaries
  final int senderMaxAmount;

  /// All Top-ups transaction fee
  final int transactionFee;
}
