import 'package:flutter/material.dart';
import '../../config/theme/app_theme.dart';

class AppRefreshIndicator extends StatelessWidget {
  const AppRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      backgroundColor: AppTheme.secondaryBackground,
      color: AppTheme.activeColor,
      child: child,
    );
  }
}
