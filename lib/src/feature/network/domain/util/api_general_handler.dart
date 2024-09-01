import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:uae_top_up/src/core/util/dialogs.dart';
import 'package:uae_top_up/top_up_app.dart';

/// API errors handler for `APIRequestsRepositoryImpl`
class APIRequestHandlers {
  APIRequestHandlers({required this.dialogs});

  /// Dialogs instance to show dialogs
  final Dialogs dialogs;

  /// General request errors handler for responses status code other than 200
  void requestException(http.Response response) {
    if (kDebugMode) {
      print(response.body.toString());
    }
    switch (response.statusCode) {
      default:
        if (kDebugMode) {
          print("unknown status code: ${response.statusCode}");
        }
        final BuildContext? context = globalNavigatorKey.currentState?.context;
        if (context?.mounted ?? false) {
          dialogs.showMessageDialog(
            context!,
            jsonDecode(response.body)['message'],
          );
        }
    }
    _logAnalyticsEvent();
  }

  /// General API Client exceptions handler
  /// Such as a connection error
  void noResponseRequestException(dynamic exception) {
    if (kDebugMode) {
      print(exception.toString());
    }
    _logAnalyticsEvent();
  }

  /// General API unknown errors handler
  /// Handles cases where unexpected error happening
  void unknownRequestException(dynamic exception) {
    if (kDebugMode) {
      print(exception.toString());
    }
    _logAnalyticsEvent();
  }

  /// Internal calls for General API errors logger
  /// Such as 'Firebase Crashlytics' or our 'internal server logs'
  static void _logAnalyticsEvent() {
    /// Log request exceptions
  }
}
