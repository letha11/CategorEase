import 'package:flutter/material.dart';

extension IntMargin on int {
  Widget get widthMargin => SizedBox(width: toDouble());
  Widget get heightMargin => SizedBox(height: toDouble());
}

extension DoubleMargin on double {
  Widget get widthMargin => SizedBox(width: this);
  Widget get heightMargin => SizedBox(height: this);
}
