import 'package:flutter/material.dart';
import 'package:uae_top_up/src/core/util/core_enums.dart';

import 'action_button.dart';
import 'loading_indicator.dart';

/// Button that changes shown widget depending on the passed [screenStates]
/// and its states
class ApiActionButton extends StatelessWidget {
  const ApiActionButton({
    super.key,
    required this.title,
    required this.screenStates,
    required this.onPressed,
  });

  /// Button title
  final String title;

  /// Current API state
  final ApiScreenStates screenStates;

  /// On pressed button handler
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return switch (screenStates) {
      ApiScreenStates.loading => const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [LoadingIndicator()],
        ),
      ApiScreenStates.done || _ => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (screenStates == ApiScreenStates.error)
              Icon(
                Icons.error,
                size: 30,
                color: Theme.of(context).colorScheme.error,
              ),
            ActionButton(
              title: title,
              onPressed: onPressed,
            ),
          ],
        ),
    };
  }
}
