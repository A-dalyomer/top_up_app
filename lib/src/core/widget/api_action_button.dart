import 'package:flutter/material.dart';
import 'package:uae_top_up/src/core/util/core_enums.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';

import 'action_button.dart';
import 'loading_indicator.dart';

class ApiActionButton extends StatelessWidget {
  const ApiActionButton({
    super.key,
    required this.screenStates,
    required this.onTap,
  });
  final ApiScreenStates screenStates;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return switch (screenStates) {
      ApiScreenStates.loading => const LoadingIndicator(),
      ApiScreenStates.done || _ => Column(
          children: [
            if (screenStates == ApiScreenStates.error)
              Icon(
                Icons.error,
                size: 30,
                color: Theme.of(context).colorScheme.error,
              ),
            ActionButton(
              title: AppLocalizations.save,
              onPressed: onTap,
            ),
          ],
        ),
    };
  }
}
