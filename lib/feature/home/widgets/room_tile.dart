import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/gen/assets.gen.dart';
import 'package:categorease/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class RoomTile extends StatelessWidget {
  const RoomTile({
    super.key,
    required this.imagePath,
    required this.roomName,
    this.lastMessage,
    required this.unreadCount,
    this.onTap,
    required this.chooseCategoryTap,
    this.lastMessageSentAt,
    this.categories,
    this.containerPadding =
        const EdgeInsets.only(top: 7, bottom: 7, left: 16, right: 16),
    this.dividerPadding = const EdgeInsets.symmetric(horizontal: 16),
  });

  final String imagePath;
  final String roomName;
  final String? lastMessage;
  final DateTime? lastMessageSentAt;
  final int unreadCount;
  final List<Widget>? categories;
  final VoidCallback? onTap;
  final VoidCallback chooseCategoryTap;
  final EdgeInsetsGeometry containerPadding;
  final EdgeInsetsGeometry dividerPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        7.heightMargin,
        InkWell(
          onTap: onTap,
          child: Container(
            padding: containerPadding,
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
                          image: AssetImage(imagePath),
                          width: 50,
                          height: 50,
                          child: InkWell(
                            onTap: () => _showDialog(context),
                          ),
                        ),
                      ),
                      10.widthMargin,
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {},
                                child: SizedBox(
                                  height: 25,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        Text(
                                          roomName,
                                          style: AppTheme.textTheme.titleSmall,
                                        ),
                                        if (categories != null ||
                                            (categories?.isNotEmpty ?? false))
                                          ...categories!,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (lastMessage != null)
                              Text(
                                lastMessage!,
                                overflow: TextOverflow.ellipsis,
                                style: AppTheme.textTheme.bodyLarge?.copyWith(
                                  color: unreadCount == 0
                                      ? AppTheme.primaryText.withOpacity(0.5)
                                      : null,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (lastMessageSentAt != null)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        lastMessageSentAt?.toHourFormattedString() ?? '.. : ..',
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
        Padding(
          padding: dividerPadding,
          child: const Divider(
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
                      image: AssetImage(imagePath),
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
                    chooseCategoryTap();
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
