import 'package:uae_top_up/src/feature/transaction/data/model/transaction_model.dart';

import '../../domain/entity/beneficiary.dart';

class BeneficiaryModel extends Beneficiary {
  const BeneficiaryModel({
    required super.id,
    required super.name,
    required super.phoneNumber,
    required super.transactions,
  });
  factory BeneficiaryModel.fromJson(Map<String, dynamic> json) {
    return BeneficiaryModel(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      transactions: List.from(json['transactions'])
          .map((transactionMap) => TransactionModel.fromJson(transactionMap))
          .toList(),
    );
  }

  factory BeneficiaryModel.fromEntity(Beneficiary beneficiary) {
    return BeneficiaryModel(
      id: beneficiary.id,
      name: beneficiary.name,
      phoneNumber: beneficiary.phoneNumber,
      transactions: beneficiary.transactions,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['id'] = id;
    json['name'] = name;
    json['phone_number'] = phoneNumber;
    json['transactions'] = transactions;
    return json;
  }
}
