import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uae_top_up/src/core/widget/action_button.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';
import 'package:uae_top_up/src/feature/user_management/domain/util/user_actions.dart';
import 'package:uae_top_up/src/feature/user_management/presentation/provider/user_management_provider.dart';
import 'package:uae_top_up/src/feature/user_top_up/presentation/widget/beneficiaries_list_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void showAddBeneficiarySheet(BuildContext context) {
    UserActions().showAddBeneficiarySheet(context);
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
            onPressed: () =>
                context.read<UserManagementProvider>().signOutUser(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Consumer<UserManagementProvider>(
          builder: (context, userProvider, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Selector<UserManagementProvider, double>(
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
                    ),
                    const BeneficiariesListView(),
                    ActionButton(
                      title: AppLocalizations.add.tr(),
                      onPressed: () => showAddBeneficiarySheet(context),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
