import 'package:flutter/material.dart';

import 'src/core/util/dependency_injection_manager.dart';
import 'top_up_app.dart';

void main() async {
  await DIManager.initAppInjections();
  runApp(const TopUpApp());
}
