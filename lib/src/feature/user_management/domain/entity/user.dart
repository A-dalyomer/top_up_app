import 'package:equatable/equatable.dart';
import 'package:uae_top_up/src/feature/transaction/domain/entity/transaction.dart';

import 'beneficiary.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.isVerified,
    required this.balance,
    required this.monthlyTopUps,
    required this.beneficiaries,
    required this.transactions,
  });
  final int id;
  final String name;
  final String phoneNumber;
  final bool isVerified;
  final double balance;
  final double monthlyTopUps;
  final List<Beneficiary> beneficiaries;
  final List<Transaction> transactions;

  @override
  List<Object?> get props => [
        id,
        name,
        phoneNumber,
        isVerified,
        balance,
        monthlyTopUps,
        beneficiaries.length,
        transactions.length,
      ];
}

extension UserEntityExtensions on User {
  User copyWith({
    int? id,
    String? name,
    String? phoneNumber,
    bool? isVerified,
    double? balance,
    double? monthlyTopUps,
    List<Beneficiary>? beneficiaries,
    List<Transaction>? transactions,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isVerified: isVerified ?? this.isVerified,
      balance: balance ?? this.balance,
      monthlyTopUps: monthlyTopUps ?? this.monthlyTopUps,
      beneficiaries: beneficiaries ?? this.beneficiaries,
      transactions: transactions ?? this.transactions,
    );
  }
}
