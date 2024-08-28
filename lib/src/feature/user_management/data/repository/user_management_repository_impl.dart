import 'dart:convert';

import 'package:uae_top_up/src/feature/local_storage/data/constants/const_storage_keys.dart';
import 'package:uae_top_up/src/feature/local_storage/domain/repository/local_storage_repository.dart';
import 'package:uae_top_up/src/feature/network/data/constants/const_api_paths.dart';
import 'package:uae_top_up/src/feature/network/domain/repository/api_request_repository.dart';
import 'package:uae_top_up/src/feature/network/domain/util/api_parse_handler.dart';
import 'package:uae_top_up/src/feature/transaction/domain/repository/transaction_repository.dart';
import 'package:uae_top_up/src/feature/user_management/data/model/user_model.dart';

import 'package:uae_top_up/src/feature/user_management/domain/entity/user.dart';

import '../../domain/repository/user_management_repository.dart';

class UserManagementRepositoryImpl implements UserManagementRepository {
  UserManagementRepositoryImpl(
    this.localStorage, {
    required this.apiRequestRepository,
    required this.transactionRepository,
  });
  final ApiRequestRepository apiRequestRepository;
  final TransactionRepository transactionRepository;
  final LocalStorageRepository localStorage;

  @override
  Future<bool> changeBalance(
    double amount, {
    required User currentUser,
    required UserBalanceChangeTypes changeType,
  }) async {
    late final String apiPath;
    switch (changeType) {
      case UserBalanceChangeTypes.add:
        apiPath = ConstApiPaths.addBalance;
      case UserBalanceChangeTypes.debit:
        apiPath = ConstApiPaths.debitBalance;
    }
    final Map<String, dynamic>? response = await apiRequestRepository
        .postRequest(apiPath, body: {"amount": amount});
    if (response == null || !response['success']) return false;
    return true;
  }

  @override
  Future<bool> addBeneficiary({
    required String name,
    required String phoneNumber,
    required User currentUser,
  }) async {
    final Map<String, dynamic>? response =
        await apiRequestRepository.postRequest(
      ConstApiPaths.addBeneficiary,
      body: {
        "name": name,
        "phone_number": phoneNumber,
      },
    );
    return (response?['success'] ?? false) == true;
  }

  @override
  Future<bool> makeTransaction({
    required double amount,
    required int targetUserId,
    required User currentUser,
  }) async {
    return await transactionRepository.makeTransaction(
      amount: amount,
      targetUserId: targetUserId,
    );
  }

  @override
  Future<User?> getCurrentUser() async {
    final String? rawUserData = await localStorage.readValue(
      ConstStorageKeys.userData,
    );
    if (rawUserData == null) return null;
    final Map<String, dynamic> json = jsonDecode(rawUserData);
    return UserModel.fromJson(json);
  }

  @override
  Future<void> saveUser({required User newUser}) async {
    final UserModel model = UserModel.fromEntity(newUser);
    await localStorage.writeValue(
      ConstStorageKeys.userData,
      jsonEncode(model.toJson()),
    );
  }

  @override
  Future<User?> signInUser(String phoneNumber) async {
    final Map<String, dynamic>? response =
        await apiRequestRepository.postRequest(
      ConstApiPaths.login,
      body: {"phone_number": phoneNumber},
    );

    if (response == null) return null;
    try {
      return UserModel.fromJson(response);
    } catch (exception) {
      APIParseHandlers.handleModelParseException(exception);
      return null;
    }
  }

  @override
  Future<void> removeUser() async {
    await localStorage.removeValue(ConstStorageKeys.userData);
  }
}
