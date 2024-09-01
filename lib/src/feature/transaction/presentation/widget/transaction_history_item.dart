import 'package:flutter/material.dart';

import '../../domain/entity/transaction.dart';

/// The item shown in `TransactionHistoryList` to show the transaction details
class TransactionHistoryItem extends StatelessWidget {
  const TransactionHistoryItem({super.key, required this.transaction});
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 18,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              transaction.targetUserPhoneNumber,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              "${transaction.amount.toStringAsFixed(0)} AED",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
