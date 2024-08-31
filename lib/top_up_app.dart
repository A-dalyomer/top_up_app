import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uae_top_up/src/core/util/dependency_injection_manager.dart';
import 'package:uae_top_up/src/core/util/dialogs.dart';
import 'package:uae_top_up/src/core/widget/initialization_screen.dart';
import 'package:uae_top_up/src/feature/auth/presentation/provider/login_provider.dart';
import 'package:uae_top_up/src/feature/auth/presentation/screen/login_screen.dart';
import 'package:uae_top_up/src/feature/configuration/domain/util/app_themes.dart';
import 'package:uae_top_up/src/feature/configuration/presentation/provider/settings_provider.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';
import 'package:uae_top_up/src/feature/user_top_up/presentation/screen/home_screen.dart';

import 'src/feature/configuration/domain/entity/app_config.dart';
import 'src/feature/configuration/domain/util/core_config_manager.dart';
import 'src/feature/user_management/presentation/provider/user_management_provider.dart';

class TopUpApp extends StatefulWidget {
  const TopUpApp({super.key});

  @override
  State<TopUpApp> createState() => _TopUpAppState();
}

class _TopUpAppState extends State<TopUpApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppLocalizations.appName.tr(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      themeMode: context.select<SettingsProvider, ThemeMode>(
        (settingsProvider) => settingsProvider.appThemeMode,
      ),
      theme: AppThemes().light(),
      darkTheme: AppThemes().dark(),
      home: Builder(
        builder: (context) {
          final AppConfig? appConfig = context.select(
            (CoreConfigManager value) => value.appConfig,
          );
          final userReady = context.select(
            (UserManagementProvider value) => value.finishedInitialization,
          );
          final userExists = context.select(
            (UserManagementProvider value) => value.userExists,
          );
          if (!userReady || appConfig == null) {
            return const InitializationScreen();
          }
          if (!userExists) {
            return LoginScreen(
              loginProvider: DIManager.getIt<LoginProvider>(
                param1: context.read<UserManagementProvider>().loginUser,
              ),
            );
          }
          return HomeScreen(
            dialogs: DIManager.getIt<Dialogs>(),
          );
        },
      ),
    );
  }
}
