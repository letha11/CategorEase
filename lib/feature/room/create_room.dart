import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/core/failures.dart';
import 'package:categorease/feature/category/widget/bottom_bar_button.dart';
import 'package:categorease/feature/home/bloc/home_bloc.dart';
import 'package:categorease/feature/home/model/user.dart';
import 'package:categorease/feature/room/bloc/create_room/create_room_bloc.dart';
import 'package:categorease/utils/extension.dart';
import 'package:categorease/utils/widgets/error_widget.dart';
import 'package:categorease/utils/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';

class CreateRoomArgs {
  final User user;

  CreateRoomArgs({required this.user});
}

class CreateRoom extends StatefulWidget {
  final User selectedUser;

  const CreateRoom({super.key, required this.selectedUser});

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController(text: widget.selectedUser.username);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Room'),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            SizedBox.expand(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.heightMargin,
                        Text(
                          'Name',
                          style: AppTheme.textTheme.titleMedium,
                        ),
                        10.heightMargin,
                        TextFormField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            hintText: 'Room name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Room name cannot be empty';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            KeyboardVisibilityBuilder(builder: (context, isVisible) {
              if (!isVisible) {
                return BottomBarButton(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _triggerAction(context);
                      }
                    },
                    child: Text(
                      'Create Room',
                      style: AppTheme.textTheme.labelMedium,
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            }),
            BlocConsumer<CreateRoomBloc, CreateRoomState>(
              listener: (context, state) {
                if (state is CreateRoomSuccess) {
                  // GoRouter.of(context).popUntil('/home');
                  context.pop();
                  context.pop(true);
                } else if (state is CreateRoomError) {
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
                              message: state.failure.message,
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
                                    _triggerAction(context);
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
                if (state is CreateRoomLoading) {
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

  _triggerAction(BuildContext context) {
    context.read<CreateRoomBloc>().add(
          CreateRoomRequested(
            roomName: _textController.value.text,
            userId: widget.selectedUser.id,
          ),
        );
  }
}
