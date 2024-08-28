import 'package:flutter/material.dart';

extension SizeExtensions on num {
  Padding get vS => Padding(padding: EdgeInsets.only(bottom: toDouble()));
  Padding get hS => Padding(padding: EdgeInsets.only(left: toDouble()));

  double height(BuildContext context) =>
      MediaQuery.of(context).size.height * this;
  double width(BuildContext context) =>
      MediaQuery.of(context).size.width * this;
}
