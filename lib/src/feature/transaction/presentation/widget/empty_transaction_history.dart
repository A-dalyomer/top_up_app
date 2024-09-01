import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uae_top_up/src/core/extension/size_extensions.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';

/// Empty transactions list widget
/// Contains an icon and text of empty transactions list
class EmptyTransactionHistory extends StatelessWidget {
  const EmptyTransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.history, size: 60),
        16.vS,
        Text(
          AppLocalizations.transactionHistoryEmpty.tr(),
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
