class AppConfig {
  AppConfig({
    required this.maxActiveBeneficiaries,
    required this.receiverNonVerifiedMaxAmount,
    required this.receiverVerifiedMaxAmount,
    required this.senderMaxAmount,
    required this.transactionFee,
  });

  final int maxActiveBeneficiaries;
  final int receiverNonVerifiedMaxAmount;
  final int receiverVerifiedMaxAmount;
  final int senderMaxAmount;
  final int transactionFee;
}
