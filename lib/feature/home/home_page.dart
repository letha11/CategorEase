import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/feature/chat/model/chat.dart';
import 'package:categorease/feature/home/cubit/home_page/home_page_cubit.dart';
import 'package:categorease/feature/home/widgets/category_chip.dart';
import 'package:categorease/feature/home/widgets/chat_tile.dart';
import 'package:categorease/feature/room/model/room.dart';
import 'package:categorease/gen/assets.gen.dart';
import 'package:categorease/utils/extension.dart';
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
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                height: 30,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 9),
                      child: CategoryChip(
                        backgroundColor: Color(0xFF347BD5),
                        category: 'Work',
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 9),
                      child: CategoryChip(
                        backgroundColor: Color(0xFF6548BC),
                        category: 'Friends',
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 9),
                      child: CategoryChip(
                        backgroundColor: Color(0xFF971FA0),
                        category: 'College',
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 9),
                      child: CategoryChip(
                        backgroundColor: Color(0xFF479948),
                        category: 'Family',
                      ),
                    ),
                    Padding(
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
                    ),
                  ],
                ),
              ),
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
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SvgPicture.asset(
                              Assets.icons.search,
                            ),
                          ),
                        ),
                        // onChanged: (_) {
                        //   GoRouter.of(context).push('/search');
                        // },
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
          BlocBuilder<HomePageCubit, HomePageState>(
            builder: (context, state) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final Room room = state.dummyRooms[index];
                    return ChatTile(
                      onTap: () => context.push('/chat-room/${room.id}'),
                      roomName: room.name,

                      // FIXME: 2 participants mean that 1 to 1 conversation so change the image.
                      imagePath: room.participants.length == 2
                          ? Assets.images.singleDefault.path
                          : Assets.images.groupDefaultPng.path,
                      lastMessage: room.lastChat?.content ?? '...',
                      unreadCount: room.unreadMessageCount,
                      categories: room.categories
                          .map(
                            (category) => Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: CategoryChip(
                                backgroundColor: category.hexColor.toColor(),
                                category: category.name,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2.5, horizontal: 10),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                  childCount: state.dummyRooms.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
