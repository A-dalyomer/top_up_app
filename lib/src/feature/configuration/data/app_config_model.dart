import '../domain/entity/app_config.dart';

/// Data model for [AppConfig]
class AppConfigModel extends AppConfig {
  AppConfigModel({
    required super.maxActiveBeneficiaries,
    required super.receiverNonVerifiedMaxAmount,
    required super.receiverVerifiedMaxAmount,
    required super.senderMaxAmount,
    required super.transactionFee,
  });

  /// A factory that parses the [json] to a model object instance
  /// [json] is nullable to allow loading default values when no connection
  factory AppConfigModel.fromJson(Map<String, dynamic>? json) {
    return AppConfigModel(
      maxActiveBeneficiaries: json?['max_active_beneficiaries'] ?? 5,
      receiverNonVerifiedMaxAmount: json?['non_verified_max_amount'] ?? 500,
      receiverVerifiedMaxAmount: json?['verified_max_amount'] ?? 100,
      senderMaxAmount: json?['send_max_amount'] ?? 3000,
      transactionFee: json?['transaction_fee'] ?? 1,
    );
  }

  /// A factory that parses the [appConfig] entity to a model object instance
  factory AppConfigModel.fromEntity(AppConfig appConfig) {
    return AppConfigModel(
      maxActiveBeneficiaries: appConfig.maxActiveBeneficiaries,
      receiverNonVerifiedMaxAmount: appConfig.receiverNonVerifiedMaxAmount,
      receiverVerifiedMaxAmount: appConfig.receiverVerifiedMaxAmount,
      senderMaxAmount: appConfig.senderMaxAmount,
      transactionFee: appConfig.transactionFee,
    );
  }

  /// Converts instance to a json map
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
