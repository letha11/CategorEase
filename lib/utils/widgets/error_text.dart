import 'package:categorease/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  const ErrorText(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: AppTheme.textTheme.bodyMedium?.copyWith(
        color: AppTheme.errorColor,
      ),
    );
  }
}
