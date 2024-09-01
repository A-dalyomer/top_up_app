import 'package:flutter/material.dart';

import '../widget/message_dialog_content.dart';

/// All app dialogs
class Dialogs {
  /// Shows a simple [message] dialog with an accept button
  showMessageDialog(BuildContext context, String message) {
    showAdaptiveDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return MessageDialogContent(message: message);
      },
    );
  }

  /// Shows a custom widget dialog that only contains the provided [widget]
  showWidgetDialog(BuildContext context, Widget Function(BuildContext) widget) {
    showAdaptiveDialog(
      barrierDismissible: true,
      context: context,
      builder: widget,
    );
  }
}
