import 'package:flutter/material.dart';
import 'package:uae_top_up/src/feature/configuration/data/app_config_model.dart';
import 'package:uae_top_up/src/feature/network/data/constants/const_api_paths.dart';
import 'package:uae_top_up/src/feature/network/domain/repository/api_request_repository.dart';

import '../entity/app_config.dart';

/// App configuration state manager
/// Handles initializing the configuration and preserving its state
class CoreConfigManager extends ChangeNotifier {
  CoreConfigManager(this.apiRequestRepository) {
    initializeConfig();
  }

  /// Used to load the config from API client if possible
  final ApiRequestRepository apiRequestRepository;

  /// App configuration state
  AppConfig? appConfig;

  /// Initialize the [appConfig] with data received from [apiRequestRepository]
  void initializeConfig() async {
    final Map<String, dynamic>? response =
        await apiRequestRepository.getRequest(
      ConstApiPaths.getAppConfig,
    );
    appConfig = AppConfigModel.fromJson(response);
    notifyListeners();
  }
}
