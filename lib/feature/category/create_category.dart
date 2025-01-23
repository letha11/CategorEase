import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/feature/category/cubit/create_category/create_category_cubit.dart';
import 'package:categorease/feature/category/widget/bottom_bar_button.dart';
import 'package:categorease/feature/home/widgets/category_chip.dart';
import 'package:categorease/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';

class CreateCategory extends StatelessWidget {
  CreateCategory({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Category'),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.heightMargin,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BlocBuilder<CreateCategoryCubit, CreateCategoryState>(
                            builder: (context, state) {
                          return CategoryChip(
                            backgroundColor: state.pickedColor,
                            category: state.previewText.isEmpty
                                ? 'Placeholder'
                                : state.previewText,
                            onTap: () {},
                          );
                        }),
                      ],
                    ),
                    16.heightMargin,
                    Text(
                      'Name',
                      style: AppTheme.textTheme.titleMedium,
                    ),
                    10.heightMargin,
                    TextFormField(
                      controller: context
                          .read<CreateCategoryCubit>()
                          .state
                          .nameController,
                      onChanged: (val) {
                        context
                            .read<CreateCategoryCubit>()
                            .updatePreviewText(val);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Category Name',
                      ),
                    ),
                    16.heightMargin,
                    Text(
                      'Color',
                      style: AppTheme.textTheme.titleMedium,
                    ),
                    10.heightMargin,
                    Column(
                      children: [
                        BlocBuilder<CreateCategoryCubit, CreateCategoryState>(
                            builder: (context, state) {
                          return GestureDetector(
                            onTap: () => _showDialog(context),
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                color: state.pickedColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                            ),
                          );
                        }),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _showDialog(context),
                            style: Theme.of(context)
                                .elevatedButtonTheme
                                .style
                                ?.copyWith(
                                  shape: WidgetStateProperty.all(
                                    const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                            child: const Text('Pick a Color'),
                          ),
                        ),
                      ],
                    ),
                    KeyboardVisibilityBuilder(builder: (context, isVisible) {
                      if (isVisible) return 120.heightMargin;

                      return 0.heightMargin;
                    }),
                  ],
                ),
              ),
            ),
            KeyboardVisibilityBuilder(builder: (context, isVisible) {
              if (!isVisible) {
                return BottomBarButton(
                  child: ElevatedButton(
                    onPressed: () => GoRouter.of(context).go('/home'),
                    child: Text(
                      'Submit',
                      style: AppTheme.textTheme.labelMedium,
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        Color selectedColor =
            context.read<CreateCategoryCubit>().state.pickedColor;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                10.heightMargin,
                ColorPicker(
                  pickerColor: selectedColor,
                  onColorChanged: (color) {
                    selectedColor = color;
                  },
                ),
              ],
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context
                      .read<CreateCategoryCubit>()
                      .updatePickedColor(selectedColor);
                  context.pop();
                },
                child: const Text('Choose'),
              ),
            )
          ],
        );
      },
    );
  }
}
