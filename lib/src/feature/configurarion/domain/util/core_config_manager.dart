import 'package:uae_top_up/src/feature/configurarion/data/app_config_model.dart';
import 'package:uae_top_up/src/feature/network/data/constants/const_api_paths.dart';
import 'package:uae_top_up/src/feature/network/domain/repository/api_request_repository.dart';

import '../entity/app_config.dart';

class CoreConfigManager {
  CoreConfigManager(this.apiRequestRepository) {
    initConfig();
  }
  final ApiRequestRepository apiRequestRepository;

  AppConfig? appConfig;

  void initConfig() async {
    final Map<String, dynamic>? response =
        await apiRequestRepository.getRequest(ConstApiPaths.getAppConfig);
    appConfig = AppConfigModel.fromJson(response);
  }
}
