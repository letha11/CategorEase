import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/gen/assets.gen.dart';
import 'package:categorease/utils/app_dialog.dart';
import 'package:categorease/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
    required this.username,
    this.onTap,
    this.prefix,
  });

  final VoidCallback? onTap;
  final String username;
  final Widget? prefix;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        7.heightMargin,
        InkWell(
          onTap: onTap,
          child: Container(
            padding:
                const EdgeInsets.only(top: 7, bottom: 7, left: 16, right: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                prefix ?? const SizedBox(),
                Expanded(
                  child: Row(
                    children: [
                      Material(
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        color: Colors.transparent,
                        child: Ink.image(
                          image: AssetImage(Assets.images.singleDefault.path),
                          width: 50,
                          height: 50,
                          child: InkWell(
                            onTap: () {},
                          ),
                        ),
                      ),
                      10.widthMargin,
                      Text(
                        username,
                        style: AppTheme.textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        7.heightMargin,
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Divider(
            height: 1,
            color: AppTheme.primaryDivider,
          ),
        ),
      ],
    );
  }

  _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          title: 'Create a room with this person ?',
          subtitle: 'Are you sure you want to chat with this person?',
          rejectAction: () {
            context.pop();
          },
          confirmAction: () {
            context.pop();
            context.push('/create-room');
          },
        );
      },
    );
  }
}
