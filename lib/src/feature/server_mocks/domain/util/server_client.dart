import 'dart:convert';

import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:uae_top_up/src/feature/configurarion/data/app_config_model.dart';
import 'package:uae_top_up/src/feature/configurarion/domain/entity/app_config.dart';

import '../../../network/data/constants/const_api_paths.dart';

class ServerClient {
  static final mockClient = MockClient(
    (request) async {
      switch (request.url.path) {
        case ConstApiPaths.getAppConfig:
          final AppConfig config = AppConfig(
            maxActiveBeneficiaries: 5,
            receiverNonVerifiedMaxAmount: 500,
            receiverVerifiedMaxAmount: 1000,
            senderMaxAmount: 3000,
            transactionFee: 1,
          );
          final configModel = AppConfigModel.fromEntity(config);

          return http.Response(
            jsonEncode(configModel.toJson()),
            200,
          );
        default:
          return http.Response('Not Found', 404);
      }
    },
  );
}
