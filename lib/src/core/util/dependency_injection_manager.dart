import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:uae_top_up/src/core/util/dialogs.dart';
import 'package:uae_top_up/src/feature/auth/presentation/provider/login_provider.dart';
import 'package:uae_top_up/src/feature/local_storage/data/repository/local_storage_repository_impl.dart';
import 'package:uae_top_up/src/feature/local_storage/domain/repository/local_storage_repository.dart';
import 'package:uae_top_up/src/feature/network/data/repository/api_request_repository_impl.dart';
import 'package:uae_top_up/src/feature/network/domain/repository/api_request_repository.dart';
import 'package:uae_top_up/src/feature/server_mocks/domain/util/server_client.dart';
import 'package:uae_top_up/src/feature/transaction/data/repository/transaction_repository_impl.dart';
import 'package:uae_top_up/src/feature/transaction/domain/repository/transaction_repository.dart';
import 'package:uae_top_up/src/feature/user_management/data/repository/user_management_repository_impl.dart';
import 'package:uae_top_up/src/feature/user_management/domain/util/transaction_checks.dart';

import '../../feature/user_management/domain/repository/user_management_repository.dart';

class DIManager {
  static final getIt = GetIt.instance;

  static Future<void> initAppInjections() async {
    GetIt.instance
        .registerSingleton<LocalStorageRepository>(LocalStorageRepositoryImpl(
      storageClient: const FlutterSecureStorage(),
    ));
    GetIt.instance.registerSingleton<http.Client>(
      ServerClient(localStorage: getIt<LocalStorageRepository>()).mockClient(),
    );
    GetIt.instance.registerSingleton<ApiRequestRepository>(
      ApiRequestRepositoryImpl(
        apiClient: getIt<http.Client>(),
      ),
    );
    GetIt.instance.registerSingleton<Dialogs>(Dialogs());
    GetIt.instance.registerSingleton<TransactionChecks>(
      TransactionChecks(dialogs: getIt<Dialogs>()),
    );
    GetIt.instance.registerSingleton<TransactionRepository>(
      TransactionRepositoryImpl(
        apiRequestRepository: getIt<ApiRequestRepository>(),
      ),
    );
    GetIt.instance.registerSingleton<UserManagementRepository>(
      UserManagementRepositoryImpl(
        getIt<LocalStorageRepository>(),
        apiRequestRepository: getIt<ApiRequestRepository>(),
        transactionRepository: getIt<TransactionRepository>(),
      ),
    );
    GetIt.instance.registerFactoryParam<LoginProvider,
        Future Function(String, String), Null>(
      (loginUser, _) => LoginProvider(loginUser: loginUser),
    );
  }
}
