import 'package:categorease/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../config/theme/app_theme.dart';
import '../../gen/assets.gen.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    required this.message,
    this.iconColor = AppTheme.primaryText,
    this.subMessage,
  });

  final String message;
  final String? subMessage;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Assets.icons.info,
            width: 64,
            height: 64,
            colorFilter: ColorFilter.mode(
              iconColor,
              BlendMode.srcIn,
            ),
          ),
          10.heightMargin,
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          5.heightMargin,
          if (subMessage != null && (subMessage?.isNotEmpty ?? false))
            Text(
              subMessage!,
              textAlign: TextAlign.center,
              style: AppTheme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w300,
                color: AppTheme.primaryText.withOpacity(0.5),
              ),
            ),
        ],
      ),
    );
  }
}
