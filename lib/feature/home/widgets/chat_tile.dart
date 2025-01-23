import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/gen/assets.gen.dart';
import 'package:categorease/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.profileUrl,
    required this.username,
    required this.message,
    required this.unreadCount,
    this.categories,
  });

  final String profileUrl;
  final String username;
  final String message;
  final int unreadCount;
  final List<Widget>? categories;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        7.heightMargin,
        InkWell(
          onTap: () {
            debugPrint("chat tapped...");
          },
          child: Container(
            padding:
                const EdgeInsets.only(top: 7, bottom: 7, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Material(
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.transparent,
                      child: Ink.image(
                        image: NetworkImage(profileUrl),
                        width: 50,
                        height: 50,
                        child: InkWell(
                          onTap: () => _showDialog(context),
                        ),
                      ),
                    ),
                    10.widthMargin,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              username,
                              style: AppTheme.textTheme.titleSmall,
                            ),
                            if (categories != null ||
                                (categories?.isNotEmpty ?? false))
                              ...categories!,
                          ],
                        ),
                        Text(
                          message,
                          style: AppTheme.textTheme.bodyLarge?.copyWith(
                            color: unreadCount == 0
                                ? AppTheme.primaryText.withOpacity(0.5)
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '11.45pm',
                      style: AppTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primaryText.withOpacity(0.5),
                      ),
                    ),
                    if (unreadCount != 0)
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 11, 10),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.activeColor,
                        ),
                        child: Text(
                          unreadCount.toString(),
                          style: AppTheme.textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
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

  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 300,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(profileUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.pop();
                    context.push('/choose-category');
                  },
                  style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                        elevation: const WidgetStatePropertyAll(
                          0,
                        ),
                        overlayColor: WidgetStatePropertyAll(
                            AppTheme.primaryText.withOpacity(0.1)),
                        backgroundColor: const WidgetStatePropertyAll(
                            AppTheme.primaryBackground),
                        shape: WidgetStateProperty.all(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                          ),
                        ),
                      ),
                  child: SvgPicture.asset(
                    Assets.icons.category,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
