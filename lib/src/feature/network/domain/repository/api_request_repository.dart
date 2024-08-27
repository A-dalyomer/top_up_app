abstract class ApiRequestRepository {
  Future<Map<String, dynamic>?> getRequest(
    String apiPath, {
    Map<String, String>? headers,
    Function(int)? requestCodesHandler,
  });

  Future<Map<String, dynamic>?> postRequest(
    String apiPath, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Function(int)? requestCodesHandler,
  });
}
