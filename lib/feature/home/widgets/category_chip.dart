import 'package:categorease/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.backgroundColor,
    this.category,
    this.child,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 7,
    ),
  }) : assert(
          category != null || child != null,
          'Either category or child must be provided',
        );

  final Color backgroundColor;
  final EdgeInsets padding;
  final String? category;
  final Widget? child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: padding,
          child: Center(
            child: child != null
                ? child!
                : Text(
                    category!,
                    style: AppTheme.textTheme.labelSmall?.copyWith(
                      fontSize: 12,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
