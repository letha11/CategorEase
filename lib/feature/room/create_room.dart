import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/feature/category/widget/bottom_bar_button.dart';
import 'package:categorease/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';

class CreateRoom extends StatelessWidget {
  const CreateRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Room'),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      controller: TextEditingController(text: 'ibkaanhar1'),
                      decoration: const InputDecoration(
                        hintText: 'Room name',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            KeyboardVisibilityBuilder(builder: (context, isVisible) {
              if (!isVisible) {
                return BottomBarButton(
                  child: ElevatedButton(
                    onPressed: () {
                      GoRouter.of(context).popUntil('/home');
                      GoRouter.of(context).push('/chat-room/1');
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
          ],
        ),
      ),
    );
  }
}
