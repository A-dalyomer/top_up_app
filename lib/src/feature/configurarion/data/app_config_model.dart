import '../domain/entity/app_config.dart';

class AppConfigModel extends AppConfig {
  AppConfigModel({
    required super.maxActiveBeneficiaries,
    required super.receiverNonVerifiedMaxAmount,
    required super.receiverVerifiedMaxAmount,
    required super.senderMaxAmount,
    required super.transactionFee,
  });

  factory AppConfigModel.fromJson(Map<String, dynamic>? json) {
    return AppConfigModel(
      maxActiveBeneficiaries: json?['max_active_beneficiaries'] ?? 5,
      receiverNonVerifiedMaxAmount: json?['non_verified_max_amount'] ?? 500,
      receiverVerifiedMaxAmount: json?['verified_max_amount'] ?? 100,
      senderMaxAmount: json?['send_max_amount'] ?? 3000,
      transactionFee: json?['transaction_fee'] ?? 1,
    );
  }

  factory AppConfigModel.fromEntity(AppConfig appConfig) {
    return AppConfigModel(
      maxActiveBeneficiaries: appConfig.maxActiveBeneficiaries,
      receiverNonVerifiedMaxAmount: appConfig.receiverNonVerifiedMaxAmount,
      receiverVerifiedMaxAmount: appConfig.receiverVerifiedMaxAmount,
      senderMaxAmount: appConfig.senderMaxAmount,
      transactionFee: appConfig.transactionFee,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['max_active_beneficiaries'] = maxActiveBeneficiaries;
    json['non_verified_max_amount'] = receiverNonVerifiedMaxAmount;
    json['verified_max_amount'] = receiverVerifiedMaxAmount;
    json['send_max_amount'] = senderMaxAmount;
    json['transaction_fee'] = transactionFee;
    return json;
  }
}
