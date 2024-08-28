import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uae_top_up/src/core/widget/action_button.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';
import 'package:uae_top_up/src/feature/user_management/domain/entity/beneficiary.dart';
import 'package:uae_top_up/src/feature/user_management/presentation/provider/user_management_provider.dart';

class BeneficiariesListView extends StatefulWidget {
  const BeneficiariesListView({super.key});

  @override
  State<BeneficiariesListView> createState() => _BeneficiariesListViewState();
}

class _BeneficiariesListViewState extends State<BeneficiariesListView> {
  final ScrollController scrollController = ScrollController();

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
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Theme.of(context).colorScheme.shadow,
                      )
                    ],
                  ),
                  width: MediaQuery.of(context).size.width * 0.36,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            beneficiary.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                          FittedBox(
                            child: Text(
                              beneficiary.phoneNumber,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          ActionButton(
                            title: AppLocalizations.rechargeNow.tr(),
                            onPressed: () {},
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
