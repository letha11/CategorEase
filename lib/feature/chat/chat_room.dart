import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/feature/category/widget/bottom_bar_button.dart';
import 'package:categorease/feature/chat/cubit/chat_room/chat_room_cubit.dart';
import 'package:categorease/feature/chat/model/chat.dart';
import 'package:categorease/feature/home/widgets/category_chip.dart';
import 'package:categorease/gen/assets.gen.dart';
import 'package:categorease/utils/extension.dart';
import 'package:categorease/utils/widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ChatRoom extends StatelessWidget {
  const ChatRoom({super.key});

  @override
  Widget build(BuildContext context) {
    final cubitState = context.read<ChatRoomCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Material(
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              color: Colors.transparent,
              child: Ink.image(
                image: const NetworkImage(
                    'https://i.scdn.co/image/ab67616d00001e028c6d178bff293a896f8e38e5'),
                width: 50,
                height: 50,
                child: InkWell(
                  onTap: () => _showProfileDialog(context),
                ),
              ),
            ),
            10.widthMargin,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Goofy',
                  style: AppTheme.textTheme.titleSmall,
                ),
                4.heightMargin,
                const CategoryChip(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2.5,
                  ),
                  category: 'Work',
                ),
              ],
            ),
          ],
        ),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            if (cubitState.chats.isNotEmpty)
              BlocBuilder<ChatRoomCubit, ChatRoomState>(
                  builder: (context, state) {
                return ListView.builder(
                  itemCount: state.chats.length,
                  reverse: true,
                  itemBuilder: (context, i) {
                    // FIXME: should change to the authenticated user later
                    final isSender = state.chats[i].isSender(
                      'Goofy',
                    );
                    final Chat chat = state.chats[i];
                    return Align(
                      alignment: isSender
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.height * 0.5 -
                              (16 * 2),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),

                          /// The list are reversed.
                          margin: EdgeInsets.only(
                            bottom: i == 0 ? 100 : 8,
                            left: isSender
                                ? MediaQuery.of(context).size.width * 0.2
                                : 16,
                            right: isSender
                                ? 16
                                : MediaQuery.of(context).size.width * 0.2,
                            top: i == (state.chats.length - 1) ? 16 : 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSender
                                ? AppTheme.secondaryBackground
                                : AppTheme.primaryInput,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isSender) // FIXME: only show this on group(room that have greater than 2 user) room
                                Text(
                                  chat.sentBy,
                                  style: AppTheme.textTheme.titleSmall
                                      ?.copyWith(fontSize: 14),
                                ),
                              Text(
                                // chat.content,
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam, Lorem ipsum dolor sit amet, consectetur adipiscing elit. NullamLorem ipsum dolor sit amet, consectetur adipiscing elit. NullamLorem ipsum dolor sit amet, consectetur adipiscing elit. NullamLorem ipsum dolor sit amet, consectetur adipiscing elit. NullamLorem ipsum dolor sit amet, consectetur adipiscing elit. NullamLorem ipsum dolor sit amet, consectetur adipiscing elit. NullamLorem ipsum dolor sit amet, consectetur adipiscing elit. NullamLorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam',
                                style: AppTheme.textTheme.bodyLarge,
                              ),
                              5.heightMargin,
                              Builder(builder: (context) {
                                return Row(
                                  mainAxisAlignment: isSender
                                      ? MainAxisAlignment.spaceBetween
                                      : MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      chat.updatedAt.toFormattedString(),
                                      style: AppTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: AppTheme.primaryText
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                    if (isSender)
                                      SeenIcon(
                                        isSeen: true,
                                      ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              })
            else
              const NoData(
                message: 'No Message found',
                subMessage: 'Try sending a message first',
              ),
            BottomBarButton(
              withWrapper: true,
              child: ConstrainedBox(
                // height: 100,
                constraints: BoxConstraints(
                  maxHeight: 100,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: context
                            .read<ChatRoomCubit>()
                            .state
                            .messageController,
                        minLines: 1,
                        maxLines: 3,
                        onChanged: context.read<ChatRoomCubit>().updateMessage,
                        scrollPadding: EdgeInsets.zero,
                        decoration: const InputDecoration(
                          hintText: 'Your message',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 11),
                        ),
                      ),
                    ),
                    6.widthMargin,
                    BlocBuilder<ChatRoomCubit, ChatRoomState>(
                        builder: (context, state) {
                      return Expanded(
                        flex: 1,
                        child: SizedBox(
                          // height: double.infinity,
                          child: ElevatedButton(
                            onPressed: state.message.isNotEmpty ? () {} : null,
                            child: const Text('Send'),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileDialog(BuildContext context) {
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
                      image: AssetImage(Assets.images.singleDefault.path),
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

class SeenIcon extends StatelessWidget {
  SeenIcon({super.key, this.isSeen = false});

  final bool isSeen;
  final double gap = 5;

  @override
  Widget build(BuildContext context) {
    return Container(
      // honestly this is just me trying so that the icon are visible and not clipped
      width: 14 + 14 - (gap),
      padding: EdgeInsets.only(right: gap),
      child: Stack(
        children: [
          Icon(
            Icons.check,
            size: 14,
            color: isSeen ? Colors.blue : Colors.grey,
          ),
          Positioned(
            left: gap,
            top: 0,
            child: Icon(
              Icons.check,
              size: 14,
              color: isSeen ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
