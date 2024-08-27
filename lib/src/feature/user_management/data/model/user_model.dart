import 'package:uae_top_up/src/feature/transaction/data/model/transaction_model.dart';

import '../../domain/entity/user.dart';
import 'beneficiary_model.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.phoneNumber,
    required super.isVerified,
    required super.balance,
    required super.monthlyTopUps,
    required super.beneficiaries,
    required super.transactions,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      isVerified: json['verified'],
      balance: json['balance'],
      monthlyTopUps: json['month_top_ups'],
      beneficiaries: List.from(json['beneficiaries'])
          .map((beneficiaryMap) => BeneficiaryModel.fromJson(beneficiaryMap))
          .toList(),
      transactions: List.from(json['transactions'])
          .map((transactionMap) => TransactionModel.fromJson(transactionMap))
          .toList(),
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      phoneNumber: user.phoneNumber,
      isVerified: user.isVerified,
      balance: user.balance,
      monthlyTopUps: user.monthlyTopUps,
      beneficiaries: user.beneficiaries,
      transactions: user.transactions,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['id'] = id;
    json['name'] = name;
    json['phone_number'] = phoneNumber;
    json['verified'] = isVerified;
    json['balance'] = balance;
    json['month_top_ups'] = monthlyTopUps;
    json['beneficiaries'] = beneficiaries
        .map((e) => BeneficiaryModel.fromEntity(e).toJson())
        .toList();
    json['transactions'] = transactions
        .map((e) => TransactionModel.fromEntity(e).toJson())
        .toList();
    return json;
  }
}
