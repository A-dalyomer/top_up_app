import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uae_top_up/src/core/widget/initialization_screen.dart';
import 'package:uae_top_up/src/feature/auth/presentation/screen/login_screen.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';
import 'package:uae_top_up/src/feature/user_top_up/presentation/screen/home_screen.dart';

import 'src/core/util/dependency_injection_manager.dart';
import 'src/feature/configurarion/domain/entity/app_config.dart';
import 'src/feature/configurarion/domain/util/core_config_manager.dart';
import 'src/feature/network/domain/repository/api_request_repository.dart';
import 'src/feature/user_management/domain/repository/user_management_repository.dart';
import 'src/feature/user_management/presentation/provider/user_management_provider.dart';

class TopUpApp extends StatefulWidget {
  const TopUpApp({super.key});

  @override
  State<TopUpApp> createState() => _TopUpAppState();
}

class _TopUpAppState extends State<TopUpApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CoreConfigManager(
            DIManager.getIt<ApiRequestRepository>(),
          ),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (context) => UserManagementProvider(
            DIManager.getIt<UserManagementRepository>(),
          ),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        title: AppLocalizations.appName.tr(),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            shadow: Colors.redAccent.withOpacity(0.1),
          ),
          useMaterial3: true,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            constraints: const BoxConstraints(minHeight: 64),
            filled: true,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.disabled)) return Colors.grey;
                  return Colors.redAccent;
                },
              ),
              foregroundColor: const WidgetStatePropertyAll(Colors.white),
              shape: WidgetStateProperty.resolveWith((states) {
                return RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: states.contains(WidgetState.disabled)
                        ? Colors.transparent
                        : Colors.red,
                  ),
                );
              }),
            ),
          ),
          listTileTheme: ListTileThemeData(
            dense: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
        home: Builder(
          builder: (context) {
            final AppConfig? appConfig = context.select(
              (CoreConfigManager value) => value.appConfig,
            );
            final userReady = context.select(
              (UserManagementProvider value) => value.finishedInitialization,
            );
            if (!userReady || appConfig == null) {
              return const InitializationScreen();
            }
            if (!context.read<UserManagementProvider>().userExists) {
              return const LoginScreen();
            }
            return const HomeScreen();
          },
        ),
      ),
    );
  }
}
