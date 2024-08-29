import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';
import 'package:uae_top_up/src/feature/user_management/presentation/provider/user_management_provider.dart';

class BalanceView extends StatelessWidget {
  const BalanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<UserManagementProvider, double>(
      selector: (context, provider) => provider.user.balance,
      builder: (context, userBalance, child) => Text.rich(
        TextSpan(children: [
          TextSpan(
            text: '${AppLocalizations.userBalance.tr()}: ',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          TextSpan(
            text: userBalance.toStringAsFixed(0),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ]),
        textAlign: TextAlign.center,
      ),
    );
  }
}
