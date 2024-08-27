import 'package:flutter/material.dart';

import 'src/core/util/dependency_injection_manager.dart';

void main() async {
  await DIManager.initAppInjections();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Material(color: Colors.white),
    );
  }
}
