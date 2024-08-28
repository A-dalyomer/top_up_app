import 'package:uae_top_up/src/feature/network/data/constants/const_api_paths.dart';
import 'package:uae_top_up/src/feature/network/domain/repository/api_request_repository.dart';
import 'package:uae_top_up/src/feature/network/domain/util/api_parse_handler.dart';

import '../../domain/entity/transaction.dart';
import '../../domain/repository/transaction_repository.dart';
import '../model/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl({required this.apiRequestRepository});
  final ApiRequestRepository apiRequestRepository;

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
