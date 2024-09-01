import 'package:flutter/material.dart';

/// General app actions button for CTA calls
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.title,
    this.onPressed,
    this.color,
  });

  /// Button title text
  final String title;

  /// On pressed button handler
  final VoidCallback? onPressed;

  /// Custom background color
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                  backgroundColor: WidgetStatePropertyAll(color),
                ),
            child: FittedBox(
              child: Text(title),
            ),
          ),
        ),
      ],
    );
  }
}
