import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/feature/category/model/category.dart';
import 'package:categorease/feature/home/widgets/category_chip.dart';
import 'package:categorease/utils/extension.dart';
import 'package:flutter/material.dart';

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
