import 'package:uae_top_up/src/feature/network/data/constants/const_api_paths.dart';
import 'package:uae_top_up/src/feature/network/domain/repository/api_request_repository.dart';

import '../../domain/repository/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl({required this.apiRequestRepository});
  final ApiRequestRepository apiRequestRepository;

  @override
  Future<bool> makeTransaction({
    required double amount,
    required int targetUserId,
  }) async {
    final Map<String, dynamic>? response =
        await apiRequestRepository.postRequest(
      ConstApiPaths.addBeneficiary,
      body: {"amount": amount, "user_id": targetUserId},
    );
    return (response?['success'] ?? false) == true;
  }
}
