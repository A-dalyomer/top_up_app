import 'package:flutter/material.dart';
import 'package:uae_top_up/src/feature/configuration/data/app_config_model.dart';
import 'package:uae_top_up/src/feature/network/data/constants/const_api_paths.dart';
import 'package:uae_top_up/src/feature/network/domain/repository/api_request_repository.dart';

import '../entity/app_config.dart';

class CoreConfigManager extends ChangeNotifier {
  CoreConfigManager(this.apiRequestRepository) {
    initializeConfig();
  }
  final ApiRequestRepository apiRequestRepository;

  AppConfig? appConfig;

  void initializeConfig() async {
    final Map<String, dynamic>? response =
        await apiRequestRepository.getRequest(
      ConstApiPaths.getAppConfig,
    );
    appConfig = AppConfigModel.fromJson(response);
  }
}
