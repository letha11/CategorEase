import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/core/failures.dart';
import 'package:categorease/feature/category/choose_category.dart';
import 'package:categorease/feature/category/widget/bottom_bar_button.dart';
import 'package:categorease/feature/chat/add_user_room.dart';
import 'package:categorease/feature/chat/bloc/chat_room_detail/bloc/chat_room_detail_bloc.dart';
import 'package:categorease/feature/home/bloc/home_bloc.dart';
import 'package:categorease/feature/home/widgets/category_chip.dart';
import 'package:categorease/feature/room/model/room.dart';
import 'package:categorease/gen/assets.gen.dart';
import 'package:categorease/utils/app_dialog.dart';
import 'package:categorease/utils/extension.dart';
import 'package:categorease/utils/widgets/error_widget.dart';
import 'package:categorease/utils/widgets/loading_overlay.dart';
import 'package:categorease/utils/widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChatRoomDetailArgs {
  final Room room;

  ChatRoomDetailArgs({required this.room});
}

class ChatRoomDetail extends StatefulWidget {
  const ChatRoomDetail({super.key});

  @override
  State<ChatRoomDetail> createState() => _ChatRoomDetailState();
}

class _ChatRoomDetailState extends State<ChatRoomDetail> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Material(
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    color: Colors.transparent,
                    child: BlocBuilder<ChatRoomDetailBloc, ChatRoomDetailState>(
                      builder: (context, state) {
                        return Ink.image(
                          image: AssetImage(
                            state.room?.participants.length == 2
                                ? Assets.images.singleDefault.path
                                : Assets.images.groupDefaultPng.path,
                          ),
                          width: 50,
                          height: 50,
                        );
                      },
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
                        child: BlocBuilder<ChatRoomDetailBloc,
                            ChatRoomDetailState>(
                          builder: (context, state) {
                            return ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: [
                                Text(
                                  state.room?.name ?? '',
                                  style: AppTheme.textTheme.titleSmall,
                                ),
                                10.widthMargin,
                                ...((state.room?.categories ?? [])
                                    .mapIndexed<Widget>(
                                      (i, category) => Padding(
                                        padding: EdgeInsets.only(
                                            left: i == 0 ? 0 : 6.0),
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
                            );
                          },
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: BlocBuilder<ChatRoomDetailBloc, ChatRoomDetailState>(
                      builder: (context, state) {
                        return ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: state.room?.participants.length ?? 0,
                          itemBuilder: (_, i) {
                            final participant = state.room?.participants[i];
                            final authUser =
                                (context.read<HomeBloc>().state as HomeLoaded)
                                    .authenticatedUser;
                            final authParticipant =
                                state.room.participants.firstWhere(
                              (p) => p.user.username == authUser.username,
                            );

                            if (participant == null) {
                              return const NoData();
                            }

                            return Padding(
                              padding: EdgeInsets.only(
                                top: i.isFirst() ? 20 : 16,
                                bottom: i.isLast(state.room?.participants ?? [])
                                    ? 70
                                    : 0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        (context.read<HomeBloc>().state
                                                        as HomeLoaded)
                                                    .authenticatedUser
                                                    .username ==
                                                participant.user.username
                                            ? 'You (${participant.user.username})'
                                            : participant.user.username,
                                        style: AppTheme.textTheme.titleSmall,
                                      ),
                                    ],
                                  ),
                                  if (authParticipant.role.isAdmin)
                                    // a room cannot have less than 2 participants
                                    if ((state.room.participants).length >= 3 &&
                                        authUser.username !=
                                            participant.user.username)
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) {
                                              return ConfirmationDialog(
                                                title:
                                                    'Remove ${participant.user.username} ?',
                                                subtitle:
                                                    'Are you sure you want to remove this user?',
                                                rejectAction: () =>
                                                    context.pop(),
                                                confirmTextColor:
                                                    AppTheme.primaryText,
                                                confirmBackgroundColor:
                                                    AppTheme.errorColor,
                                                confirmAction: () {
                                                  context
                                                      .read<
                                                          ChatRoomDetailBloc>()
                                                      .add(
                                                        ChatRoomDetailRemoveUser(
                                                          userId: participant
                                                              .user.id,
                                                        ),
                                                      );
                                                  context.pop();
                                                },
                                              );
                                            },
                                          );
                                        },
                                        child: Text(
                                          "Remove",
                                          style: AppTheme.textTheme.labelMedium
                                              ?.copyWith(
                                            fontSize: 14,
                                            color: AppTheme.errorColor,
                                          ),
                                        ),
                                      )
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                BottomBarButton(
                  child: Column(
                    children: [
                      BlocBuilder<ChatRoomDetailBloc, ChatRoomDetailState>(
                        builder: (context, state) {
                          // if isadmin
                          final authParticipant =
                              state.room.participants.firstWhere(
                            (p) =>
                                p.user.username ==
                                (context.read<HomeBloc>().state as HomeLoaded)
                                    .authenticatedUser
                                    .username,
                          );

                          if (!authParticipant.role.isAdmin) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  context.push(
                                    '/add-user-room',
                                    extra: AddUserRoomArgs(
                                      currentRoom: context
                                          .read<ChatRoomDetailBloc>()
                                          .state
                                          .room,
                                    ),
                                  );
                                },
                                child: const Text('Add User'),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context.push(
                            '/choose-category',
                            extra: ChooseCategoryArgs(
                              currentRoom:
                                  context.read<ChatRoomDetailBloc>().state.room,
                            ),
                          ),
                          child: const Text('Add Category'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        BlocConsumer<ChatRoomDetailBloc, ChatRoomDetailState>(
          listener: (context, state) {
            if (state.status.isError) {
              showDialog(
                context: context,
                builder: (dialogContext) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    contentPadding: const EdgeInsets.only(
                      left: 23,
                      right: 23,
                      top: 30,
                      bottom: 20,
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppErrorWidget(
                          iconColor: AppTheme.errorColor,
                          message:
                              state.failure?.message ?? const Failure().message,
                          subMessage: 'Please try again.',
                        ),
                      ],
                    ),
                    actions: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: Theme.of(context)
                                  .elevatedButtonTheme
                                  .style
                                  ?.copyWith(
                                    elevation: const WidgetStatePropertyAll(0),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: const BorderSide(
                                            color:
                                                AppTheme.secondaryBackground),
                                      ),
                                    ),
                                    backgroundColor:
                                        const WidgetStatePropertyAll(
                                      AppTheme.primaryBackground,
                                    ),
                                  ),
                              onPressed: () {
                                context.pop();
                              },
                              child: const Text(
                                'Close',
                                style: TextStyle(
                                  color: AppTheme.primaryText,
                                ),
                              ),
                            ),
                          ),
                          8.widthMargin,
                          Expanded(
                            child: ElevatedButton(
                              style: AppTheme
                                  .darkTheme.elevatedButtonTheme.style
                                  ?.copyWith(
                                backgroundColor: const WidgetStatePropertyAll(
                                  AppTheme.errorColor,
                                ),
                              ),
                              onPressed: () {
                                dialogContext.pop();
                              },
                              child: Text(
                                'Try again',
                                style: AppTheme.textTheme.labelMedium?.copyWith(
                                  color: AppTheme.primaryText,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            }
          },
          builder: (context, state) {
            if (state.status.isLoading) {
              return const LoadingOverlay();
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
