import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uae_top_up/src/core/widget/action_button.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';
import 'package:uae_top_up/src/feature/user_management/domain/entity/beneficiary.dart';

class BeneficiaryItem extends StatelessWidget {
  const BeneficiaryItem({
    super.key,
    required this.beneficiary,
    required this.onButtonTap,
  });
  final Beneficiary beneficiary;
  final VoidCallback onButtonTap;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                onPressed: onButtonTap,
              )
            ],
          ),
        ),
      ),
    );
  }
}
