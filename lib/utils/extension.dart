import 'package:flutter/material.dart';

extension IntMargin on int {
  Widget get widthMargin => SizedBox(width: toDouble());
  Widget get heightMargin => SizedBox(height: toDouble());
}

extension DoubleMargin on double {
  Widget get widthMargin => SizedBox(width: this);
  Widget get heightMargin => SizedBox(height: this);
}

extension HexColor on String {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  Color fromHex() {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write('ff');
    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
