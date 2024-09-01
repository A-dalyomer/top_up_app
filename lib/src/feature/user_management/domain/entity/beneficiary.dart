import 'package:equatable/equatable.dart';
import 'package:uae_top_up/src/feature/transaction/domain/entity/transaction.dart';

/// Beneficiary DTO
class Beneficiary extends Equatable {
  const Beneficiary({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.transactions,
    required this.active,
  });

  /// Beneficiary ID
  final int id;

  /// Beneficiary name
  final String name;

  /// Beneficiary phone number
  final String phoneNumber;

  /// Beneficiary saved transactions
  final List<Transaction> transactions;

  /// Is active flag
  final bool active;

  @override
  List<Object?> get props => [id, name, phoneNumber];
}

/// An extension on `Beneficiary` to create a new instance with change
/// If a parameter is passed, it will be used
/// Otherwise the current instance parameter is used
extension BeneficiaryEntityExtensions on Beneficiary {
  Beneficiary copyWith({
    int? id,
    String? name,
    String? phoneNumber,
    List<Transaction>? transactions,
    bool? active,
  }) {
    return Beneficiary(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      transactions: transactions ?? this.transactions,
      active: active ?? this.active,
    );
  }
}
