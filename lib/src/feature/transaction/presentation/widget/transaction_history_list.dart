import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';
import 'package:uae_top_up/src/feature/transaction/domain/entity/transaction.dart';
import 'package:uae_top_up/src/feature/transaction/presentation/widget/empty_transaction_history.dart';
import 'package:uae_top_up/src/feature/transaction/presentation/widget/transaction_history_item.dart';
import 'package:uae_top_up/src/feature/user_management/presentation/provider/user_management_provider.dart';

/// User transaction history list
class TransactionHistoryList extends StatelessWidget {
  const TransactionHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<UserManagementProvider, int>(
      /// Rebuild on transaction list length change
      selector: (context, userProvider) =>
          userProvider.user.transactions.length,
      builder: (context, value, child) {
        final List<Transaction> transactions =
            context.read<UserManagementProvider>().user.transactions;

        if (transactions.isEmpty) {
          return const EmptyTransactionHistory();
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.history,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final Transaction transaction =
                      transactions[transactions.length - 1 - index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TransactionHistoryItem(transaction: transaction),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
