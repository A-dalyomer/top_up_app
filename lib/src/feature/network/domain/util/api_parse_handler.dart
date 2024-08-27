import 'package:flutter/foundation.dart';

class APIParseHandlers {
  static void handleModelParseException(dynamic exception) {
    if (kDebugMode) {
      print(exception.toString());
    }
  }
}
