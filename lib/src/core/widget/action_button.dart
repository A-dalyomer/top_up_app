import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.title, this.onPressed});
  final String title;
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
