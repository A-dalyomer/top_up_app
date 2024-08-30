import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class APIRequestHandlers {
  void requestException(http.Response response) {
    if (kDebugMode) {
      print(response.body.toString());
    }
    switch (response.statusCode) {
      default:
        if (kDebugMode) {
          print("unknown status code: ${response.statusCode}");
        }
    }
    _logAnalyticsEvent();
  }

  void noResponseRequestException(dynamic exception) {
    if (kDebugMode) {
      print(exception.toString());
    }
    _logAnalyticsEvent();
  }

  void unknownRequestException(dynamic exception) {
    if (kDebugMode) {
      print(exception.toString());
    }
    _logAnalyticsEvent();
  }

  static void _logAnalyticsEvent() {
    /// Log request exceptions
  }
}
