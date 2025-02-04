import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/core/auth_storage.dart';
import 'package:categorease/core/service_locator.dart';
import 'package:categorease/feature/home/bloc/home_bloc.dart';
import 'package:categorease/feature/home/widgets/category_chip.dart';
import 'package:categorease/feature/home/widgets/chat_tile.dart';
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
            onPressed: () {
              GoRouter.of(context).push('/setting');
            },
          ),
        ],
      ),
      body: AppRefreshIndicator(
        onRefresh: () async {
          context.read<HomeBloc>().add(FetchDataHome());
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is! HomeLoaded) {
                    return const SizedBox.shrink();
                  } else if (state.categories == null) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: CategoryChip(
                        onTap: () =>
                            GoRouter.of(context).push('/create-category'),
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

                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      height: 30,
                      child: ListView.builder(
                        itemCount:
                            state.categories!.length + 1, // for '+' button
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) {
                          if (i == state.categories!.length) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: CategoryChip(
                                onTap: () => GoRouter.of(context)
                                    .push('/create-category'),
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
                            child: CategoryChip(
                              backgroundColor: category.hexColor.toColor(),
                              category: category.name,
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
                    (state.rooms?.isEmpty ?? false)) {
                  return const SliverToBoxAdapter(
                    child: NoData(
                      message: 'No Rooms found',
                    ),
                  );
                } else if (state is HomeLoaded && state.rooms != null) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final Room room = state.rooms![index];
                        return ChatTile(
                          onTap: () => context.push('/chat-room/${room.id}'),
                          roomName: room.name,

                          // FIXME: 2 participants mean that 1 to 1 conversation so change the image.
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
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                      childCount: state.rooms!.length,
                    ),
                  );
                } else {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
