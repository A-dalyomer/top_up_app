import 'package:equatable/equatable.dart';
import 'package:uae_top_up/src/feature/transaction/domain/entity/transaction.dart';

class Beneficiary extends Equatable {
  const Beneficiary({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.transactions,
  });
  final int id;
  final String name;
  final String phoneNumber;
  final List<Transaction> transactions;

  @override
  List<Object?> get props => [id, name, phoneNumber];
}

extension BeneficiaryEntityExtensions on Beneficiary {
  Beneficiary copyWith({
    int? id,
    String? name,
    String? phoneNumber,
    List<Transaction>? transactions,
  }) {
    return Beneficiary(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      transactions: transactions ?? this.transactions,
    );
  }
}
