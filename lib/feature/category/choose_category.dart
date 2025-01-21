import 'package:categorease/config/routes/app_router.dart';
import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/feature/category/cubit/choose_category_cubit.dart';
import 'package:categorease/feature/category/model/category.dart';
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: AppTheme.secondaryBackground,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 25),
              child: ElevatedButton(
                onPressed: () async {
                  GoRouter.of(context).go(
                    '/home',
                  );
                },
                child: Text(
                  'Submit',
                  style: AppTheme.textTheme.labelMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.category,
    required this.onTap,
    this.isActive = false,
  });

  final Category category;
  final Function(Category) onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (12.5 / 2).heightMargin,
        InkWell(
          onTap: () => onTap(category),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 12.5, 5, 12.5),
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
                  child: isActive
                      ? Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.activeColor,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                10.widthMargin,
                CategoryChip(
                  backgroundColor: category.hexColor.toColor(),
                  category: category.name,
                ),
              ],
            ),
          ),
        ),
        (12.5 / 2).heightMargin,
        const Divider(
          height: 1,
          color: AppTheme.primaryDivider,
        )
      ],
    );
  }
}
