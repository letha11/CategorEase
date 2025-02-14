import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/core/failures.dart';
import 'package:categorease/feature/category/bloc/create_category_bloc.dart';
import 'package:categorease/feature/category/cubit/create_category/create_category_cubit.dart';
import 'package:categorease/feature/category/widget/bottom_bar_button.dart';
import 'package:categorease/feature/home/widgets/category_chip.dart';
import 'package:categorease/gen/assets.gen.dart';
import 'package:categorease/utils/extension.dart';
import 'package:categorease/utils/widgets/error_widget.dart';
import 'package:categorease/utils/widgets/loading.dart';
import 'package:categorease/utils/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';

class CreateCategory extends StatefulWidget {
  const CreateCategory({
    super.key,
  });

  @override
  State<CreateCategory> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController nameController = TextEditingController();
  late CreateCategoryBlocState blocState;

  @override
  void initState() {
    context.read<CreateCategoryBloc>().add(CreateCategoryFetchRoom());

    _scrollController.addListener(() {
      if (blocState.rooms == null) return;

      if (_scrollController.position.pixels <=
          _scrollController.position.maxScrollExtent - 100) return;

      if (blocState.roomStatus.isLoading) return;
      context.read<CreateCategoryBloc>().add(CreateCategoryFetchNextRoom());
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Category'),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              20.heightMargin,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BlocBuilder<CreateCategoryCubit,
                                      CreateCategoryState>(
                                    builder: (context, state) {
                                      return CategoryChip(
                                        backgroundColor: state.pickedColor,
                                        category: state.previewText.isEmpty
                                            ? 'Placeholder'
                                            : state.previewText,
                                        onTap: () {},
                                      );
                                    },
                                  ),
                                ],
                              ),
                              16.heightMargin,
                              Text(
                                'Name',
                                style: AppTheme.textTheme.titleMedium,
                              ),
                              10.heightMargin,
                              TextFormField(
                                controller: nameController,
                                onChanged: (val) {
                                  context
                                      .read<CreateCategoryCubit>()
                                      .updatePreviewText(val);
                                },
                                validator: (val) {
                                  if (val == null || val == '') {
                                    return 'Category name cannot be empty';
                                  }

                                  return null;
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
                                  BlocBuilder<CreateCategoryCubit,
                                      CreateCategoryState>(
                                    builder: (context, state) {
                                      return GestureDetector(
                                        onTap: () => _showDialog(context),
                                        child: Container(
                                          height: 200,
                                          decoration: BoxDecoration(
                                            color: state.pickedColor,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
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
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                      child: const Text('Pick a Color'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        16.heightMargin,
                        Text(
                          'Rooms',
                          style: AppTheme.textTheme.titleMedium,
                        ),
                        BlocBuilder<CreateCategoryBloc,
                            CreateCategoryBlocState>(
                          builder: (context, state) {
                            if (state.createCategoryStatus.isError) {
                              return const SizedBox.shrink();
                            } else if (!state.isRoomEmpty) {
                              return const SizedBox.shrink();
                            }

                            return Text(
                              state.failure?.message ??
                                  'Room must be selected at least 1',
                              style: AppTheme.textTheme.bodySmall?.copyWith(
                                color: AppTheme.errorColor,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<CreateCategoryCubit, CreateCategoryState>(
                  builder: (context, cubitState) {
                    return BlocBuilder<CreateCategoryBloc,
                        CreateCategoryBlocState>(
                      builder: (context, bState) {
                        if (bState.rooms == null) {
                          return const SliverToBoxAdapter(
                              child: SizedBox.shrink());
                        }

                        return SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, i) {
                                final room = bState.rooms!.data[i];
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        context
                                            .read<CreateCategoryCubit>()
                                            .toggleSelectedRoom(room.id);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 12.5, 5, 12.5),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              flex: 1,
                                              child: Container(
                                                width: 20,
                                                height: 20,
                                                padding:
                                                    const EdgeInsets.all(1),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:
                                                        AppTheme.primaryInput,
                                                    width: 1,
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: cubitState.selectedRooms
                                                        .contains(room.id)
                                                    ? Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: AppTheme
                                                              .activeColor,
                                                        ),
                                                      )
                                                    : const SizedBox.shrink(),
                                              ),
                                            ),
                                            10.widthMargin,
                                            Flexible(
                                              flex: 5,
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    flex: 1,
                                                    child: Material(
                                                      shape:
                                                          const CircleBorder(),
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      color: Colors.transparent,
                                                      child: Ink.image(
                                                        image: AssetImage(room
                                                                    .participants
                                                                    .length >
                                                                2
                                                            ? Assets
                                                                .images
                                                                .groupDefaultPng
                                                                .path
                                                            : Assets
                                                                .images
                                                                .singleDefault
                                                                .path),
                                                        width: 50,
                                                        height: 50,
                                                      ),
                                                    ),
                                                  ),
                                                  10.widthMargin,
                                                  Expanded(
                                                    flex: 5,
                                                    child: Text(
                                                      room.name,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: AppTheme
                                                          .textTheme.titleSmall,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    (12.5 / 2).heightMargin,
                                    const Divider(
                                      height: 1,
                                      color: AppTheme.primaryDivider,
                                    ),
                                  ],
                                );
                              },
                              childCount: bState.rooms!.data.length,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                // Loading indicator of room fetching and next room fetching
                BlocBuilder<CreateCategoryBloc, CreateCategoryBlocState>(
                  builder: (context, state) {
                    if (state.roomStatus.isLoading) {
                      return const SliverPadding(
                        padding: EdgeInsets.only(top: 15),
                        sliver: SliverToBoxAdapter(
                          child: Center(child: Loading()),
                        ),
                      );
                    }

                    return const SliverToBoxAdapter(
                      child: SizedBox.shrink(),
                    );
                  },
                ),
                SliverToBoxAdapter(
                  child: 100.heightMargin,
                ),
              ],
            ),
            KeyboardVisibilityBuilder(
              builder: (context, isVisible) {
                if (!isVisible) {
                  return BlocBuilder<CreateCategoryBloc,
                      CreateCategoryBlocState>(
                    builder: (context, state) {
                      return BottomBarButton(
                        child: ElevatedButton(
                          onPressed: state.createCategoryStatus.isLoading
                              ? null
                              : () {
                                  if (!formKey.currentState!.validate()) return;

                                  context.read<CreateCategoryBloc>().add(
                                        CreateCategoryCreate(
                                          name: nameController.text,
                                          roomIds: context
                                              .read<CreateCategoryCubit>()
                                              .state
                                              .selectedRooms,
                                          color: context
                                              .read<CreateCategoryCubit>()
                                              .state
                                              .pickedColor
                                              .toHex,
                                        ),
                                      );
                                },
                          child: Text(
                            'Submit',
                            style: AppTheme.textTheme.labelMedium,
                          ),
                        ),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
            BlocConsumer<CreateCategoryBloc, CreateCategoryBlocState>(
              listener: (context, state) {
                blocState = state;
                if (state.createCategoryStatus.isLoaded) {
                  context.pop(true);
                } else if (state.createCategoryStatus.isError &&
                    !state.isRoomEmpty) {
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
                              message: state.failure?.message ??
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
                                    context.read<CreateCategoryBloc>().add(
                                          CreateCategoryCreate(
                                            name: nameController.text,
                                            roomIds: context
                                                .read<CreateCategoryCubit>()
                                                .state
                                                .selectedRooms,
                                            color: context
                                                .read<CreateCategoryCubit>()
                                                .state
                                                .pickedColor
                                                .toHex,
                                          ),
                                        );
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
                if (state.createCategoryStatus.isLoading) {
                  return const LoadingOverlay();
                }

                return const SizedBox.shrink();
              },
            ),
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
