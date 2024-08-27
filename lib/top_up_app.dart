import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uae_top_up/src/core/widget/initialization_screen.dart';
import 'package:uae_top_up/src/feature/auth/presentation/screen/login_screen.dart';

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
        title: 'UAE Top-Up',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Builder(
          builder: (context) {
            final AppConfig? appConfig =
                context.watch<CoreConfigManager>().appConfig;
            final userReady =
                context.watch<UserManagementProvider>().finishedInitialization;
            if (!userReady || appConfig == null) {
              return const InitializationScreen();
            }
            if (!context.read<UserManagementProvider>().userExists) {
              return const LoginScreen();
            }
            return Scaffold(
              appBar: AppBar(
                title: const Text("home screen"),
              ),
            );
          },
        ),
      ),
    );
  }
}
