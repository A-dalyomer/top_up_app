import 'package:flutter/material.dart';

extension SizeExtensions on num {
  Padding get vS => Padding(padding: EdgeInsets.only(bottom: toDouble()));
  Padding get hS => Padding(padding: EdgeInsets.only(left: toDouble()));
}
