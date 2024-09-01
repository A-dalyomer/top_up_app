import 'package:flutter/material.dart';

/// Size extensions on numbers
/// Contains utils for empty padding spaces and responsive size calculation
extension SizeExtensions on num {
  /// Vertical space padding
  Padding get vS => Padding(padding: EdgeInsets.only(bottom: toDouble()));

  /// Horizontal space padding
  Padding get hS => Padding(padding: EdgeInsets.only(left: toDouble()));

  /// Returns the number compared to overall screen height percentage
  double height(BuildContext context) =>
      MediaQuery.of(context).size.height * this;

  /// Returns the number compared to overall screen width percentage
  double width(BuildContext context) =>
      MediaQuery.of(context).size.width * this;
}
