import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class APIRequestHandlers {
  static void requestException(http.Response response) {
    if (kDebugMode) {
      print(response.toString());
    }
    switch (response.statusCode) {
      default:
        if (kDebugMode) {
          print("unknown status code: ${response.statusCode}");
        }
    }
    _logAnalyticsEvent();
  }

  static void noResponseRequestException(dynamic exception) {
    if (kDebugMode) {
      print(exception.toString());
    }
    _logAnalyticsEvent();
  }

  static void unknownRequestException(dynamic exception) {
    if (kDebugMode) {
      print(exception.toString());
    }
    _logAnalyticsEvent();
  }

  static void _logAnalyticsEvent() {
    /// Log request exceptions
  }
}
