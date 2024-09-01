import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uae_top_up/src/core/util/dialogs.dart';
import 'package:uae_top_up/src/feature/configuration/presentation/widget/settings_dialog.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';
import 'package:uae_top_up/src/feature/user_management/presentation/provider/user_management_provider.dart';
import 'package:uae_top_up/src/feature/user_top_up/presentation/widget/balance_view.dart';
import 'package:uae_top_up/src/feature/user_top_up/presentation/widget/beneficiaries_list_view.dart';
import 'package:uae_top_up/src/feature/transaction/presentation/widget/transaction_history_list.dart';

import '../widget/add_beneficiary_button.dart';

/// App home screen for a logged in user
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.dialogs});

  /// Dialogs instance
  /// User to show the settings dialog on settings button press
  final Dialogs dialogs;

  void showSettings(BuildContext context) {
    dialogs.showWidgetDialog(context, (context) => const SettingsDialog());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.homeScreen.tr()),
        actions: [
          Selector<UserManagementProvider, String>(
            selector: (context, provider) => provider.user.name,
            builder: (context, userName, child) => Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .4),
              child: FittedBox(
                child: Text(
                  userName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () => showSettings(context),
            icon: Icon(
              Icons.settings,
              color: Theme.of(context)
                  .elevatedButtonTheme
                  .style!
                  .backgroundColor!
                  .resolve({}),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const BalanceView(),
                  const BeneficiariesListView(),
                  const AddBeneficiaryButton(),
                ],
              ),
            ),
            const SliverFillRemaining(
              child: TransactionHistoryList(),
            ),
          ],
        ),
      ),
    );
  }
}
