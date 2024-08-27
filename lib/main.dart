import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uae_top_up/src/core/constants/const_assets.dart';
import 'package:uae_top_up/src/feature/localization/domain/constants/const_locales.dart';

import 'src/core/util/dependency_injection_manager.dart';
import 'top_up_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await DIManager.initAppInjections();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        ConstLocales.english,
        ConstLocales.arabic,
      ],
      path: ConstAssets.locales,
      fallbackLocale: ConstLocales.english,
      child: const TopUpApp(),
    ),
  );
}
