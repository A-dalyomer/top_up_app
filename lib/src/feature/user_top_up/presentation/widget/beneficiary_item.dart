import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uae_top_up/src/core/widget/action_button.dart';
import 'package:uae_top_up/src/core/widget/loading_indicator.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';
import 'package:uae_top_up/src/feature/user_management/domain/entity/beneficiary.dart';

/// The item shown in `BeneficiariesListView` to show the beneficiary details
class BeneficiaryItem extends StatefulWidget {
  const BeneficiaryItem({
    super.key,
    required this.beneficiary,
    required this.onButtonTap,
    required this.onDeleteTap,
  });

  /// Beneficiary info
  final Beneficiary beneficiary;

  /// On recharge button press
  final VoidCallback onButtonTap;

  /// On delete button tap
  final Function(Beneficiary) onDeleteTap;

  @override
  State<BeneficiaryItem> createState() => _BeneficiaryItemState();
}

class _BeneficiaryItemState extends State<BeneficiaryItem> {
  /// Loading state
  bool loading = false;

  /// on Delete button press
  void deleteBeneficiary() async {
    setState(() => loading = true);
    await widget.onDeleteTap(widget.beneficiary);
    setState(() => loading = true);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AbsorbPointer(
          absorbing: loading,
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    color: Theme.of(context).colorScheme.error,
                    onPressed: deleteBeneficiary,
                    icon: const Icon(Icons.close),
                  ),
                  Text(
                    widget.beneficiary.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  FittedBox(
                    child: Text(
                      widget.beneficiary.phoneNumber,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  ActionButton(
                    title: AppLocalizations.rechargeNow.tr(),
                    onPressed: widget.onButtonTap,
                  )
                ],
              ),
            ),
          ),
        ),
        if (loading) const LoadingIndicator(),
      ],
    );
  }
}
