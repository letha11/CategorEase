import 'package:categorease/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  const SettingItem({
    super.key,
    required this.title,
    required this.onTap,
    this.titleOnly = false,
    this.color = AppTheme.primaryText,
  });

  final String title;
  final bool titleOnly;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        title,
                        textAlign:
                            titleOnly ? TextAlign.center : TextAlign.start,
                        style: AppTheme.textTheme.titleSmall?.copyWith(
                          fontSize: 16,
                          color: color,
                        ),
                      ),
                    ),
                  ),
                  if (!titleOnly)
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: color,
                        size: 18,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
