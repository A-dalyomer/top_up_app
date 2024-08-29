import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uae_top_up/src/feature/transaction/domain/entity/transaction.dart';
import 'package:uae_top_up/src/feature/user_management/presentation/provider/user_management_provider.dart';

class TransactionHistoryList extends StatelessWidget {
  const TransactionHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<UserManagementProvider, int>(
      selector: (context, userProvider) =>
          userProvider.user.transactions.length,
      builder: (context, value, child) {
        final List<Transaction> transactions =
            context.read<UserManagementProvider>().user.transactions;
        return ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final Transaction transaction =
                transactions[transactions.length - 1 - index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
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
              ),
            );
          },
        );
      },
    );
  }
}
