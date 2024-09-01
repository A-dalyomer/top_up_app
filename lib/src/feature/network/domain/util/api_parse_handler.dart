import 'package:flutter/foundation.dart';

/// General API parse errors handler
class APIParseHandlers {
  /// General handler for all Model parsing exceptions
  /// Currently only prints the exception in debug mode
  static void handleModelParseException(dynamic exception) {
    if (kDebugMode) {
      print(exception.toString());
    }
  }
}
