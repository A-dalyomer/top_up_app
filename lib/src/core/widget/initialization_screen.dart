import 'package:flutter/material.dart';

import 'loading_indicator.dart';

class InitializationScreen extends StatelessWidget {
  const InitializationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: LoadingIndicator(),
    );
  }
}
