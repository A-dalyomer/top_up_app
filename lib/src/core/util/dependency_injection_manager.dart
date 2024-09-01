import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:uae_top_up/src/core/util/dialogs.dart';
import 'package:uae_top_up/src/feature/auth/presentation/provider/login_provider.dart';
import 'package:uae_top_up/src/feature/local_storage/data/repository/local_storage_repository_impl.dart';
import 'package:uae_top_up/src/feature/local_storage/domain/repository/local_storage_repository.dart';
import 'package:uae_top_up/src/feature/network/data/repository/api_request_repository_impl.dart';
import 'package:uae_top_up/src/feature/network/domain/repository/api_request_repository.dart';
import 'package:uae_top_up/src/feature/network/domain/util/api_general_handler.dart';
import 'package:uae_top_up/src/feature/server_mocks/domain/util/server_client.dart';
import 'package:uae_top_up/src/feature/transaction/data/repository/transaction_repository_impl.dart';
import 'package:uae_top_up/src/feature/transaction/domain/repository/transaction_repository.dart';
import 'package:uae_top_up/src/feature/user_management/data/repository/user_management_repository_impl.dart';
import 'package:uae_top_up/src/feature/user_management/domain/util/transaction_checks.dart';
import 'package:uae_top_up/src/feature/user_management/domain/util/user_actions.dart';

import '../../feature/user_management/domain/repository/user_management_repository.dart';

/// App Dependency injections handler
/// Used to provide a static dependency instance of [GetIt] currently
/// Allows calling all injections
class DIManager {
  /// The dependency injection singleton instance
  static final getIt = GetIt.instance;

  /// Initializes all needed app injections
  static Future<void> initAppInjections() async {
    /// Local storage repository singleton
    GetIt.instance
        .registerSingleton<LocalStorageRepository>(LocalStorageRepositoryImpl(
      storageClient: const FlutterSecureStorage(),
    ));

    /// Http Client singleton
    GetIt.instance.registerSingleton<http.Client>(
      ServerClient(localStorage: getIt<LocalStorageRepository>()).mockClient(),
    );

    /// Dialogs singleton
    GetIt.instance.registerSingleton<Dialogs>(Dialogs());

    /// API Request error handlers singleton
    GetIt.instance.registerSingleton<APIRequestHandlers>(
      APIRequestHandlers(dialogs: getIt<Dialogs>()),
    );

    /// API request repository singleton
    GetIt.instance.registerSingleton<ApiRequestRepository>(
      ApiRequestRepositoryImpl(
        apiClient: getIt<http.Client>(),
        apiRequestHandlers: getIt<APIRequestHandlers>(),
      ),
    );

    /// User actions singleton
    GetIt.instance.registerSingleton<UserActions>(UserActions());

    /// Transaction checks singleton
    GetIt.instance.registerSingleton<TransactionChecks>(
      TransactionChecks(dialogs: getIt<Dialogs>()),
    );

    /// Transactions repository singleton
    GetIt.instance.registerSingleton<TransactionRepository>(
      TransactionRepositoryImpl(
        apiRequestRepository: getIt<ApiRequestRepository>(),
      ),
    );

    /// User management repository singleton
    GetIt.instance.registerSingleton<UserManagementRepository>(
      UserManagementRepositoryImpl(
        getIt<LocalStorageRepository>(),
        apiRequestRepository: getIt<ApiRequestRepository>(),
        transactionRepository: getIt<TransactionRepository>(),
      ),
    );

    /// Login provider factory "To provide the login function for provider"
    /// Instead of passing the whole user management provider for it
    /// only the [login] is passed
    GetIt.instance.registerFactoryParam<LoginProvider,
        Future Function(String, String), Null>(
      (loginUser, _) => LoginProvider(loginUser: loginUser),
    );
  }
}
