import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uae_top_up/src/core/constants/const_configs.dart';
import 'package:uae_top_up/src/core/extension/size_extensions.dart';
import 'package:uae_top_up/src/core/util/core_enums.dart';
import 'package:uae_top_up/src/core/widget/api_action_button.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';
import 'package:uae_top_up/src/feature/user_management/domain/entity/beneficiary.dart';

class TransactionSheet extends StatefulWidget {
  const TransactionSheet({
    super.key,
    required this.beneficiary,
    required this.onRechargePress,
  });
  final Beneficiary beneficiary;
  final Function(double) onRechargePress;

  @override
  State<TransactionSheet> createState() => _TransactionSheetState();
}

class _TransactionSheetState extends State<TransactionSheet> {
  int selectedIndex = 0;
  ApiScreenStates screenStates = ApiScreenStates.done;

  void recharge(int amount) async {
    setState(() => screenStates = ApiScreenStates.loading);
    bool transactionMade = await widget.onRechargePress(amount.toDouble());
    if (transactionMade) {
      setState(() => screenStates = ApiScreenStates.done);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } else {
      setState(() => screenStates = ApiScreenStates.error);
    }
  }

  void changeSelection(int? newValue) {
    setState(() {
      selectedIndex = newValue!;
      if (screenStates == ApiScreenStates.error) {
        screenStates = ApiScreenStates.done;
      }
    });
  }

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
                  itemCount: ConstConfigs.transactionOptions.length,
                  cacheExtent: 0,
                  addRepaintBoundaries: false,
                  padding: EdgeInsets.only(bottom: 0.07.height(context)),
                  itemBuilder: (context, index) {
                    final int transactionOptionAmount =
                        ConstConfigs.transactionOptions[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4,
                      ),
                      child: RadioListTile(
                        value: index,
                        groupValue: selectedIndex,
                        title: Text('$transactionOptionAmount AED'),
                        onChanged: changeSelection,
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
                    child: ApiActionButton(
                      title: AppLocalizations.recharge.tr(),
                      screenStates: screenStates,
                      onPressed: () => recharge(
                        ConstConfigs.transactionOptions[selectedIndex],
                      ),
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
