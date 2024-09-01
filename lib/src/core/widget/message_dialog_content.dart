import 'package:flutter/material.dart';
import 'package:uae_top_up/src/core/extension/size_extensions.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';

import 'action_button.dart';

/// The widget that is shown when calling [showMessageDialog] from [Dialogs]
class MessageDialogContent extends StatelessWidget {
  const MessageDialogContent({super.key, required this.message});
  final String message;

  /// Closes the [MessageDialogContent] on accept button presses
  void _closeDialog(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(maxWidth: 0.75.width(context)),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 30,
              bottom: 16,
              left: 12.0,
              right: 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ActionButton(
                      title: AppLocalizations.accept,
                      onPressed: () => _closeDialog(context),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
