import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class SettingWrapper extends StatelessWidget {
  const SettingWrapper({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      // padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.secondaryBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: children.mapWithIndex<Widget>(
          (widget, index) {
            return Column(
              children: [
                widget,
                if (index != children.length - 1) 8.heightMargin,
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}
