import 'package:uae_top_up/src/feature/network/data/constants/const_api_paths.dart';
import 'package:uae_top_up/src/feature/network/domain/repository/api_request_repository.dart';
import 'package:uae_top_up/src/feature/network/domain/util/api_parse_handler.dart';

import '../../domain/entity/transaction.dart';
import '../../domain/repository/transaction_repository.dart';
import '../model/transaction_model.dart';

/// Implementation of `TransactionRepository` using [ApiRequestRepository]
class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl({required this.apiRequestRepository});
  final ApiRequestRepository apiRequestRepository;

  /// Make the passed [transaction] API request using [apiRequestRepository]
  /// Parses the model if not null and returns the result as `TransactionModel`
  /// If any exception happens during data parse, a call to `APIParseHandlers`
  /// is made to log the exception
  @override
  Future<TransactionModel?> makeTransaction({
    required Transaction transaction,
  }) async {
    final Map<String, dynamic>? response =
        await apiRequestRepository.postRequest(
      ConstApiPaths.makeTransaction,
      body: TransactionModel.fromEntity(transaction).toJson(),
    );
    if (response == null) return null;
    try {
      return TransactionModel.fromJson(response);
    } catch (exception) {
      APIParseHandlers.handleModelParseException(exception);
      return null;
    }
  }
}
