import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/utils/extension.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.subtitle,
    this.rejectTextColor = AppTheme.primaryText,
    this.rejectBackgroundColor = AppTheme.primaryBackground,
    required this.rejectAction,
    this.confirmTextColor = AppTheme.primaryBackground,
    this.confirmBackgroundColor = AppTheme.primaryButton,
    required this.confirmAction,
  });

  final String title;
  final String subtitle;
  final String firstActionText = 'No';
  final Color rejectTextColor;
  final Color rejectBackgroundColor;
  final void Function() rejectAction;
  final String secondActionText = 'Yes';
  final Color confirmTextColor;
  final Color confirmBackgroundColor;
  final void Function() confirmAction;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          15.heightMargin,
          Text(subtitle),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                      elevation: const WidgetStatePropertyAll(0),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: AppTheme.secondaryBackground,
                          ),
                        ),
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                        rejectBackgroundColor,
                      ),
                    ),
                onPressed: rejectAction,
                child: Text(
                  firstActionText,
                  style: const TextStyle(
                    color: AppTheme.primaryText,
                  ),
                ),
              ),
            ),
            8.widthMargin,
            Expanded(
              child: ElevatedButton(
                onPressed: confirmAction,
                style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                      elevation: const WidgetStatePropertyAll(0),
                      backgroundColor: WidgetStatePropertyAll(
                        confirmBackgroundColor,
                      ),
                    ),
                child: Text(
                  secondActionText,
                  style: TextStyle(color: confirmTextColor),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
