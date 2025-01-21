import 'package:categorease/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BottomBarButton extends StatelessWidget {
  const BottomBarButton({
    super.key,
    this.withWrapper = true,
    required this.onButtonTap,
  });

  final bool withWrapper;
  final VoidCallback onButtonTap;

  @override
  Widget build(BuildContext context) {
    if (withWrapper) {
      return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: _buildWidget(),
      );
    }

    return _buildWidget();
  }

  _buildWidget() {
    return Container(
      color: AppTheme.secondaryBackground,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 25),
      child: ElevatedButton(
        onPressed: onButtonTap,
        child: Text(
          'Submit',
          style: AppTheme.textTheme.labelMedium,
        ),
      ),
    );
  }
}
