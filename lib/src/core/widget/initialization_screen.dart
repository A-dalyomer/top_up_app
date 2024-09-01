import 'package:flutter/material.dart';

import 'loading_indicator.dart';

/// A screen that is shown while the app initializes core config and user data
class InitializationScreen extends StatelessWidget {
  const InitializationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: LoadingIndicator(),
    );
  }
}
