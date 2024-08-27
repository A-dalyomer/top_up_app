import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uae_top_up/src/feature/network/data/constants/const_api_paths.dart';

import '../../domain/repository/api_request_repository.dart';
import '../../domain/util/api_general_handler.dart';

class ApiRequestRepositoryImpl implements ApiRequestRepository {
  ApiRequestRepositoryImpl({required this.apiClient});
  final http.Client apiClient;

  @override
  Future<Map<String, dynamic>?> getRequest(
    String apiPath, {
    Map<String, String>? headers,
    Function(int)? requestCodesHandler,
  }) async {
    return await _makeRequest(
      request: () async => await apiClient.get(
        Uri.parse(ConstApiPaths.domainLink + apiPath),
        headers: headers,
      ),
      requestCodesHandler: (code) => requestCodesHandler?.call(code),
    );
  }

  @override
  Future<Map<String, dynamic>?> postRequest(
    String apiPath, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Function(int)? requestCodesHandler,
  }) async {
    return await _makeRequest(
      request: () async => await apiClient.post(
        Uri.parse(ConstApiPaths.domainLink + apiPath),
        headers: headers,
        body: jsonEncode(body),
      ),
      requestCodesHandler: (code) => requestCodesHandler?.call(code),
    );
  }

  Future<Map<String, dynamic>?> _makeRequest({
    required Future<http.Response> Function() request,
    required Function(int)? requestCodesHandler,
  }) async {
    try {
      http.Response response = await request();
      if (response.statusCode != 200) {
        requestCodesHandler?.call(response.statusCode) ??
            APIRequestHandlers.requestException(response);
        return null;
      }
      return jsonDecode(response.body);
    } on http.ClientException catch (requestException) {
      APIRequestHandlers.noResponseRequestException(requestException);
    } catch (otherExceptions) {
      APIRequestHandlers.unknownRequestException(otherExceptions);
    }
    return null;
  }
}
