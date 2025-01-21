import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/feature/home/widgets/category_chip.dart';
import 'package:categorease/feature/home/widgets/chat_tile.dart';
import 'package:categorease/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
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
                          'assets/images/add.svg',
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
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for users',
                      suffixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SvgPicture.asset(
                          'assets/images/search.svg',
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final isEven = index % 2 == 0;
                return ChatTile(
                  username: isEven ? 'John Doe' : 'Goofy',
                  profileUrl: isEven
                      ? 'https://cdn-icons-png.flaticon.com/512/147/147144.png'
                      : 'https://i.scdn.co/image/ab67616d00001e028c6d178bff293a896f8e38e5',
                  message: 'Hey, how are you?',
                  unreadCount: isEven ? 0 : 3,
                  categories: isEven
                      ? [
                          const Padding(
                            padding: EdgeInsets.only(left: 6.0),
                            child: CategoryChip(
                              backgroundColor: Color(0xFF347BD5),
                              category: 'Work',
                              padding: EdgeInsets.symmetric(
                                  vertical: 2.5, horizontal: 10),
                            ),
                          ),
                        ]
                      : const [
                          Padding(
                            padding: EdgeInsets.only(left: 6.0),
                            child: CategoryChip(
                              backgroundColor: Color(0xFF347BD5),
                              category: 'Work',
                              padding: EdgeInsets.symmetric(
                                  vertical: 2.5, horizontal: 10),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 6.0),
                            child: CategoryChip(
                              backgroundColor: Color(0xFF6548BC),
                              category: 'Friends',
                              padding: EdgeInsets.symmetric(
                                  vertical: 2.5, horizontal: 10),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 6.0),
                            child: CategoryChip(
                              backgroundColor: Color(0xFF971FA0),
                              category: 'College',
                              padding: EdgeInsets.symmetric(
                                  vertical: 2.5, horizontal: 10),
                            ),
                          ),
                        ],
                );
              },
              childCount: 10,
            ),
          ),
        ],
      ),
    );
  }
}
