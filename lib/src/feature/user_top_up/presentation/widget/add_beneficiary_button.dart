import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uae_top_up/src/core/widget/action_button.dart';
import 'package:uae_top_up/src/feature/configuration/domain/entity/app_config.dart';
import 'package:uae_top_up/src/feature/configuration/domain/util/core_config_manager.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';
import 'package:uae_top_up/src/feature/user_management/presentation/provider/user_management_provider.dart';

class AddBeneficiaryButton extends StatelessWidget {
  const AddBeneficiaryButton({super.key});
  void showAddBeneficiarySheet(BuildContext context) {
    final AppConfig appConfig = context.read<CoreConfigManager>().appConfig!;
    context.read<UserManagementProvider>().showAddBeneficiarySheet(
          context,
          appConfig,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Selector<UserManagementProvider, int>(
      selector: (_, provider) => provider.user.beneficiaries.length,
      builder: (context, beneficiariesCount, child) {
        final AppConfig appConfig =
            context.read<CoreConfigManager>().appConfig!;
        if (beneficiariesCount > appConfig.maxActiveBeneficiaries) {
          return const SizedBox.shrink();
        }
        return ActionButton(
          title: AppLocalizations.addBeneficiary.tr(),
          onPressed: () => showAddBeneficiarySheet(context),
        );
      },
    );
  }
}
