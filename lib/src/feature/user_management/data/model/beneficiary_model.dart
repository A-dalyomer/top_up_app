import 'package:uae_top_up/src/feature/transaction/data/model/transaction_model.dart';

import '../../domain/entity/beneficiary.dart';

/// Data model for [Beneficiary]
class BeneficiaryModel extends Beneficiary {
  const BeneficiaryModel({
    required super.id,
    required super.name,
    required super.phoneNumber,
    required super.transactions,
    super.active = true,
  });

  /// A factory that parses the [json] to a model object instance
  factory BeneficiaryModel.fromJson(Map<String, dynamic> json) {
    return BeneficiaryModel(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      transactions: List.from(json['transactions'])
          .map((transactionMap) => TransactionModel.fromJson(transactionMap))
          .toList(),
      active: json['active'] ?? true,
    );
  }

  /// A factory that parses the [Beneficiary] entity to a model object instance
  factory BeneficiaryModel.fromEntity(Beneficiary beneficiary) {
    return BeneficiaryModel(
      id: beneficiary.id,
      name: beneficiary.name,
      phoneNumber: beneficiary.phoneNumber,
      transactions: beneficiary.transactions,
      active: beneficiary.active,
    );
  }

  /// Converts instance to a json map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['id'] = id;
    json['name'] = name;
    json['phone_number'] = phoneNumber;
    json['transactions'] = transactions;
    json['active'] = active;
    return json;
  }
}
