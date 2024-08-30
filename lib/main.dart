import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uae_top_up/src/core/constants/const_assets.dart';
import 'package:uae_top_up/src/feature/localization/domain/constants/const_locales.dart';
import 'package:uae_top_up/src/feature/user_management/domain/util/transaction_checks.dart';
import 'package:uae_top_up/src/feature/user_management/domain/util/user_actions.dart';

import 'src/core/util/dependency_injection_manager.dart';
import 'src/feature/configuration/domain/util/core_config_manager.dart';
import 'src/feature/configuration/presentation/provider/settings_provider.dart';
import 'src/feature/network/domain/repository/api_request_repository.dart';
import 'src/feature/user_management/domain/repository/user_management_repository.dart';
import 'src/feature/user_management/presentation/provider/user_management_provider.dart';
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
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => CoreConfigManager(
              DIManager.getIt<ApiRequestRepository>(),
            ),
            lazy: false,
          ),
          ChangeNotifierProvider(
            create: (context) => SettingsProvider(context),
            lazy: false,
          ),
          ChangeNotifierProvider(
            create: (context) => UserManagementProvider(
              DIManager.getIt<UserManagementRepository>(),
              DIManager.getIt<TransactionChecks>(),
              DIManager.getIt<UserActions>(),
            ),
            lazy: false,
          ),
        ],
        child: const TopUpApp(),
      ),
    ),
  );
}
