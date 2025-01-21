import 'package:categorease/config/routes/app_router.dart';
import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/feature/category/cubit/choose_category/choose_category_cubit.dart';
import 'package:categorease/feature/category/model/category.dart';
import 'package:categorease/feature/category/widget/bottom_bar_button.dart';
import 'package:categorease/feature/category/widget/category_tile.dart';
import 'package:categorease/feature/home/widgets/category_chip.dart';
import 'package:categorease/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChooseCategory extends StatelessWidget {
  const ChooseCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Category'),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: BlocBuilder<ChooseCategoryCubit, ChooseCategoryState>(
                  builder: (context, state) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => CategoryTile(
                          category: state.categories[i],
                          onTap: (category) {
                            context
                                .read<ChooseCategoryCubit>()
                                .toggleCategory(category);
                          },
                          isActive: state.selectedCategories
                              .contains(state.categories[i]),
                        ),
                        childCount: state.categories.length,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          BottomBarButton(
            onButtonTap: () => GoRouter.of(context).go('/home'),
          ),
        ],
      ),
    );
  }
}
