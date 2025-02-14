import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/feature/category/widget/bottom_bar_button.dart';
import 'package:categorease/feature/home/bloc/home_bloc.dart';
import 'package:categorease/feature/home/widgets/category_chip.dart';
import 'package:categorease/feature/room/model/room.dart';
import 'package:categorease/feature/search/widgets/user_tile.dart';
import 'package:categorease/gen/assets.gen.dart';
import 'package:categorease/utils/app_dialog.dart';
import 'package:categorease/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChatRoomDetailArgs {
  final Room room;

  ChatRoomDetailArgs({required this.room});
}

class ChatRoomDetail extends StatefulWidget {
  const ChatRoomDetail({super.key, required this.room});

  final Room room;

  @override
  State<ChatRoomDetail> createState() => _ChatRoomDetailState();
}

class _ChatRoomDetailState extends State<ChatRoomDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Flexible(
              flex: 1,
              child: Material(
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                color: Colors.transparent,
                child: Ink.image(
                  image: AssetImage(
                    widget.room.participants.length == 2
                        ? Assets.images.singleDefault.path
                        : Assets.images.groupDefaultPng.path,
                  ),
                  width: 50,
                  height: 50,
                ),
              ),
            ),
            10.widthMargin,
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 25,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        Text(
                          widget.room.name,
                          style: AppTheme.textTheme.titleSmall,
                        ),
                        10.widthMargin,
                        ...(widget.room.categories
                            .mapIndexed<Widget>(
                              (i, category) => Padding(
                                padding:
                                    EdgeInsets.only(left: i == 0 ? 0 : 6.0),
                                child: CategoryChip(
                                  backgroundColor: category.hexColor.toColor(),
                                  category: category.name,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2.5, horizontal: 10),
                                ),
                              ),
                            )
                            .toList())
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      ...widget.room.participants.mapIndexed(
                        (i, participant) => Padding(
                          padding: EdgeInsets.only(
                            top: i.isFirst() ? 20 : 16,
                            bottom: i.isLast(widget.room.participants) ? 70 : 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 50 /
                                        2, // 50 = actual size of the image in design
                                    backgroundImage: AssetImage(
                                      Assets.images.singleDefault.path,
                                    ),
                                  ),
                                  10.widthMargin,
                                  Text(
                                    participant.user.username,
                                    style: AppTheme.textTheme.titleSmall,
                                  ),
                                ],
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ConfirmationDialog(
                                        title:
                                            'Remove ${participant.user.username} ?',
                                        subtitle:
                                            'Are you sure you want to remove this user?',
                                        rejectAction: () => context.pop(),
                                        confirmTextColor: AppTheme.primaryText,
                                        confirmBackgroundColor:
                                            AppTheme.errorColor,
                                        confirmAction: () {
                                          context.pop();
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  "Remove",
                                  style:
                                      AppTheme.textTheme.labelMedium?.copyWith(
                                    fontSize: 14,
                                    color: AppTheme.errorColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        // (participant) => ListTile(
                        //   leading: CircleAvatar(
                        //     radius: 50 / 2, // 50 = actual size of the image in design
                        //     backgroundImage: AssetImage(
                        //       Assets.images.singleDefault.path,
                        //     ),
                        //   ),
                        //   title: Text(
                        //     participant.user.username,
                        //     style: AppTheme.textTheme.titleSmall,
                        //   ),
                        //   trailing: TextButton(
                        //     onPressed: () {
                        //       showDialog(
                        //         context: context,
                        //         builder: (context) {
                        //           return ConfirmationDialog(
                        //             title: 'Remove ${participant.user.username} ?',
                        //             subtitle:
                        //                 'Are you sure you want to remove this user?',
                        //             rejectAction: () => context.pop(),
                        //             confirmTextColor: AppTheme.primaryText,
                        //             confirmBackgroundColor: AppTheme.errorColor,
                        //             confirmAction: () {
                        //               context.pop();
                        //             },
                        //           );
                        //         },
                        //       );
                        //     },
                        //     child: Text(
                        //       "Remove",
                        //       style: AppTheme.textTheme.labelMedium?.copyWith(
                        //         fontSize: 14,
                        //         color: AppTheme.errorColor,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ),
                      // Row(
                      //   children: [
                      //     CircleAvatar(
                      //       radius: 50 / 2, // 50 = actual size of the image in design
                      //       backgroundImage: AssetImage(
                      //         Assets.images.singleDefault.path,
                      //       ),
                      //     ),
                      //     Text(
                      //       'Ibkaanhar',
                      //       style: AppTheme.textTheme.titleSmall,
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              left: 0,
              child: BottomBarButton(
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Add User'),
                      ),
                    ),
                    10.heightMargin,
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Add Category'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
