import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uae_top_up/src/core/widget/action_button.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';
import 'package:uae_top_up/src/feature/user_management/domain/entity/beneficiary.dart';
import 'package:uae_top_up/src/feature/user_management/presentation/provider/user_management_provider.dart';

class BeneficiariesListView extends StatelessWidget {
  const BeneficiariesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<UserManagementProvider, List<Beneficiary>>(
      selector: (context, provider) => provider.user.beneficiaries,
      builder: (context, savedBeneficiaries, child) {
        if (savedBeneficiaries.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: savedBeneficiaries.length,
            itemBuilder: (context, index) {
              final Beneficiary beneficiary = savedBeneficiaries[index];
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
