import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/core/failures.dart';
import 'package:categorease/feature/category/bloc/choose_category/choose_category_bloc.dart';
import 'package:categorease/feature/category/cubit/choose_category/choose_category_cubit.dart';
import 'package:categorease/feature/category/model/category.dart';
import 'package:categorease/feature/category/widget/bottom_bar_button.dart';
import 'package:categorease/feature/category/widget/category_tile.dart';
import 'package:categorease/feature/room/model/room.dart';
import 'package:categorease/utils/extension.dart';
import 'package:categorease/utils/widgets/app_refresh_indicator.dart';
import 'package:categorease/utils/widgets/error_widget.dart';
import 'package:categorease/utils/widgets/loading.dart';
import 'package:categorease/utils/widgets/loading_overlay.dart';
import 'package:categorease/utils/widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChooseCategoryArgs {
  final Room currentRoom;

  ChooseCategoryArgs({required this.currentRoom});
}

class ChooseCategory extends StatefulWidget {
  const ChooseCategory({super.key, required this.currentRoom});

  final Room currentRoom;

  @override
  State<ChooseCategory> createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends State<ChooseCategory> {
  @override
  void initState() {
    super.initState();

    context.read<ChooseCategoryBloc>().add(ChooseCategoryFetchCategories());

    for (Category cat in widget.currentRoom.categories) {
      context.read<ChooseCategoryCubit>().toggleCategory(cat);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Category'),
      ),
      body: Stack(
        children: [
          AppRefreshIndicator(
            onRefresh: () async => context
                .read<ChooseCategoryBloc>()
                .add(ChooseCategoryFetchCategories()),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: BlocBuilder<ChooseCategoryCubit,
                      ChooseCategoryCubitState>(
                    builder: (context, cubitState) {
                      return BlocBuilder<ChooseCategoryBloc,
                          ChooseCategoryState>(
                        builder: (context, state) {
                          if (state is CCInitialLoading || state is CCInitial) {
                            return const SliverToBoxAdapter(
                              child: Center(
                                child: Loading(),
                              ),
                            );
                          } else if (state is CCInitialError) {
                            return SliverToBoxAdapter(
                              child: AppErrorWidget(
                                message: state.failure?.message ??
                                    const Failure().message,
                              ),
                            );
                          } else if (state is CCInitialLoaded &&
                              state.categories.isEmpty) {
                            return const SliverToBoxAdapter(
                              child: NoData(),
                            );
                          }
                          final castedState = state as CCInitialLoaded;

                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, i) => CategoryTile(
                                category: castedState.categories[i],
                                onTap: (category) {
                                  context
                                      .read<ChooseCategoryCubit>()
                                      .toggleCategory(category);
                                },
                                isActive: cubitState.selectedCategories
                                    .contains(state.categories[i]),
                              ),
                              childCount: state.categories.length,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          BottomBarButton(
            child: ElevatedButton(
              onPressed: () {
                final selectedCategories = context
                    .read<ChooseCategoryCubit>()
                    .state
                    .selectedCategories;
                context.read<ChooseCategoryBloc>().add(ChooseCategoryUpdateRoom(
                    selectedCategories: selectedCategories));
              },
              child: Text(
                'Submit',
                style: AppTheme.textTheme.labelMedium,
              ),
            ),
          ),
          BlocConsumer<ChooseCategoryBloc, ChooseCategoryState>(
              bloc: context.read<ChooseCategoryBloc>(),
              listener: (context, state) {
                if (state is! CCInitialLoaded) return;

                if (state.updateStatus.isLoaded) {
                  context.pop();
                } else if (state.updateStatus.isError) {
                  showDialog(
                    context: context,
                    builder: (dialogContext) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        contentPadding: const EdgeInsets.only(
                          left: 23,
                          right: 23,
                          top: 30,
                          bottom: 20,
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppErrorWidget(
                              iconColor: AppTheme.errorColor,
                              message: state.updateFailure?.message ??
                                  const Failure().message,
                              subMessage: 'Please try again.',
                            ),
                          ],
                        ),
                        actions: [
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: Theme.of(context)
                                      .elevatedButtonTheme
                                      .style
                                      ?.copyWith(
                                        elevation:
                                            const WidgetStatePropertyAll(0),
                                        shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: const BorderSide(
                                                color: AppTheme
                                                    .secondaryBackground),
                                          ),
                                        ),
                                        backgroundColor:
                                            const WidgetStatePropertyAll(
                                          AppTheme.primaryBackground,
                                        ),
                                      ),
                                  onPressed: () {
                                    context.pop();
                                  },
                                  child: const Text(
                                    'Close',
                                    style: TextStyle(
                                      color: AppTheme.primaryText,
                                    ),
                                  ),
                                ),
                              ),
                              8.widthMargin,
                              Expanded(
                                child: ElevatedButton(
                                  style: AppTheme
                                      .darkTheme.elevatedButtonTheme.style
                                      ?.copyWith(
                                    backgroundColor:
                                        const WidgetStatePropertyAll(
                                      AppTheme.errorColor,
                                    ),
                                  ),
                                  onPressed: () {
                                    dialogContext.pop();
                                    final selectedCategories = context
                                        .read<ChooseCategoryCubit>()
                                        .state
                                        .selectedCategories;
                                    context.read<ChooseCategoryBloc>().add(
                                        ChooseCategoryUpdateRoom(
                                            selectedCategories:
                                                selectedCategories));
                                  },
                                  child: Text(
                                    'Try again',
                                    style: AppTheme.textTheme.labelMedium
                                        ?.copyWith(
                                      color: AppTheme.primaryText,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              builder: (context, state) {
                if (state is CCInitialLoaded && state.updateStatus.isLoaded) {
                  return const LoadingOverlay();
                }

                return const SizedBox.shrink();
              }),
        ],
      ),
    );
  }
}
