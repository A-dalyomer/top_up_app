import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uae_top_up/src/feature/configuration/data/app_config_model.dart';
import 'package:uae_top_up/src/feature/configuration/domain/entity/app_config.dart';
import 'package:uae_top_up/src/feature/network/data/constants/const_api_paths.dart';
import 'package:uae_top_up/src/feature/network/data/repository/api_request_repository_impl.dart';
import 'package:uae_top_up/src/feature/network/domain/repository/api_request_repository.dart';
import 'package:uae_top_up/src/feature/server_mocks/domain/util/server_client.dart';
import 'package:uae_top_up/src/feature/user_management/data/model/user_model.dart';
import 'package:uae_top_up/src/feature/user_management/domain/entity/user.dart';

import '../../../../../test_helpers.dart';
import 'api_request_repository_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ServerClient>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ApiRequestRepository apiRequestRepository;
  late MockServerClient mockServerClient;

  setUp(() {
    mockServerClient = MockServerClient();
    when(mockServerClient.mockClient()).thenReturn(MockClient(
      (request) async {
        if (request.method == "POST") {
          final UserModel userModel = UserModel.fromEntity(createTestUser());
          return Response(jsonEncode(userModel.toJson()), 200);
        } else {
          final AppConfig config = createTestAppConfig();
          final AppConfigModel configModel = AppConfigModel.fromEntity(config);
          return Response(jsonEncode(configModel), 200);
        }
      },
    ));
    apiRequestRepository = ApiRequestRepositoryImpl(
      apiClient: mockServerClient.mockClient(),
    );
  });

  group('Api requests repository tests', () {
    test('Post request', () async {
      final response = await apiRequestRepository.postRequest(
        ConstApiPaths.login,
        body: {"phone_number": "+971 56 555 5555"},
      );

      expect(response, isA<Map<String, dynamic>>());
      expect(UserModel.fromJson(response!), isA<User>());
    });
    test('Get request', () async {
      final response = await apiRequestRepository.getRequest(
        ConstApiPaths.getAppConfig,
      );
      expect(response, isA<Map<String, dynamic>>());
      expect(AppConfigModel.fromJson(response), isA<AppConfig>());
    });
  });
}
