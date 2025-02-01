import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoData extends StatelessWidget {
  const NoData({
    super.key,
    this.message = 'No Data found',
    this.subMessage,
  });

  final String message;
  final String? subMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(Assets.images.noData),
        Text(
          message,
          textAlign: TextAlign.center,
          style: AppTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        if (subMessage != null || (subMessage?.isNotEmpty ?? false))
          Text(
            subMessage!,
            textAlign: TextAlign.center,
            style: AppTheme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w300,
            ),
          ),
      ],
    );
  }
}
