import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
                return Column(
                  children: [
                    7.heightMargin,
                    InkWell(
                      onTap: () {
                        debugPrint("chat tapped...");
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 7, bottom: 7, left: 16, right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: () {
                                    debugPrint("avatar tapped...");
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppTheme.primaryButton,
                                    ),
                                  ),
                                ),
                                10.widthMargin,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          isEven ? 'Ibka' : 'Jono',
                                          style: AppTheme.textTheme.titleSmall,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 6.0),
                                          child: CategoryChip(
                                            backgroundColor: Color(0xFF347BD5),
                                            category: 'Work',
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.5, horizontal: 10),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 6.0),
                                          child: CategoryChip(
                                            backgroundColor: Color(0xFF6548BC),
                                            category: 'Friends',
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.5, horizontal: 10),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 6.0),
                                          child: CategoryChip(
                                            backgroundColor: Color(0xFF971FA0),
                                            category: 'College',
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.5, horizontal: 10),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Unread Message Text
                                    isEven
                                        ? Text(
                                            'Halo apa kabar, bagaimana semuanya...',
                                            style: AppTheme.textTheme.bodyLarge,
                                          )
                                        :
                                        // Read Message text
                                        Text(
                                            'Done',
                                            style: AppTheme.textTheme.bodyLarge
                                                ?.copyWith(
                                              color: AppTheme.primaryText
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '11.45pm',
                                  style:
                                      AppTheme.textTheme.bodyMedium?.copyWith(
                                    color:
                                        AppTheme.primaryText.withOpacity(0.5),
                                  ),
                                ),
                                if (isEven)
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 11, 10),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppTheme.activeColor,
                                    ),
                                    child: Text(
                                      '1',
                                      style: AppTheme.textTheme.bodyLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    7.heightMargin,
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        height: 1,
                        color: AppTheme.primaryDivider,
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

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.backgroundColor,
    this.category,
    this.child,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 7,
    ),
  }) : assert(
          category != null || child != null,
          'Either category or child must be provided',
        );

  final Color backgroundColor;
  final EdgeInsets padding;
  final String? category;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: padding,
      child: Center(
        child: child != null
            ? child!
            : Text(
                category!,
                style: AppTheme.textTheme.labelSmall?.copyWith(
                  fontSize: 12,
                ),
              ),
      ),
    );
  }
}
