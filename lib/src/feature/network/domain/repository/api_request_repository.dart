/// Contract for API requests handlers of Get and POST types
abstract class ApiRequestRepository {
  /// Performs an API 'GET' request
  /// Returns the response as 'MAP' and null if any error happened
  Future<Map<String, dynamic>?> getRequest(
    String apiPath, {
    Map<String, String>? headers,
    Function(int)? requestCodesHandler,
  });

  /// Performs an API 'POST' request
  /// Returns the response as 'MAP' and null if any error happened
  Future<Map<String, dynamic>?> postRequest(
    String apiPath, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Function(int)? requestCodesHandler,
  });
}
