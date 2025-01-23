import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/gen/assets.gen.dart';
import 'package:categorease/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserTile extends StatelessWidget {
  const UserTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        7.heightMargin,
        InkWell(
          onTap: () => _showConfirmationDialog(context),
          child: Container(
            padding:
                const EdgeInsets.only(top: 7, bottom: 7, left: 16, right: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                            // onTap: () => _showDialog(context),
                            onTap: () {},
                          ),
                        ),
                      ),
                      10.widthMargin,
                      Text(
                        'ibkaanhar',
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
        return AlertDialog(
          title: const Text('Create a room with this person ?'),
          content:
              const Text('Are you sure you want to chat with this person?'),
          actions: [
            Row(
              children: [
                Expanded(
                  // width: double.infinity,
                  child: ElevatedButton(
                    style:
                        Theme.of(context).elevatedButtonTheme.style?.copyWith(
                              elevation: const WidgetStatePropertyAll(0),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                      color: AppTheme.secondaryBackground),
                                ),
                              ),
                              backgroundColor: const WidgetStatePropertyAll(
                                AppTheme.primaryBackground,
                              ),
                            ),
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text('No',
                        style: TextStyle(color: AppTheme.primaryText)),
                  ),
                ),
                8.widthMargin,
                Expanded(
                  // width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/create-room');
                    },
                    child: const Text('Yes'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
