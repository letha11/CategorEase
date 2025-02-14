import 'dart:developer';

import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/feature/category/create_category.dart';
import 'package:categorease/feature/chat/chat_room.dart';
import 'package:categorease/feature/home/bloc/home_bloc.dart';
import 'package:categorease/feature/home/cubit/home_page/home_page_cubit.dart';
import 'package:categorease/feature/home/widgets/category_chip.dart';
import 'package:categorease/feature/home/widgets/room_tile.dart';
import 'package:categorease/feature/room/model/room.dart';
import 'package:categorease/gen/assets.gen.dart';
import 'package:categorease/utils/extension.dart';
import 'package:categorease/utils/widgets/app_refresh_indicator.dart';
import 'package:categorease/utils/widgets/error_widget.dart';
import 'package:categorease/utils/widgets/loading.dart';
import 'package:categorease/utils/widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  late HomeLoaded? homeLoaded;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(FetchDataHome());

    _scrollController.addListener(() {
      if (homeLoaded == null) return;

      if (_scrollController.position.pixels <=
          _scrollController.position.maxScrollExtent - 100) return;

      if (homeLoaded!.nextPageStatus.isLoading) return;

      context.read<HomeBloc>().add(FetchDataHomeNext());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              Assets.icons.setting,
            ),
            onPressed: () async {
              GoRouter.of(context).push('/setting');
            },
          ),
        ],
      ),
      body: AppRefreshIndicator(
        onRefresh: () async {
          context.read<HomePageCubit>().toggleSelectedCategory(
              context.read<HomePageCubit>().state.selectedCategory);
          context.read<HomeBloc>().add(FetchDataHome());
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is! HomeLoaded) {
                    return const SizedBox.shrink();
                  } else if (state.categories == null ||
                      (state.categories?.isEmpty ?? false)) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                      child: SizedBox(
                        width: double.infinity,
                        child: CategoryChip(
                          onTap: () async {
                            dynamic shouldRefresh =
                                await GoRouter.of(context).push(
                              '/create-category',
                              extra:
                                  CreateCategoryArgs(rooms: state.rooms.data),
                            );

                            if (shouldRefresh is bool && shouldRefresh) {
                              context.read<HomeBloc>().add(FetchDataHome());
                            }
                          },
                          backgroundColor: AppTheme.primaryButton,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 3,
                            vertical: 2.5,
                          ),
                          child: SvgPicture.asset(
                            Assets.icons.add,
                          ),
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      height: 32,
                      child: ListView.builder(
                        itemCount:
                            state.categories!.length + 1, // for '+' button
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) {
                          /// Add button
                          if (i == state.categories!.length) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: CategoryChip(
                                onTap: () async {
                                  dynamic shouldRefresh =
                                      await GoRouter.of(context).push(
                                    '/create-category',
                                    extra: CreateCategoryArgs(
                                        rooms: state.rooms.data),
                                  );

                                  if (shouldRefresh is bool && shouldRefresh) {
                                    context
                                        .read<HomeBloc>()
                                        .add(FetchDataHome());
                                  }
                                },
                                backgroundColor: AppTheme.primaryButton,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                  vertical: 2.5,
                                ),
                                child: SvgPicture.asset(
                                  Assets.icons.add,
                                ),
                              ),
                            );
                          }

                          final category = state.categories![i];

                          return Padding(
                            padding: EdgeInsets.only(
                              left: i == 0 ? 16 : 0,
                              right: i == (state.categories!.length) ? 16 : 9,
                            ),
                            child: BlocBuilder<HomePageCubit, HomePageState>(
                              builder: (context, cubitState) {
                                return CategoryChip(
                                  backgroundColor: category.hexColor.toColor(),
                                  category: category.name,
                                  active: context
                                          .read<HomePageCubit>()
                                          .state
                                          .selectedCategory ==
                                      category.id,
                                  onTap: () {
                                    context
                                        .read<HomePageCubit>()
                                        .toggleSelectedCategory(category.id);

                                    context.read<HomeBloc>().add(
                                          FilterHomeByCategory(
                                            categoryId: context
                                                        .read<HomePageCubit>()
                                                        .state
                                                        .selectedCategory ==
                                                    0
                                                ? null
                                                : context
                                                    .read<HomePageCubit>()
                                                    .state
                                                    .selectedCategory,
                                          ),
                                        );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: 16.heightMargin,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Hero(
                      tag: 'search',
                      child: Material(
                        child: TextField(
                          onTap: () => GoRouter.of(context).push('/search'),
                          canRequestFocus: false,
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
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: (28 - 7).heightMargin,
            ),
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading) {
                  return const SliverToBoxAdapter(
                    child: Center(child: Loading()),
                  );
                } else if (state is HomeError) {
                  return SliverToBoxAdapter(
                      child: AppErrorWidget(
                    message: state.failure.message,
                    subMessage: 'You can refresh by pulling the current page',
                  ));
                } else if (state is HomeLoaded &&
                    state.rooms.data.isEmpty &&
                    !state.nextPageStatus.isLoading) {
                  homeLoaded = state;
                  if (homeLoaded != null) {
                    log("WEBSOCKET_MODEL: ${homeLoaded?.websocketModels}");
                  }

                  return const SliverToBoxAdapter(
                    child: NoData(
                      message: 'No Rooms found',
                    ),
                  );
                } else if (state is HomeLoaded && state.rooms.data.isNotEmpty) {
                  homeLoaded = state;
                  if (homeLoaded != null) {
                    log("WEBSOCKET_MODEL: ${homeLoaded?.websocketModels}");
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final Room room = state.rooms.data[index];
                        return RoomTile(
                          onTap: () async {
                            context
                                .read<HomeBloc>()
                                .add(UpdateLastViewedRoom(roomId: room.id));

                            await context.push(
                              '/chat-room/${room.id}',
                              extra: ChatRoomArgs(
                                websocketModel: state.websocketModels!
                                    .firstWhere((r) => r.roomId == room.id),
                                roomId: room.id,
                              ),
                            );

                            //update after finish chatting inside of a room
                            context
                                .read<HomeBloc>()
                                .add(UpdateLastViewedRoom(roomId: room.id));
                          },
                          roomName: room.name,
                          imagePath: room.participants.length == 2
                              ? Assets.images.singleDefault.path
                              : Assets.images.groupDefaultPng.path,
                          lastMessage: room.lastChat?.content ?? '...',
                          lastMessageSentAt: room.lastChat?.createdAt,
                          unreadCount: room.unreadMessageCount,
                          categories: room.categories
                              .map(
                                (category) => Padding(
                                  padding: const EdgeInsets.only(left: 6.0),
                                  child: CategoryChip(
                                    backgroundColor:
                                        category.hexColor.toColor(),
                                    category: category.name,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.5, horizontal: 10),
                                    onTap: () {
                                      context
                                          .read<HomePageCubit>()
                                          .toggleSelectedCategory(category.id);

                                      context.read<HomeBloc>().add(
                                            FilterHomeByCategory(
                                              categoryId: context
                                                          .read<HomePageCubit>()
                                                          .state
                                                          .selectedCategory ==
                                                      0
                                                  ? null
                                                  : context
                                                      .read<HomePageCubit>()
                                                      .state
                                                      .selectedCategory,
                                            ),
                                          );
                                    },
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                      childCount: state.rooms.data.length,
                    ),
                  );
                } else {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }
              },
            ),
            SliverToBoxAdapter(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is! HomeLoaded) {
                    return const SizedBox.shrink();
                  }

                  if (!state.nextPageStatus.isLoading) {
                    return 70.heightMargin;
                  }

                  return const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 70),
                    child: Center(
                      child: Loading(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
