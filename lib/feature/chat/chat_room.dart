import 'package:collection/collection.dart';
import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/feature/category/model/category.dart';
import 'package:categorease/feature/category/widget/bottom_bar_button.dart';
import 'package:categorease/feature/chat/bloc/chat_bloc.dart';
import 'package:categorease/feature/chat/cubit/chat_room/chat_room_cubit.dart';
import 'package:categorease/feature/chat/model/chat.dart';
import 'package:categorease/feature/home/bloc/home_bloc.dart';
import 'package:categorease/feature/home/widgets/category_chip.dart';
import 'package:categorease/gen/assets.gen.dart';
import 'package:categorease/utils/extension.dart';
import 'package:categorease/utils/websocket_helper.dart';
import 'package:categorease/utils/widgets/error_widget.dart';
import 'package:categorease/utils/widgets/loading.dart';
import 'package:categorease/utils/widgets/no_data.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ChatRoomArgs extends Equatable {
  final WebsocketModel websocketModel;
  final int roomId;

  const ChatRoomArgs({required this.websocketModel, required this.roomId});

  @override
  List<Object?> get props => [websocketModel, roomId];
}

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key, required this.roomId});

  final int roomId;

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController messageController = TextEditingController();
  late final ChatRoomState cubitState;
  ChatInitialLoaded? blocState;

  @override
  void initState() {
    super.initState();

    cubitState = context.read<ChatRoomCubit>().state;
    context.read<ChatBloc>().add(FetchChat(roomId: widget.roomId));

    cubitState.scrollController.addListener(() {
      if (blocState == null) return;

      if (cubitState.scrollController.position.pixels <=
          cubitState.scrollController.position.maxScrollExtent - 100) return;

      if (blocState!.nextPageStatus.isLoading) return;
      context.read<ChatBloc>().add(FetchChatNextPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Flexible(
              flex: 1,
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is! ChatInitialLoaded) {
                    return const CircleAvatar(
                      radius: 25,
                    );
                  }
                  return Material(
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    color: Colors.transparent,
                    child: Ink.image(
                      image: AssetImage(
                        state.roomDetail.participants.length == 2
                            ? Assets.images.singleDefault.path
                            : Assets.images.groupDefaultPng.path,
                      ),
                      width: 50,
                      height: 50,
                      child: InkWell(
                        onTap: () => _showProfileDialog(context),
                      ),
                    ),
                  );
                },
              ),
            ),
            10.widthMargin,
            Expanded(
              flex: 5,
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is! ChatInitialLoaded) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 25,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: [
                            Text(
                              state.roomDetail.name,
                              style: AppTheme.textTheme.titleSmall,
                            ),
                            10.widthMargin,
                            ...(state.roomDetail.categories
                                .mapIndexed<Widget>(
                                  (i, category) => Padding(
                                    padding:
                                        EdgeInsets.only(left: i == 0 ? 0 : 6.0),
                                    child: CategoryChip(
                                      backgroundColor:
                                          category.hexColor.toColor(),
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
                      Text(
                        state.roomDetail.participants.map((e) {
                          if (e.user.username ==
                              (context.read<HomeBloc>().state as HomeLoaded)
                                  .authenticatedUser
                                  .username) {
                            return 'You';
                          }

                          return e.user.username;
                        }).join(', '),
                        style: AppTheme.textTheme.labelMedium?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            SizedBox(
              width: context.screenWidth,
              height: context.screenHeight,
              child: CustomScrollView(
                controller: cubitState.scrollController,
                reverse: true,
                slivers: [
                  BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      if (state is ChatInitialLoading || state is ChatInitial) {
                        return const SliverFillRemaining(
                          child: Center(child: Loading()),
                        );
                      } else if (state is ChatInitialError) {
                        final message = state.failure?.message;
                        return SliverFillRemaining(
                          child: AppErrorWidget(
                            message:
                                message ?? 'Something went wrong, try again',
                          ),
                        );
                      }

                      if (state is! ChatInitialLoaded) {
                        return const SliverFillRemaining(
                          child: AppErrorWidget(
                            message: 'Something went wrong, try again',
                          ),
                        );
                      }

                      if (state.chats.data.isEmpty) {
                        return const SliverFillRemaining(
                          child: NoData(
                            message: 'No Message found',
                            subMessage: 'Try sending a message first',
                          ),
                        );
                      }

                      blocState = state;

                      return SliverList.builder(
                        itemCount: state.chats.data.length,
                        itemBuilder: (context, i) {
                          final homeState =
                              context.read<HomeBloc>().state as HomeLoaded;
                          final isSender = state.chats.data[i].isSender(
                            homeState.authenticatedUser.username,
                          );
                          final Chat chat = state.chats.data[i];

                          return Align(
                            alignment: isSender
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.height * 0.5 -
                                        (16 * 2),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(10),

                                /// List are reversed
                                margin: EdgeInsets.only(
                                  bottom: i == 0 ? 100 : 8,
                                  left: isSender
                                      ? MediaQuery.of(context).size.width * 0.2
                                      : 16,
                                  right: isSender
                                      ? 16
                                      : MediaQuery.of(context).size.width * 0.2,
                                  top: i == (state.chats.data.length - 1)
                                      ? 16
                                      : 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSender
                                      ? AppTheme.secondaryBackground
                                      : AppTheme.primaryInput,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: isSender
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    if (!isSender) // FIXME: only show this on group(room that have greater than 2 user) room
                                      Text(
                                        chat.sentBy,
                                        style: AppTheme.textTheme.titleSmall
                                            ?.copyWith(fontSize: 14),
                                      ),
                                    Text(
                                      chat.content,
                                      textAlign:
                                          isSender ? TextAlign.end : null,
                                      style: AppTheme.textTheme.bodyLarge,
                                    ),
                                    5.heightMargin,
                                    Text(
                                      chat.updatedAt.toFormattedString(),
                                      style: AppTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: AppTheme.primaryText
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                    // Builder(builder: (context) {
                                    //   return Row(
                                    //     mainAxisAlignment: isSender
                                    //         ? MainAxisAlignment.spaceBetween
                                    //         : MainAxisAlignment.end,
                                    //     children: [
                                    //       Text(
                                    //         chat.updatedAt.toFormattedString(),
                                    //         style:
                                    //             AppTheme.textTheme.bodyMedium?.copyWith(
                                    //           color:
                                    //               AppTheme.primaryText.withOpacity(0.5),
                                    //         ),
                                    //       ),
                                    //       // if (isSender)
                                    //       //   SeenIcon(
                                    //       //     isSeen: true,
                                    //       //   ),
                                    //     ],
                                    //   );
                                    // }),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      if (state is! ChatInitialLoaded) {
                        return const SliverToBoxAdapter(
                          child: SizedBox.shrink(),
                        );
                      }

                      if (!state.nextPageStatus.isLoading) {
                        return const SliverToBoxAdapter(
                          child: SizedBox.shrink(),
                        );
                      }

                      return const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 8),
                          child: Center(
                            child: Loading(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            BottomBarButton(
              withWrapper: true,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 100,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: messageController,
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
                          child: ElevatedButton(
                            onPressed: state.message.isNotEmpty
                                ? () {
                                    final val = state.message;
                                    messageController.clear();
                                    context
                                        .read<ChatRoomCubit>()
                                        .cleanMessageController();

                                    context
                                        .read<ChatBloc>()
                                        .add(SendChatMessage(message: val));
                                  }
                                : null,
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
