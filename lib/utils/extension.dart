import 'package:categorease/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

extension ScreenSize on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
}

extension IntMargin on int {
  Widget get widthMargin => SizedBox(width: toDouble());
  Widget get heightMargin => SizedBox(height: toDouble());

  SliverToBoxAdapter get sliverWidthMargin =>
      SliverToBoxAdapter(child: SizedBox(width: toDouble()));
  SliverToBoxAdapter get sliverHeightMargin =>
      SliverToBoxAdapter(child: SizedBox(height: toDouble()));
}

extension IntDuration on int {
  Duration get seconds => Duration(seconds: this);
  Duration get milliseconds => Duration(milliseconds: this);
}

extension DoubleMargin on double {
  Widget get widthMargin => SizedBox(width: this);
  Widget get heightMargin => SizedBox(height: this);

  SliverToBoxAdapter get sliverWidthMargin =>
      SliverToBoxAdapter(child: SizedBox(width: this));
  SliverToBoxAdapter get sliverHeightMargin =>
      SliverToBoxAdapter(child: SizedBox(height: this));
}

extension StringHex on Color {
  String get toHex => value.toRadixString(16).substring(2);
}

extension HexColor on String {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  Color toColor() {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write('ff');
    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension FormattedDate on DateTime {
  String toHourFormattedString() {
    final hourFormatter = DateFormat('HH:mmaaa');

    return hourFormatter.format(this);
  }

  String toFormattedString() {
    DateTime now = DateTime.now();
    final fullFormatter = DateFormat('d-MM-yyyy, HH:mm');
    final hourFormatter = DateFormat('HH:mm');

    if (year == now.year && month == now.month && day == now.day) {
      return 'Today, ${hourFormatter.format(this)}';
    } else if (year == now.year && month == now.month && day == now.day - 1) {
      return 'Yesterday, ${hourFormatter.format(this)}';
    }

    return fullFormatter.format(this);
  }
}

extension DioExceptionExt on DioException {
  String? get messageData => response?.data['message'];
}

extension GoRouterExt on GoRouter {
  String get _currentRoute =>
      routerDelegate.currentConfiguration.matches.last.matchedLocation;

  /// Pop until the route with the given [path] is reached.
  /// Example
  /// ``` dart
  ///  GoRouter.of(context).popUntil(SettingsScreen.route);
  /// ```

  void popUntil(String path) {
    var currentRoute = _currentRoute;
    while (currentRoute != path && canPop()) {
      pop();
      currentRoute = _currentRoute;
    }
  }
}

extension IsHelper on NextPageStatus {
  bool get isInitial => this == NextPageStatus.initial;
  bool get isLoading => this == NextPageStatus.loading;
  bool get isLoaded => this == NextPageStatus.loaded;
  bool get isError => this == NextPageStatus.error;
}
