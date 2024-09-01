import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uae_top_up/src/core/extension/size_extensions.dart';
import 'package:uae_top_up/src/feature/user_management/domain/entity/beneficiary.dart';
import 'package:uae_top_up/src/feature/user_management/presentation/provider/user_management_provider.dart';

import 'beneficiary_item.dart';

/// Current user's beneficiaries list widget
/// list widget is not shown in case the list is empty
class BeneficiariesListView extends StatefulWidget {
  const BeneficiariesListView({super.key});

  @override
  State<BeneficiariesListView> createState() => _BeneficiariesListViewState();
}

class _BeneficiariesListViewState extends State<BeneficiariesListView> {
  final ScrollController scrollController = ScrollController();

  void showTransactionSheet(Beneficiary beneficiary) {
    context.read<UserManagementProvider>().showTransactionSheet(
          context,
          beneficiary,
        );
  }

  Future<void> removeBeneficiary(Beneficiary beneficiary) async {
    await context.read<UserManagementProvider>().removeBeneficiary(beneficiary);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<UserManagementProvider, List<Beneficiary>>(
      selector: (context, provider) => provider.user.beneficiaries,
      builder: (context, savedBeneficiaries, child) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.bounceIn,
          );
        }
        if (savedBeneficiaries.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 200,
          child: OverflowBox(
            maxWidth: 1.width(context),
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: savedBeneficiaries.length,
              itemBuilder: (context, index) {
                final Beneficiary beneficiary =
                    savedBeneficiaries[savedBeneficiaries.length - 1 - index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 6,
                  ),
                  child: BeneficiaryItem(
                    beneficiary: beneficiary,
                    onButtonTap: () => showTransactionSheet(beneficiary),
                    onDeleteTap: (beneficiary) async =>
                        await removeBeneficiary(beneficiary),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
