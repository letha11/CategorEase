import 'dart:async';

import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/core/failures.dart';
import 'package:categorease/feature/category/widget/bottom_bar_button.dart';
import 'package:categorease/feature/chat/bloc/add_user/add_user_bloc.dart';
import 'package:categorease/feature/chat/cubit/add_user_room/add_user_room_cubit.dart';
import 'package:categorease/feature/home/model/user.dart';
import 'package:categorease/feature/room/model/room.dart';
import 'package:categorease/feature/search/widgets/search_delegate.dart';
import 'package:categorease/feature/search/widgets/user_tile.dart';
import 'package:categorease/gen/assets.gen.dart';
import 'package:categorease/utils/extension.dart';
import 'package:categorease/utils/widgets/app_refresh_indicator.dart';
import 'package:categorease/utils/widgets/error_widget.dart';
import 'package:categorease/utils/widgets/loading.dart';
import 'package:categorease/utils/widgets/loading_overlay.dart';
import 'package:categorease/utils/widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class AddUserRoomArgs {
  final Room currentRoom;

  AddUserRoomArgs({required this.currentRoom});
}

class AddUserRoom extends StatefulWidget {
  const AddUserRoom({super.key});

  @override
  State<AddUserRoom> createState() => _AddUserRoomState();
}

class _AddUserRoomState extends State<AddUserRoom>
    with SingleTickerProviderStateMixin {
  late final FocusNode _focusNode;
  late AddUserLoaded? successSearchState;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _usernameController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;
  Timer? _debouncer;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: 200.milliseconds,
    );
    _animation = _animationController.drive<double>(
      Tween<double>(begin: -100, end: 0),
    );

    _focusNode = FocusNode();

    context.read<AddUserBloc>().add(const AddUserFetchUser(username: ''));

    // This is a workaround of [https://github.com/flutter/flutter/issues/106789]
    // an hero animation on textfield dismiss a keyboard.
    Future.delayed(const Duration(milliseconds: 400))
        .then((val) => _focusNode.requestFocus());

    _scrollController.addListener(() {
      if (successSearchState == null) return;

      if (_scrollController.position.pixels <=
          _scrollController.position.maxScrollExtent - 100) return;

      if (successSearchState!.nextPageStatus.isLoading) return;

      context.read<AddUserBloc>().add(AddUserFetchUserNextPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Stack(
        children: [
          AppRefreshIndicator(
            onRefresh: () async {
              context
                  .read<AddUserBloc>()
                  .add(AddUserFetchUser(username: _usernameController.text));
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                20.sliverHeightMargin,
                SliverPersistentHeader(
                  floating: true,
                  delegate: MySliverAppBarDelegate(
                    minHeight: 70,
                    maxHeight: 70,
                    child: Container(
                      color: AppTheme.primaryBackground,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Material(
                          child: TextField(
                            controller: _usernameController,
                            focusNode: _focusNode,
                            onChanged: (val) {
                              if (_debouncer?.isActive ?? false) {
                                _debouncer?.cancel();
                              }
                              _debouncer = Timer(200.milliseconds, () {
                                context
                                    .read<AddUserBloc>()
                                    .add(AddUserFetchUser(username: val));
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Search for users',
                              suffixIcon: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: SvgPicture.asset(
                                  Assets.icons.search,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                BlocBuilder<AddUserBloc, AddUserState>(
                  builder: (context, state) {
                    if (state is AddUserLoading || state is AddUserInitial) {
                      return const SliverPadding(
                        padding: EdgeInsets.only(top: 10.0),
                        sliver: SliverToBoxAdapter(
                          child: Center(child: Loading()),
                        ),
                      );
                    } else if (state is AddUserError) {
                      return SliverFillRemaining(
                        child: Center(
                          child: AppErrorWidget(
                            message: state.failure?.message ??
                                const Failure().message,
                            subMessage:
                                'You can refresh by pulling the current page',
                          ),
                        ),
                      );
                    }

                    successSearchState = state as AddUserLoaded;

                    if (successSearchState!.users.data.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: NoData(
                          message: 'No users found',
                        ),
                      );
                    }

                    return SliverList.builder(
                      itemBuilder: (context, index) {
                        if (index == (state.users.data.length + 1) - 1) {
                          return 60.heightMargin;
                        }
                        final User user = state.users.data[index];
                        return BlocBuilder<AddUserRoomCubit,
                            AddUserRoomCubitState>(
                          builder: (context, cubitState) {
                            return UserTile(
                              onTap: () => context
                                  .read<AddUserRoomCubit>()
                                  .toggleSelectedUsers(user.id),
                              username: user.username,
                              prefix: InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      5, 12.5, 5, 12.5),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        padding: const EdgeInsets.all(1),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppTheme.primaryInput,
                                            width: 1,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: cubitState.selectedUsers
                                                .contains(user.id)
                                            ? Container(
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppTheme.activeColor,
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                      ),
                                      10.widthMargin,
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      itemCount: state.users.data.length + 1,
                    );
                  },
                ),
                BlocBuilder<AddUserBloc, AddUserState>(
                  builder: (context, state) {
                    if (state is! AddUserLoaded) {
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
          BlocConsumer<AddUserRoomCubit, AddUserRoomCubitState>(
            listener: (context, state) {
              if (state.selectedUsers.isNotEmpty) {
                _animationController.forward();
              } else {
                _animationController.reverse();
              }
            },
            builder: (context, cubitState) => AnimatedBuilder(
              animation: _animation,
              builder: (context, state) {
                return Positioned(
                  bottom: _animation.value,
                  left: 0,
                  right: 0,
                  child: AnimatedOpacity(
                    duration: _animationController.duration ?? 200.milliseconds,
                    opacity: cubitState.selectedUsers.isNotEmpty ? 1 : 0,
                    child: BottomBarButton(
                      withWrapper: false,
                      child: ElevatedButton(
                        onPressed: cubitState.selectedUsers.isNotEmpty
                            ? () {
                                context.read<AddUserBloc>().add(
                                      AddUserUpdateRoom(
                                        selectedUserIds:
                                            cubitState.selectedUsers,
                                      ),
                                    );
                              }
                            : null,
                        child: const Text('Add'),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          BlocConsumer<AddUserBloc, AddUserState>(
              bloc: context.read<AddUserBloc>(),
              listener: (context, state) {
                if (state is AddUserLoaded && state.updatingStatus.isLoaded) {
                  context.pop(state.updatedRoom);
                }
              },
              builder: (context, state) {
                if (state is AddUserLoaded && state.updatingStatus.isLoading) {
                  return const LoadingOverlay();
                }

                return const SizedBox.shrink();
              }),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debouncer?.cancel();
    super.dispose();
  }
}
