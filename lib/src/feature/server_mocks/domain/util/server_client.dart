import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:uae_top_up/src/core/util/dependency_injection_manager.dart';
import 'package:uae_top_up/src/feature/configurarion/data/app_config_model.dart';
import 'package:uae_top_up/src/feature/configurarion/domain/entity/app_config.dart';
import 'package:uae_top_up/src/feature/local_storage/data/constants/const_storage_keys.dart';
import 'package:uae_top_up/src/feature/local_storage/domain/repository/local_storage_repository.dart';
import 'package:uae_top_up/src/feature/user_management/data/model/beneficiary_model.dart';
import 'package:uae_top_up/src/feature/user_management/data/model/user_model.dart';

import '../../../network/data/constants/const_api_paths.dart';

class ServerClient {
  MockClient mockClient() {
    return MockClient(handler);
  }

  Future<http.Response> handler(request) async {
    if (kDebugMode) {
      print(request.url.path);
      print(request.headers);
      print(request.body);
    }
    switch (request.url.path) {
      case ConstApiPaths.getAppConfig:
        return appConfigResponse();
      case ConstApiPaths.login:
        final String? phoneNumber = jsonDecode(request.body)['phone_number'];
        if (phoneNumber == null || phoneNumber.length < 8) {
          return http.Response(
            jsonEncode({"message": 'Missing phone number'}),
            404,
          );
        }
        final savedUsers = await getSavedUsersList();
        final List<UserModel> matchingUsers = savedUsers
            .where((element) => element.phoneNumber == phoneNumber)
            .toList();
        late final UserModel resultUser;
        if (matchingUsers.isEmpty) {
          resultUser = await createUser(phoneNumber, savedUsers);
        } else {
          resultUser = matchingUsers[0];
        }
        return http.Response(
          jsonEncode(resultUser.toJson()),
          200,
        );
      case ConstApiPaths.addBeneficiary:
        final String? senderPhoneNumber =
            jsonDecode(request.body)['sender_phone_number'];
        final String? phoneNumber = jsonDecode(request.body)['phone_number'];
        final String? beneficiaryName = jsonDecode(request.body)['name'];
        return await addBeneficiaryResponse(
          senderPhoneNumber: senderPhoneNumber!,
          phoneNumber: phoneNumber!,
          beneficiaryName: beneficiaryName!,
        );
      default:
        return http.Response(jsonEncode({"message": 'Not Found'}), 404);
    }
  }

  http.Response appConfigResponse() {
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
  }

  Future<http.Response> addBeneficiaryResponse({
    required String senderPhoneNumber,
    required String phoneNumber,
    required String beneficiaryName,
  }) async {
    final savedUsers = await getSavedUsersList();
    final senderUser = savedUsers.singleWhere(
      (element) => element.phoneNumber == senderPhoneNumber,
    );
    BeneficiaryModel newBeneficiary = BeneficiaryModel(
      name: beneficiaryName,
      phoneNumber: phoneNumber,
      transactions: const [],
      id: senderUser.beneficiaries.length,
    );
    if (senderUser.beneficiaries.contains(newBeneficiary)) {
      return http.Response(
        jsonEncode({"message": "Already exists"}),
        409,
      );
    }
    senderUser.beneficiaries.add(newBeneficiary);
    await saveUsers(savedUsers);
    return http.Response(
      jsonEncode(newBeneficiary.toJson()),
      200,
    );
  }

  Future<List<UserModel>> getSavedUsersList() async {
    String? savedUsersRaw = (await DIManager.getIt<LocalStorageRepository>()
            .readValue(ConstStorageKeys.serverUsers)) ??
        "{}";
    final List usersJson = jsonDecode(savedUsersRaw)['users'] ?? [];
    final savedUsers =
        usersJson.map((userData) => UserModel.fromJson(userData)).toList();
    return savedUsers;
  }

  Future<UserModel> createUser(
      String phoneNumber, List<UserModel> savedUsers) async {
    UserModel resultUser = UserModel(
      id: savedUsers.length,
      name: phoneNumber.toString(),
      phoneNumber: phoneNumber,
      isVerified: true,
      balance: 2000,
      monthlyTopUps: 0,
      beneficiaries: [],
      transactions: [],
    );
    savedUsers.add(resultUser);
    await saveUsers(savedUsers);
    return resultUser;
  }

  Future<void> saveUsers(List<UserModel> savedUsers) async {
    await DIManager.getIt<LocalStorageRepository>().writeValue(
      ConstStorageKeys.serverUsers,
      jsonEncode(
        {"users": savedUsers.map((e) => e.toJson()).toList()},
      ),
    );
  }
}
