import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uae_top_up/src/core/extension/size_extensions.dart';
import 'package:uae_top_up/src/core/widget/action_button.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';
import 'package:uae_top_up/src/feature/user_management/domain/entity/beneficiary.dart';

class RechargeBalanceSheet extends StatefulWidget {
  const RechargeBalanceSheet({super.key, required this.beneficiary});
  final Beneficiary beneficiary;

  @override
  State<RechargeBalanceSheet> createState() => _RechargeBalanceSheetState();
}

class _RechargeBalanceSheetState extends State<RechargeBalanceSheet> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 26,
            bottom: 6,
          ),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "${AppLocalizations.mobileRecharge.tr()}:",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextSpan(
                  text: " ${widget.beneficiary.name}",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            textAlign: TextAlign.start,
          ),
        ),
        Expanded(
          child: Material(
            child: Stack(
              children: [
                ListView.builder(
                  itemCount: 10,
                  cacheExtent: 0,
                  addRepaintBoundaries: false,
                  padding: EdgeInsets.only(bottom: 0.07.height(context)),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4,
                      ),
                      child: RadioListTile(
                        value: index,
                        groupValue: selectedIndex,
                        title: Text('$index AED'),
                        onChanged: (value) {
                          setState(() => selectedIndex = index);
                        },
                      ),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 6,
                    ),
                    child: ActionButton(
                      title: AppLocalizations.recharge.tr(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
