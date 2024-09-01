import 'package:flutter/material.dart';

/// General app actions button for CTA calls
class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.title, this.onPressed});

  /// Button title text
  final String title;

  /// On pressed button handler
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            child: FittedBox(child: Text(title)),
          ),
        ),
      ],
    );
  }
}
