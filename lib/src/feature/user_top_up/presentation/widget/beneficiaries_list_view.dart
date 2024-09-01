import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    return Selector<UserManagementProvider, int>(
      selector: (context, provider) => provider.user.beneficiaries.length,
      builder: (context, savedBeneficiariesLength, child) {
        final savedBeneficiaries =
            context.read<UserManagementProvider>().user.beneficiaries;
        if (scrollController.hasClients) {
          scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.bounceIn,
          );
        }
        if (savedBeneficiaries.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 160,
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
                ),
              );
            },
          ),
        );
      },
    );
  }
}
