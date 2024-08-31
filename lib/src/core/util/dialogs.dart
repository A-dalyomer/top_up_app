import 'package:flutter/material.dart';

import '../widget/message_dialog_content.dart';

class Dialogs {
  showMessageDialog(BuildContext context, String message) {
    showAdaptiveDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return MessageDialogContent(message: message);
      },
    );
  }

  showWidgetDialog(BuildContext context, Widget Function(BuildContext) widget) {
    showAdaptiveDialog(
      barrierDismissible: true,
      context: context,
      builder: widget,
    );
  }
}
