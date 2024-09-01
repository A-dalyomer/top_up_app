import 'package:equatable/equatable.dart';
import 'package:uae_top_up/src/feature/transaction/domain/entity/transaction.dart';

import 'beneficiary.dart';

/// User DTO
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

  /// User ID
  final int id;

  /// User name
  final String name;

  /// User phone number
  final String phoneNumber;

  /// User verification state 'verification flag'
  final bool isVerified;

  /// User balance
  final double balance;

  /// User monthly top ups
  final double monthlyTopUps;

  /// User registered beneficiaries list
  final List<Beneficiary> beneficiaries;

  /// User saved transactions list
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

/// An extension on `User` to create a new instance with change
/// If a parameter is passed, it will be used
/// Otherwise the current instance parameter is used
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
