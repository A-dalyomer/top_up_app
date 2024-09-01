import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:uae_top_up/src/core/util/dialogs.dart';
import 'package:uae_top_up/src/feature/configuration/data/app_config_model.dart';
import 'package:uae_top_up/src/feature/configuration/domain/entity/app_config.dart';
import 'package:uae_top_up/src/feature/local_storage/data/constants/const_storage_keys.dart';
import 'package:uae_top_up/src/feature/local_storage/domain/repository/local_storage_repository.dart';
import 'package:uae_top_up/src/feature/transaction/data/model/transaction_model.dart';
import 'package:uae_top_up/src/feature/transaction/domain/entity/transaction.dart';
import 'package:uae_top_up/src/feature/user_management/data/model/beneficiary_model.dart';
import 'package:uae_top_up/src/feature/user_management/data/model/user_model.dart';
import 'package:uae_top_up/src/feature/user_management/domain/entity/beneficiary.dart';
import 'package:uae_top_up/src/feature/user_management/domain/entity/user.dart';
import 'package:uae_top_up/src/feature/user_management/domain/util/transaction_checks.dart';

import '../../../network/data/constants/const_api_paths.dart';

/// HTTP client Utils
/// Holds the mock instance creation and the mock calls handler
class ServerClient {
  ServerClient({required this.localStorage});

  /// The mock HTTP client
  MockClient mockClient() {
    return MockClient(handler);
  }

  /// Local storage instance
  /// Used for saving and loading client data from local storage
  final LocalStorageRepository localStorage;
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
      case ConstApiPaths.makeTransaction:
        final TransactionModel newTransaction =
            TransactionModel.fromJson(jsonDecode(request.body));
        return await makeTransactionResponse(newTransaction: newTransaction);
      default:
        return http.Response(jsonEncode({"message": 'Not Found'}), 404);
    }
  }

  http.Response appConfigResponse() {
    final configModel = mockConfigs();

    return http.Response(
      jsonEncode(configModel.toJson()),
      200,
    );
  }

  AppConfigModel mockConfigs() {
    final AppConfig config = AppConfig(
      maxActiveBeneficiaries: 5,
      receiverNonVerifiedMaxAmount: 500,
      receiverVerifiedMaxAmount: 1000,
      senderMaxAmount: 3000,
      transactionFee: 1,
    );
    return AppConfigModel.fromEntity(config);
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

  Future<http.Response> makeTransactionResponse({
    required TransactionModel newTransaction,
  }) async {
    final savedUsers = await getSavedUsersList();
    final senderUserIndex = savedUsers.indexWhere(
      (element) => element.id == newTransaction.sourceUserId,
    );
    final senderUser = savedUsers[senderUserIndex];
    if (senderUser.balance < newTransaction.amount + 1) {
      return http.Response(
        jsonEncode({"message": "Not enough balance"}),
        410,
      );
    }
    final double newUserBalance =
        senderUser.balance - 1 - newTransaction.amount;
    final debitedUser = senderUser.copyWith(balance: newUserBalance);
    savedUsers[senderUserIndex] = UserModel.fromEntity(debitedUser);
    await saveUsers(savedUsers);

    final Transaction resultTransaction = newTransaction.copyWith(
      id: senderUser.transactions.length,
      dateTime: DateTime.now(),
    );

    bool canMakeTransaction = checkTransactionPossible(
      resultTransaction,
      userTransactions: senderUser.transactions,
      userBeneficiaries: senderUser.beneficiaries,
      userVerified: senderUser.isVerified,
    );
    if (!canMakeTransaction) {
      return http.Response(
        jsonEncode({"message": "Transaction not possible"}),
        411,
      );
    }

    final TransactionModel resultTransactionModel =
        TransactionModel.fromEntity(resultTransaction);
    senderUser.transactions.add(resultTransactionModel);
    final beneficiaryIndex = senderUser.beneficiaries.indexWhere(
      (element) =>
          element.phoneNumber == resultTransaction.targetUserPhoneNumber,
    );
    senderUser.beneficiaries[beneficiaryIndex].transactions.add(
      resultTransactionModel,
    );
    await saveUsers(savedUsers);
    return http.Response(
      jsonEncode(resultTransactionModel.toJson()),
      200,
    );
  }

  bool checkTransactionPossible(
    Transaction transaction, {
    required List<Transaction> userTransactions,
    required List<Beneficiary> userBeneficiaries,
    required bool userVerified,
  }) {
    TransactionChecks transactionChecks = TransactionChecks(
      dialogs: Dialogs(),
    );
    final bool monthLimitExceeded =
        transactionChecks.checkExceedsMonthTransactions(
      transaction,
      savedUserTransaction: userTransactions,
      appConfig: mockConfigs(),
    );
    if (monthLimitExceeded) return false;

    final bool beneficiaryLimitExceeded =
        transactionChecks.checkExceedsBeneficiaryTransactions(
      transaction,
      savedUserBeneficiaries: userBeneficiaries,
      userVerified: userVerified,
      appConfig: mockConfigs(),
    );
    if (beneficiaryLimitExceeded) return false;

    return true;
  }

  Future<List<UserModel>> getSavedUsersList() async {
    String savedUsersRaw =
        (await localStorage.readValue(ConstStorageKeys.serverUsers)) ?? "{}";
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
      beneficiaries: const [],
      transactions: const [],
    );
    savedUsers.add(resultUser);
    await saveUsers(savedUsers);
    return resultUser;
  }

  Future<void> saveUsers(List<UserModel> savedUsers) async {
    await localStorage.writeValue(
      ConstStorageKeys.serverUsers,
      jsonEncode({"users": savedUsers.map((e) => e.toJson()).toList()}),
    );
  }
}
